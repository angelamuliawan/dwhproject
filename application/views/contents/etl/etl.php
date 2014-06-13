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
            ETL
            <all>Extract - Transform - Load</all>
        </h1>
		<ol class="breadcrumb">
			<li><a href="#"><i class="fa fa-dashboard"></i> Home</a>
			</li>
			<li class="active">ETL</li>
		</ol>
	</section>

	
	<!-- Main content -->
	<section class="content">
		
		<button class="btn btn-success btnETLNow" >ETL Now</button><br/>
		Last ETL :  <i> <?php if(isset($data[0]->Last_ETL)) echo $data[0]->Last_ETL;?></i>
		<h4 class="page-header">
           Dimensi
        </h4>

		<div class="col-md-12">
			<div class="row">
				<div class="col-md-4">
					<h4>Dimensi Waktu</h4>
					<div class="progress  progress-striped active">
						<div id="dimensiWaktu" class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
							
						</div>
					</div>
				</div>

				<div class="col-md-4">
					<h4>Dimensi Customer</h4>
					<div class="progress  progress-striped active">
						<div id="dimensiCustomer" class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
							
						</div>
					</div>
				</div>

				<div class="col-md-4">
					<h4>Dimensi Employee</h4>
					<div class="progress  progress-striped active">
						<div id="dimensiEmployee" class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
							
						</div>
					</div>
				</div>



			</div>

			<div class="row">

				<div class="col-md-4">
					<h4>Dimensi Vendor</h4>
					<div class="progress  progress-striped active">
						<div id="dimensiVendor" class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
							
						</div>
					</div>
				</div>
				<div class="col-md-4">
					<h4>Dimensi Product</h4>
					<div class="progress  progress-striped active">
						<div id="dimensiProduct" class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
							
						</div>
					</div>
				</div>

				<div class="col-md-4">
					<h4>Dimensi Service Type</h4>
					<div class="progress  progress-striped active">
						<div id="dimensiServiceType" class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
							
						</div>
					</div>
				</div>

				<div class="col-md-4">
					<h4>Dimensi Computer Rent</h4>
					<div class="progress  progress-striped active">
						<div id="dimensiComputerRent" class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
							
						</div>
					</div>
				</div>
			</div>
		</div>

	</section>

	<section class="content">
		<h4 class="page-header">
           Fakta
        </h4>

		<div class="col-md-12">
			<div class="row">
				<div class="col-md-4">
					<h4>Fakta Pembelian</h4>
					<div class="progress  progress-striped active">
						<div class="progress-bar progress-bar-success" role="progressbar" id="faktaPembelian" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
							
						</div>
						
					</div>
				</div>

				<div class="col-md-4">
					<h4>Fakta Penjualan</h4>
					<div class="progress  progress-striped active">
						<div class="progress-bar progress-bar-success" role="progressbar" id="faktaPenjualan" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
							
						</div>
					</div>
				</div>

				<div class="col-md-4">
					<h4>Fakta Layanan Service</h4>
					<div class="progress  progress-striped active">
						<div class="progress-bar progress-bar-success" role="progressbar" id="faktaLayananService" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
							
						</div>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="col-md-4">
					<h4>Fakta Penyewaan</h4>
					<div class="progress  progress-striped active">
						<div class="progress-bar progress-bar-success" role="progressbar" id="faktaPenyewaan" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
							
						</div>
					</div>
				</div>
			</div>
		</div>

	</section>
	<!-- /.content -->
</aside>
<!-- /.right-side -->

<script src="../../dwhproject/media/js/ContentJS/etl/etl.js"></script>