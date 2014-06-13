<link rel="stylesheet" href="/dwhproject/media/js/webix/codebase/webix.css" type="text/css" charset="utf-8">
<link rel="stylesheet" href="/dwhproject/media/js/webix/codebase/pivotchart.css" type="text/css" charset="utf-8">
<script src="/dwhproject/media/js/webix/codebase/webix.js" type="text/javascript" charset="utf-8"></script>
<script src="/dwhproject/media/js/webix/codebase/pivotchart.js" type="text/javascript" charset="utf-8"></script>
<link rel="stylesheet" href="/dwhproject/media/js/webix/common/samples.css" type="text/css" charset="utf-8">

<!-- Right side column. Contains the navbar and content of the page -->
<aside class="right-side">                
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>
            Service Report
            <small>View report related to purchase.</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a href="#">Service Report</a></li>
            <li class="active">All Term</li>
        </ol>
    </section>

    <!-- Main content -->
    <section class="content">
        <h4 class="page-header">
            Time Term : 
            <button class="btn btn-success btnTimeTerm" referTo="formYear">Year</button>
            <button class="btn btn-success btnTimeTerm" referTo="formQuarter">Quarter</button>
            <button class="btn btn-success btnTimeTerm" referTo="formMonth">Month</button>
            <button class="btn btn-success btnTimeTerm" referTo="formDate">Date</button>   
        </h4>
        
        <div class="col-md-12">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="formYear">
                        <div class="form-group">
							<label>Choose Year</label>
							<select class="form-control" id="ddlYear">
								<option>2010</option>
								<option>2011</option>
								<option>2012</option>
								<option>2013</option>
								<option>2014</option>
							</select>
						</div>
						<button class="btn btn-success" id="btnSubmitLeaseReportPerYear">Show Lease report</button><br/><br/>
                    </form>
					
					<form role="form" id="formQuarter" style="display:none;">
                        <div class="form-group">
							<label>Choose Year</label>
							<select class="form-control" id="ddlYear2">
								<option>2010</option>
								<option>2011</option>
								<option>2012</option>
								<option>2013</option>
								<option>2014</option>
							</select>
						</div>
						<div class="form-group">
							<label>Choose Quarter</label>
							<select class="form-control" id="ddlQuarter">
								<option value="1">January to March (Quarter 1)</option>
								<option value="2">April to June (Quarter 2)</option>
								<option value="3">July to September (Quarter 3)</option>
								<option value="4">October to December (Quarter 4)</option>
							</select>
						</div>
						<button class="btn btn-success" id="btnSubmitLeaseReportPerQuarter">Show purchase report</button><br/><br/>
                    </form>
					
					<form role="form" id="formMonth" style="display:none;">
                        <div class="form-group">
							<label>Choose Year</label>
							<select class="form-control" id="ddlYear3">
								<option>2010</option>
								<option>2011</option>
								<option>2012</option>
								<option>2013</option>
								<option>2014</option>
							</select>
						</div>
						<div class="form-group">
							<label>Choose Month</label>
							<select class="form-control" id="ddlMonth">
								<option value="1">January</option>
								<option value="2">February</option>
								<option value="3">March</option>
								<option value="4">April</option>
								<option value="5">May</option>
								<option value="6">June</option>
								<option value="7">July</option>
								<option value="8">August</option>
								<option value="9">September</option>
								<option value="10"October</option>
								<option value="11">November</option>
								<option value="12">December</option>
							</select>
						</div>
						<button class="btn btn-success" id="btnSubmitLeaseReportPerMonth">Show purchase report</button><br/><br/>
                    </form>
					
					<form role="form" id="formDate" style="display:none;">
                        <div class="form-group">
							<div class="input-group">
								<div class="input-group-addon">
									<i class="fa fa-calendar"></i>
								</div>
								<input type="text" data-mask=""  id="txtDateLease" data-inputmask="'alias': 'mm/dd/yyyy'" class="form-control">
							</div><!-- /.input group -->
						</div>
						<button class="btn btn-success" id="btnSubmitPurchaseReportPerDate">Show purchase report</button><br/><br/>
                    </form>
					
					<b>Computer Term</b>
					<input type="hidden" id="isSelectedComputer" value="1" />
					<div class="form-group" id="formColumnComputer">
						<label class="">
							<div class="icheckbox_flat-red checked chkComputer" data-value="dc.ComputerName," style="position: relative;" aria-checked="false" aria-disabled="false"><input type="checkbox" class="flat-red cbEmployee" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: none repeat scroll 0% 0% rgb(255, 255, 255); border: 0px none; opacity: 0;"></ins>&nbsp;&nbsp;Computer Name</div>
						</label>
						<label class="">
							<div class="icheckbox_flat-red checked chkComputer" data-value="dc.RentPrice," style="position: relative;" aria-checked="false" aria-disabled="false"><input type="checkbox"  class="flat-red cbEmployee" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: none repeat scroll 0% 0% rgb(255, 255, 255); border: 0px none; opacity: 0;"></ins>&nbsp;&nbsp;Rent Price</div>
						</label>
					</div>
					
					
					
					<b>Customer Term</b>
					<input type="hidden" id="isSelectedCustomer" value="1" />
					<div class="form-group" id="formColumnCustomer">
						<label class="">
							<div class="icheckbox_flat-red checked chkCustomer" data-value="de.CustomerName," style="position: relative;" aria-checked="false" aria-disabled="false"><input type="checkbox" class="flat-red cbCustomer" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: none repeat scroll 0% 0% rgb(255, 255, 255); border: 0px none; opacity: 0;"></ins>&nbsp;&nbsp;Customer Name</div>
						</label>
						<label class="">
							<div class="icheckbox_flat-red checked chkCustomer" data-value="de.CustomerGender," style="position: relative;" aria-checked="false" aria-disabled="false"><input type="checkbox"  class="flat-red cbCustomer" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: none repeat scroll 0% 0% rgb(255, 255, 255); border: 0px none; opacity: 0;"></ins>&nbsp;&nbsp;Customer Gender</div>
						</label>
					</div>
					
					
					
					
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
                        <h3 class="box-title">Report Chart</h3>
                    </div>
                    <div class="box-body">
                        <div class="chart-content">
                            <div class="chart-pane">
								<div id="leaseReportContainer"></div>
                                <!--<div id="chartContainer" class="chart-case-container" style="width: 100%; height: 440px;"></div>-->
                            </div>
                        </div>
                    </div><!-- /.box-body-->
                </div><!-- /.box -->
            </div>
        </div>
    </section><!-- /.content -->
</aside><!-- /.right-side -->

<script src="../../dwhproject/media/js/ContentJS/lease/leaseReport.js"></script>