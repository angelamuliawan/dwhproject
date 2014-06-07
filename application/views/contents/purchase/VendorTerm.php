<!-- Right side column. Contains the navbar and content of the page -->
<aside class="right-side">                
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>
            Purchase Report
            <small>View report related to purchase.</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a href="#">Purchase Report</a></li>
            <li class="active">Employee Term</li>
        </ol>
    </section>

    <!-- Main content -->
    <section class="content">
        <h4 class="page-header">
            Time Term : 
            <button class="btn btn-success">Year</button>
            <button class="btn btn-success">Quarter</button>
            <button class="btn btn-success">Month</button>
            <button class="btn btn-success">Date</button>   
        </h4>
        
        <div class="col-md-12">
            <div class="row">
                <div class="col-xs-8">
                    <form role="form">
                        <div class="form-group">
                            <button class="btn btn-success">This Year</button>
                        </div>
                        <div class="form-group">
                            <label>or Set Date range:</label>
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-calendar"></i>
                                </div>
                                <input type="text" class="form-control pull-right" id="daterange"/>
                            </div><!-- /.input group -->
                        </div><!-- /.form group -->
                    </form>
                </div>
            </div>
        </div>
        <h5>Comparison description goes here</h5>
        <div class="row">
            <div class="col-md-12">
                <!-- Bar chart -->
                <div class="box box-primary">
                    <div class="box-header">
                        <i class="fa fa-bar-chart-o"></i>
                        <h3 class="box-title">Pie Chart</h3>
                    </div>
                    <div class="box-body">
                        <div class="chart-content">
                            <div class="chart-pane">
                                <!--<div class="chart-long-title"><h3></h3></div>-->
                                <div id="chartContainer" class="chart-case-container" style="width: 100%; height: 440px;"></div>
                                <!--<div class="chart-credits"></div>-->
                            </div>
                        </div>
                    </div><!-- /.box-body-->
                </div><!-- /.box -->
            </div>
        </div>
    </section><!-- /.content -->
</aside><!-- /.right-side -->

<script src="../../dwhproject/media/js/ContentJS/purchase/VendorTerm.js"></script>