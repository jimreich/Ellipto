<!DOCTYPE html>
<html>

<head>
  <title>ELLIPTO: Elliptical Trainer Tracker</title>
  <link rel="stylesheet" href="bower_components/bootstrap/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="keen.dashboard.css">
</head>
<body>

  <div class="fluid-container">
    <div class="row">
      <div class="col-sm-4">
        <center><IMG SRC="ellipto.png" ALT="Ellipto" HEIGHT=150></center>
      </div>

      <div class="col-sm-4">
        <div class="chart-wrapper">
          <div class="chart-stage">
            <div id="stepCount"></div>
          </div>
        </div>
      </div>

      <div class="col-sm-4">
        <div class="chart-wrapper">
          <div class="chart-stage">
            <div id="batteryLevel"></div>
          </div>
        </div>
      </div>
    </div>

      
    <div class="row">
      <div class="col-sm-4">      
        <div class="chart-wrapper">
          <div class="chart-title">
            Current Activity 
          </div>
          <div class="chart-stage">
            <div id="chart-01"></div>
          </div>
        </div>
      </div>
      <div class="col-sm-8">
        <div class="chart-wrapper">
          <div class="chart-title">
            Your activity today 
          </div>
          <div class="chart-stage">
            <div id="chart-02"></div>
          </div>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-sm-12">
      <div class="chart-wrapper">
        <div class="chart-title">
          Activity for past 3 months 
        </div>
      <div class="chart-stage">
        <div id="chart-03"></div>
      </div>
      </div>
    </div>
  </div>
</div>

<p>Built very, very quickly with <A href=http://keen.io>Keen.io</A> and <A href=http://electricimp.com>Electric Imp</A>. Read about the project <A href="https://medium.com/@jim_reich/ellipto-electric-imp-meets-keen-io-b581a8c17b13"</A>here.<p>

<script src="bower_components/jquery/dist/jquery.min.js"></script>
<script src="bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
<script src="https://d26b395fwzu5fz.cloudfront.net/3.0.0/keen.min.js?v=0"></script>
<script src="keen.dashboard.js"></script>

</body>
</html>

