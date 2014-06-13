<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Warehouse System</title>
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <!-- bootstrap 3.0.2 -->
        <link href="../../dwhproject/media/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <!-- font Awesome -->
        <link href="../../dwhproject/media/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <!-- Ionicons -->
        <link href="../../dwhproject/media/css/ionicons.min.css" rel="stylesheet" type="text/css" />
        <!-- Morris chart -->
        <link href="../../dwhproject/media/css/morris/morris.css" rel="stylesheet" type="text/css" />
        <!-- jvectormap -->
        <link href="../../dwhproject/media/css/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
        <!-- fullCalendar -->
        <link href="../../dwhproject/media/css/fullcalendar/fullcalendar.css" rel="stylesheet" type="text/css" />
        <!-- Daterange picker -->
        <link href="../../dwhproject/media/css/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
        <!-- bootstrap wysihtml5 - text editor -->
        <link href="../../dwhproject/media/css/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css" rel="stylesheet" type="text/css" />
        <!-- Theme style -->
        <link href="../../dwhproject/media/css/AdminLTE.css" rel="stylesheet" type="text/css" />
		
		<!-- Animate -->
        <link href="../../dwhproject/media/css/animate/animate.css" rel="stylesheet" type="text/css" />
		
		<!-- jquery -->
		<script src="../../dwhproject/media/js/dxchart/jquery-1.10.2.min.js"></script>
		
		<!-- Engine -->
		<script src="../../dwhproject/media/js/core/ab-engine.js"></script>
		
		<!-- chart -->
		<script src="../../dwhproject/media/js/dxchart/knockout-3.0.0.js"></script>
		<script src="../../dwhproject/media/js/dxchart/globalize.min.js"></script>
		<script src="../../dwhproject/media/js/dxchart/dx.chartjs.js"></script>

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
          <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
        <![endif]-->
    </head>
    <body class="skin-black animated fadeInRight">
        <!-- header logo: style can be found in header.less -->
        <header class="header">
            <a href="../dwhproject/home" class="logo">
                <!-- Add the class icon to your logo image or logo icon to add the margining -->
                Warehouse System
            </a>
            <!-- Header Navbar: style can be found in header.less -->
            <nav class="navbar navbar-static-top" role="navigation">
                <!-- Sidebar toggle button-->
                <a href="#" class="navbar-btn sidebar-toggle" data-toggle="offcanvas" role="button">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </a>
                <div class="navbar-right">
                    <ul class="nav navbar-nav">
                        <!-- User Account: style can be found in dropdown.less -->
                        <li class="dropdown user user-menu">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                <i class="glyphicon glyphicon-user"></i>
                                <span><?php echo $this->session->userdata('username') ?><i class="caret"></i></span>
                            </a>
                            <ul class="dropdown-menu">
                                <!-- User image -->
                                <li class="user-header bg-light-blue">
                                    <img src="../../dwhproject/media/img/avatar3.png" class="img-circle" alt="User Image" />
                                    <p>
										<?php echo $this->session->userdata('position'), ' - ',  $this->session->userdata('division'); ?>
                                    </p>
                                </li>
                                <!-- Menu Body -->
                                <!--<li class="user-body">
                                    <div class="col-xs-4 text-center">
                                        <a href="#">Followers</a>
                                    </div>
                                    <div class="col-xs-4 text-center">
                                        <a href="#">Sales</a>
                                    </div>
                                    <div class="col-xs-4 text-center">
                                        <a href="#">Friends</a>
                                    </div>
                                </li>-->
                                <!-- Menu Footer-->
                                <li class="user-footer">
                                    <!--
									<div class="pull-left">
                                        <a href="#" class="btn btn-default btn-flat">Profile</a>
                                    </div>
									-->
                                    <div class="pull-right">
                                        <a href="#" class="btn btn-default btn-flat" id="btnSignOut">Sign out</a>
                                    </div>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </nav>
        </header>
        <div class="wrapper row-offcanvas row-offcanvas-left">
            <!-- Left side column. contains the logo and sidebar -->
            <aside class="left-side sidebar-offcanvas">
                <!-- sidebar: style can be found in sidebar.less -->
                <section class="sidebar">
                    <!-- Sidebar user panel -->
                    <div class="user-panel">
                        <div class="pull-left image">
                            <img src="../../dwhproject/media/img/avatar3.png" class="img-circle" alt="User Image" />
                        </div>
                        <div class="pull-left info">
                            <p>Hello, <?= $this->session->userdata('username')?></p>

                            <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                        </div>
                    </div>
                   
                    <!-- sidebar menu: : style can be found in sidebar.less -->
                    <ul class="sidebar-menu">
                        <li class="active">
                            <a href="/dwhproject/home">
                                <i class="fa fa-dashboard"></i> <span>Dashboard</span>
                            </a>
                        </li>
                        <?php
                        if($this->session->userdata('loggedin')!=NULL) 
                        {
                            if(strstr($this->session->userdata('accessright'),'all'))
                            {
                        ?>
						<li>
                            <a href="/dwhproject/etl/main">
                                <i class="fa fa-adjust"></i> <span>ETL</span>
                            </a>
                        </li>
                        <?php
                            }
                        }

                        if($this->session->userdata('loggedin')!=NULL) 
                        {
                            if(strstr($this->session->userdata('accessright'),'all') || strstr($this->session->userdata('accessright'),'purchaseReport')) 
                            {
                        ?>
                        <li class="">
                            <a href="/dwhproject/purchase/purchaseReport">
                                <i class="fa fa-bar-chart-o"></i>
                                <span>Purchase Report</span>
                            </a>
                        </li>
						<?php
                            }
                        }
                        if($this->session->userdata('loggedin')!=NULL) 
                        {
                            if(strstr($this->session->userdata('accessright'),'all') || strstr($this->session->userdata('accessright'),'salesReport')) 
                            {
                        ?>
						<li class="">
                            <a href="/dwhproject/sales/salesReport">
                                <i class="fa fa-bar-chart-o"></i>
                                <span>Sales Report</span>
                            </a>
                        </li>
						<?php
                            }
                        }
                        if($this->session->userdata('loggedin')!=NULL) 
                        {
                            if(strstr($this->session->userdata('accessright'),'all') || strstr($this->session->userdata('accessright'),'leaseReport')) 
                            {
                        ?>
						<li class="">
                            <a href="/dwhproject/lease/leaseReport">
                                <i class="fa fa-bar-chart-o"></i>
                                <span>Lease Report</span>
                            </a>
                        </li>
						<?php
                            }
                        }
                        if($this->session->userdata('loggedin')!=NULL) 
                        {
                            if(strstr($this->session->userdata('accessright'),'all') || strstr($this->session->userdata('accessright'),'serviceReport')) 
                            {
                        ?>
						<li class="">
                            <a href="/dwhproject/service/serviceReport">
                                <i class="fa fa-bar-chart-o"></i>
                                <span>Service Report</span>
                            </a>
                        </li>
                        <?php
                            }
                        }
                         if($this->session->userdata('loggedin')!=NULL) 
                        {
                            if(strstr($this->session->userdata('accessright'),'all')) 
                            {
                        ?>
                        <li class="">
                            <a href="/dwhproject/manageAccess">
                                <i class="fa fa-book"></i>
                                <span>Manage User Access</span>
                            </a>
                        </li>
                        <?php
                            }
                        }
                        ?>
                    </ul>
                </section>
                <!-- /.sidebar -->
            </aside>

            <!-- Right side column. Contains the navbar and content of the page -->
			<!-- Content section goes here -->
			
			<?php echo (isset($pageContent))?$pageContent:''; ?>
			
            
        </div><!-- ./wrapper -->
		
		<!-- Bootstrap -->
        <script src="../../dwhproject/media/js/bootstrap.min.js" type="text/javascript"></script>
        <!-- fullCalendar -->
        <script src="../../dwhproject/media/js/plugins/fullcalendar/fullcalendar.min.js" type="text/javascript"></script>
        <!-- daterangepicker -->
        <script src="../../dwhproject/media/js/plugins/daterangepicker/daterangepicker.js" type="text/javascript"></script>
        
        <!-- AdminLTE App -->
        <script src="../../dwhproject/media/js/AdminLTE/app.js" type="text/javascript"></script>
		
		<!-- date-range-picker -->
        <script src="../../dwhproject/media/js/plugins/daterangepicker/daterangepicker.js" type="text/javascript"></script>
        
        <!-- AdminLTE dashboard demo (This is only for demo purposes) -->
        <!--<script src="js/AdminLTE/dashboard.js" type="text/javascript"></script>-->
		
    </body>
</html>
<script>
$(document).ready(function(){
    $("#btnSignOut").click(function(e){
        e.preventDefault();
        window.location.href= AB.serviceUri+'home/doLogout';
        //alert(AB.serviceUri+'home/doLogout');
    });
});
</script>