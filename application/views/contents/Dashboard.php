<aside class="right-side">
	<!-- Content Header (Page header) -->
	<section class="content-header">
		<h1>
			Dashboard
			<small>Control panel</small>
		</h1>
		<ol class="breadcrumb">
			<li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
			<li class="active">Dashboard</li>
		</ol>
	</section>

	<!-- Main content -->
	<section class="content">

		<!-- Small boxes (Stat box) -->
		<div class="row">
			<div class="col-lg-3 col-xs-6">
				<!-- small box -->
				<div class="small-box bg-aqua" id="btnSummaryPurchase">
					<div class="inner">
						<h3>
							2014
						</h3>
						<p>
							Purchase
						</p>
					</div>
					<div class="icon">
						<i class="ion ion-bag"></i>
					</div>
					<a href="../dwhproject/summary/summaryPurchase" class="small-box-footer">
						More info <i class="fa fa-arrow-circle-right"></i>
					</a>
				</div>
			</div><!-- ./col -->
			
			<div class="col-lg-3 col-xs-6">
				<!-- small box -->
				<div class="small-box bg-blue" id="btnSummarySales">
					<div class="inner">
						<h3>
							2014
						</h3>
						<p>
							Sales
						</p>
					</div>
					<div class="icon">
						<i class="ion ion-ios7-cart-outline"></i>
					</div>
					<a href="../dwhproject/summary/summarySales" class="small-box-footer">
						More info <i class="fa fa-arrow-circle-right"></i>
					</a>
				</div>
			</div><!-- ./col -->
			<div class="col-lg-3 col-xs-6">
				<!-- small box -->
				<div class="small-box bg-green" id="btnSummaryLease">
					<div class="inner">
						<h3>
							2014
						</h3>
						<p>
							Lease
						</p>
					</div>
					<div class="icon">
						<i class="ion ion-stats-bars"></i>
					</div>
					<a href="../dwhproject/summary/summaryLease" class="small-box-footer">
						More info <i class="fa fa-arrow-circle-right"></i>
					</a>
				</div>
			</div><!-- ./col -->
			<div class="col-lg-3 col-xs-6">
				<!-- small box -->
				<div class="small-box bg-red" id="btnSummaryService">
					<div class="inner">
						<h3>
							2014
						</h3>
						<p>
							Service
						</p>
					</div>
					<div class="icon">
						<i class="ion ion-pie-graph"></i>
					</div>
					<a href="../dwhproject/summary/summaryService" class="small-box-footer">
						More info <i class="fa fa-arrow-circle-right"></i>
					</a>
				</div>
			</div><!-- ./col -->
		</div><!-- /.row -->

	</section><!-- /.content -->
</aside><!-- /.right-side -->

<script type="text/javascript">

	$("#btnSummaryPurchase").click(function(){
		location.href = "../dwhproject/summary/summaryPurchase";
	});
	$("#btnSummaryService").click(function(){
		location.href = "../dwhproject/summary/summaryService";
	});
	$("#btnSummaryLease").click(function(){
		location.href = "../dwhproject/summary/summaryLease";
	});
	$("#btnSummarySales").click(function(){
		location.href = "../dwhproject/summary/summarySales";
	});

</script>