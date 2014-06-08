var client = new Keen({
    projectId: <INSERT_YOUR_PROJECT_ID>,
    readKey: <INSERT_YOUR_READKEY 
    });

Keen.ready(function() {

    // ----------------------------------------
    // Total Steps today
    // ----------------------------------------
    var steps_today = new Keen.Query("count", {
        eventCollection: "StepData",
        timeframe: "this_1_day",
        filters: [
            {"property_name": "stepCount", "operator": "exists", "property_value": true}
        ]
    });

    var req_steps_today = client.draw(steps_today, document.getElementById("stepCount"), {
        chartType: "metric",
        title: "Steps Today",
        height: 40,
        width: "auto",
        chartOptions: {
            chartArea: {
                height: "85%",
                left: "5%",
                top: "5%",
                width: "80%",
            }
        }
    });

    setInterval(function () {
        req_steps_today.refresh();
    }, 5000);


    // ----------------------------------------
    // Battery Status
    // ----------------------------------------
    var battery_level = new Keen.Query("extraction", {
        eventCollection: "StepData",
        property_names: ["batteryVoltage"],
        latest: 1
    });

    var req_battery_level = client.draw(battery_level, document.getElementById("batteryLevel"), {
        chartType: "metric",
        title: "Battery Level",
        height: 40,
        width: "auto",
        chartOptions: {
            chartArea: {
                height: "85%",
                left: "5%",
                top: "5%",
                width: "85%"
            }
        }
    });

    setInterval(function () {
        req_battery_level.refresh();
    }, 1800000);

    // ----------------------------------------
    // Current status (most recent 2 hours)
    // ----------------------------------------

    var now_history = new Keen.Query("count", {
        eventCollection: "StepData",
        interval: "every_5_minutes",
        timeframe: "this_2_hours",
        filters: [
            {"property_name": "stepCount", "operator": "exists", "property_value": true}
        ]
    });

    // Loop over each record and convert steps/min into mph -- for now, assume 30" stride
    client.run(now_history, function (response) {
        Keen.utils.each(response.result, function (record, index) {
            record.value *= 5.68e-3;
            });

        var req_now_history = new Keen.Visualization(response, document.getElementById("chart-01"), {
            chartType: "linechart",
            title: false,
            height: 150,
            width: "auto",
            chartOptions: {
                chartArea: {
                    height: "75%",
                    left: "10%",
                    top: "5%",
                    width: "85%"
                },
                vAxis: {
                    format: "##.#",
                    title: "mph"
                },
                bar: {groupWidth: "95%"}
            }
        });
    });

    setInterval(function () {
        req_now_history.refresh();
    }, 10000);

    // ----------------------------------------
    // Today in detail
    // ----------------------------------------

    var today_history = new Keen.Query("count", {
        eventCollection: "StepData",
        interval: "every_15_minutes",
        timeframe: "this_1_day",
        filters: [
            {"property_name": "stepCount", "operator": "exists", "property_value": true}
        ]
    });

    client.run(today_history, function (response) {
        Keen.utils.each(response.result, function (record, index) {
            record.value *= 6.67e-2;
        });

        var req_today_history = new Keen.Visualization(response, document.getElementById("chart-02"), {
            chartType: "columnchart",
            title: false,
            height: 150,
            width: "auto",
            chartOptions: {
                chartArea: {
                    height: "75%",
                    left: "8%",
                    top: "5%",
                    width: "85%"
                },
                vAxis: {
                    format: "###",
                    title: "steps/min"
                },
                bar: {groupWidth: "95%"}
            }
        });
    });

    setInterval(function () {
        req_today_history.refresh();
    }, 300000);

    // ----------------------------------------
    // Three month history by day
    // ----------------------------------------

    var three_month_history = new Keen.Query("count", {
        eventCollection: "StepData",
        interval: "daily",
        filters: [
            {"property_name": "stepCount", "operator": "exists", "property_value": true}
        ],
        timeframe: "this_12_weeks"
    });

    var req_three_month_history = client.draw(three_month_history, document.getElementById("chart-03"), {
        chartType: "columnchart",
        title: false,
        height: 150,
        width: "auto",
        chartOptions: {
            chartArea: {
                height: "75%",
                left: "7%",
                top: "5%",
                width: "85%"
            },
            hAxis: {
                gridlines: {
                    count: 12
                },
                format: "MMM d"
            },
            vAxis: {
                format: "#####",
                title: "Steps"
            },
            bar: {groupWidth: "95%"}
        }
    });

// update the 3 month history every half hour
    setInterval(function () {
        req_three_month_history.refresh();
    }, 1800000);
});

