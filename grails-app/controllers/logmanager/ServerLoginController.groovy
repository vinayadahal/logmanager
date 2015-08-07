package logmanager


import com.jcraft.jsch.*

class ServerLoginController {
    public Session session
    public ChannelExec channel
    public StringBuilder builder, oldBuilder
    Thread tailThread

    String user
    String password
    String host
    String port
    String tomcatLoc

    def index() {
        render(view: "Index", model: [ipaddr: ServerList.findAll()])
    }

    def connectServer() {
        tomcatLoc = params.location
        JSch jsch = new JSch();
        session = jsch.getSession(user, host, port.toInteger())
        session.setPassword(password)
        session.setConfig("StrictHostKeyChecking", "no")
        println("Establishing Connection...")
        session.setConfig("PreferredAuthentications", "publickey,keyboard-interactive,password")
        println("config set complete. connecting...")
        try {
            session.connect()

        } catch (Exception e) {
            println('expection caught: ' + e)
        }
        println("Connection established.")
        println("Creating command channel.")
        channel = (ChannelExec) session.openChannel("exec")
        render(template: 'options')
    }

    def home() {
        user = params?.username
        password = params?.password
        host = params?.ip
        port = params?.port

        if (user.isEmpty() || password.isEmpty() || host.isEmpty() || port.isEmpty()) {
            redirect(action: 'index')
        }

        println('Retriving tomcat location for requested server')
        def server_id = ServerList.findByIp(host)
        def tomcatLocation = TomcatLocation.findAllByServer_id(server_id.id)
        println("tomcat list:- " + tomcatLocation.tomcat_location)
        render(view: "Home", model: [tomcatLocation: tomcatLocation])
    }

    def GetLog() {
        tailThread = new Thread() {
            @Override
            public void run() {
                try {
                    println("Tailing log...")
                    BufferedReader input = new BufferedReader(new InputStreamReader(channel.getInputStream()))
                    channel.setCommand("tail -f " + tomcatLoc + "logs/catalina.out;")
                    channel.connect()

                    println("Creating file")
                    File file = new File("D:\\logFile.txt");
                    File filePath = file.getAbsoluteFile();
                    if (!file.exists()) {
                        file.createNewFile();
                    }

                    String msg = null;
                    builder = new StringBuilder()
                    while ((msg = input.readLine()) != null) {
                        builder.append(msg).append('\n')
                        println(msg)

                        Writer output
                        output = new BufferedWriter(new FileWriter(file.getAbsoluteFile(), true))
                        output.append(msg + "\n")
                        output.close()


                    }
                } catch (Exception ex) {
                    println(ex)
                }
            }
        };
        tailThread.start();
        println("Thread call complete.")
        render(template: "response")
    }

    def checkTailStatus() {
        render(template: "checkTail", model: [tailStat: checkThreadAlive()])
    }

    def showInGsp() {
        if (builder.length() > 0) {
            render(template: 'log', model: [log: builder])
        } else {
            render(text: 'oldLog', contentType: "text/xml", encoding: "UTF-8")
        }
        builder.setLength(0)
    }

    def disconnectServer() {
        if (checkThreadAlive()) {
            println("Killing thread...")
            tailThread.interrupt()
        }
        println("Disconnecting from server...")
        session.disconnect()
        render(template: 'disconnect', model: [message: 'disconnected'])
    }

    def checkThreadAlive() {
        try {
            if (tailThread.isAlive()) {
                return true
            } else {
                return false
            }
        } catch (Exception ex) {
            println("exception caught" + ex)
        }

    }

}
