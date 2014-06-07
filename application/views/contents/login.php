<!DOCTYPE html>
<html class="bg-black">
    <head>
        <meta charset="UTF-8">
        <title>Warehouse System | Log in</title>
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <!-- bootstrap 3.0.2 -->
        <link href="../../dwhproject/media/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <!-- font Awesome -->
        <link href="../../dwhproject/media/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <!-- Theme style -->
        <link href="../../dwhproject/media/css/AdminLTE.css" rel="stylesheet" type="text/css" />
		
		<!-- Animate -->
        <link href="../../dwhproject/media/css/animate/animate.css" rel="stylesheet" type="text/css" />

		<!-- jquery -->
		<script src="../../dwhproject/media/js/dxchart/jquery-1.10.2.min.js"></script>
		
		<!-- Engine -->
		<script src="../../dwhproject/media/js/core/ab-engine.js"></script>
		
        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
          <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
        <![endif]-->
    </head>
    <body class="bg-black">

        <div class="form-box animated slideInDown" id="login-box">
            <div class="header">Sign In</div>
            <form method="post" id="loginForm">
                <div class="body bg-gray">
                    <div class="form-group">
                        <input type="text" name="username" class="form-control" placeholder="Username"/>
                    </div>
                    <div class="form-group">
                        <input type="password" name="password" class="form-control" placeholder="Password"/>
                    </div>          
                </div>
                <div class="footer">                                                               
                    <button type="submit" class="btn bg-olive btn-block">Sign me in</button>  
                    
                    <!--<p><a href="#">I forgot my password</a></p>
                    <a href="register.html" class="text-center">Register a new membership</a>-->
					
                </div>
            </form>
        </div>

        <!-- Bootstrap -->
        <script src="../../dwhproject/media/js/bootstrap.min.js" type="text/javascript"></script>  
		<!-- Login js handler -->
		<script src="../../dwhproject/media/js/ContentJS/login.js"></script>

    </body>
</html>