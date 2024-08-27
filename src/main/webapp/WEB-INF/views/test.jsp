<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Highcharts Example</title>
        <script src="https://code.highcharts.com/highcharts.js"></script>
        <script src="https://code.highcharts.com/modules/exporting.js"></script>
        <script src="https://code.highcharts.com/highcharts-more.js"></script>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/themes/default/style.min.css" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/jstree.min.js"></script>
    </head>

    <body>
        <div id="jstree"></div>

    <script>
        $(document).ready(function() {
            $('#jstree').jstree({
                'core': {
                    'data': [
                        { "text": "Root node", "children": [
                            { "text": "Child node 1", "id": "child1" },
                            { "text": "Child node 2", "id": "child2" }
                        ] },
                        { "text": "Root node1", "children2": [
                            { "text": "Child node 3", "id": "child3" },
                            { "text": "Child node 4", "id": "child4" }
                        ] }
                    ],
                    "multiple": false
                },
                "plugins": ["dnd"], // dnd 플러그인 포함
                "types": {
                    "default": {
                        "icon": '/img/group.png', // 아이콘 경로는 실제 파일 경로로 변경
                    }
                }
            }).on('move_node.jstree', function (e, data) {
                alert();
                // 노드 이동 시 처리할 로직
                var movedNodeId = data.node.id;
                var parentId = data.node.parent;
                var position = data.node.position;

                console.log("Node moved:", movedNodeId);
                console.log("New parent:", parentId);
                console.log("Position in new parent:", position);
            });
        });
    </script>




        <div id="container"></div>
        <div id="container2"></div>
        <div id="container3"></div>
        <script>
            Highcharts.chart('container', {
                chart: {
                    type: 'line'
                },
                title: {
                    text: 'Highcharts Example'
                },
                xAxis: {
                    type: 'datetime',
                    dateTimeLabelFormats: {
                    year: '%Y',
                    month: '%b',
                    day: '%d'
                    }
                },
                yAxis: {
                    title: {
                        text: 'Value'
                    }
                },
                series: [{
                    name: '넣는값',
                    data: [
                            [Date.UTC(2020, 1, 1), 10],
                            [Date.UTC(2020, 1, 1), 20],
                            [Date.UTC(2020, 1, 3), 30],
                            [Date.UTC(2020, 1, 4), 40],
                            [Date.UTC(2020, 1, 6), 50],
                            [Date.UTC(2020, 5, 1), 60],
                            [Date.UTC(2020, 6, 1), 70],
                            [Date.UTC(2020, 7, 1), 80],
                            [Date.UTC(2020, 8, 1), 90],
                            [Date.UTC(2020, 9, 1), 100],
                            [Date.UTC(2020, 10, 1), 110],
                            [Date.UTC(2020, 11, 1), 120]
                    ],
                    marker: {
                        enabled: true,
                        lineWidth: 2,
                        fillColor: 'white'
                    }
                }]
            });


            // Data retrieved from https://fas.org/issues/nuclear-weapons/status-world-nuclear-forces/
            Highcharts.chart('container2', {
                chart: {
                    type: 'area'
                },
                accessibility: {
                    description: 'Image description: An area chart compares the nuclear ' +
                        'stockpiles of the USA and the USSR/Russia between 1945 and ' +
                        '2024. The number of nuclear weapons is plotted on the Y-axis ' +
                        'and the years on the X-axis. The chart is interactive, and the ' +
                        'year-on-year stockpile levels can be traced for each country. ' +
                        'The US has a stockpile of 2 nuclear weapons at the dawn of the ' +
                        'nuclear age in 1945. This number has gradually increased to 170 ' +
                        'by 1949 when the USSR enters the arms race with one weapon. At ' +
                        'this point, the US starts to rapidly build its stockpile ' +
                        'culminating in 31,255 warheads by 1966 compared to the USSR’s 8,' +
                        '400. From this peak in 1967, the US stockpile gradually ' +
                        'decreases as the USSR’s stockpile expands. By 1978 the USSR has ' +
                        'closed the nuclear gap at 25,393. The USSR stockpile continues ' +
                        'to grow until it reaches a peak of 40,159 in 1986 compared to ' +
                        'the US arsenal of 24,401. From 1986, the nuclear stockpiles of ' +
                        'both countries start to fall. By 2000, the numbers have fallen ' +
                        'to 10,577 and 12,188 for the US and Russia, respectively. The ' +
                        'decreases continue slowly after plateauing in the 2010s, and in ' +
                        '2024 the US has 3,708 weapons compared to Russia’s 4,380.'
                },
                title: {
                    text: 'area차트'
                },
                subtitle: {
                    text: 'Source: <a href="https://fas.org/issues/nuclear-weapons/status-world-nuclear-forces/" ' +
                        'target="_blank">FAS</a>'
                },
                xAxis: {
                    allowDecimals: false,
                    accessibility: {
                        rangeDescription: 'Range: 2000 to 2020.'
                    }
                },
                yAxis: {
                    title: {
                        text: 'Nuclear weapon states'
                    }
                },
                tooltip: {
                    pointFormat: '{series.name} had stockpiled <b>{point.y:,.0f}</b><br/>' +
                        'warheads in {point.x}'
                },
                plotOptions: {
                    area: {
                        pointStart: 60,
                        marker: {
                            enabled: false,
                            symbol: 'circle',
                            radius: 2,
                            states: {
                                hover: {
                                    enabled: true
                                }
                            }
                        }
                    }
                },
                series: [{
                    name: 'USSR/Russia',
                    data: [
                        null, null, null, null, null, null, null, null, null,
                        1, 5, 25, 50, 120, 150, 200, 426, 660, 863, 1048, 1627, 2492,
                        3346, 4259, 5242, 6144, 7091, 8400, 9490, 10671, 11736, 13279,
                        14600, 15878, 17286, 19235, 22165, 24281, 26169, 28258, 30665,
                        32146, 33486, 35130, 36825, 38582, 40159, 38107, 36538, 35078,
                        32980, 29154, 26734, 24403, 21339, 18179, 15942, 15442, 14368,
                        13188, 12188, 11152, 10114, 9076, 8038, 7000, 6643, 6286, 5929,
                        5527, 5215, 4858, 4750, 4650, 4600, 4500, 4490, 4300, 4350, 4330,
                        4310, 4495, 4477, 4489, 4380
                    ]
                }]
            });

            Highcharts.chart('container3', {
                chart: {
                    type: 'pie'
                },
                title: {
                    text: 'Egg Yolk Composition'
                },
                tooltip: {
                    valueSuffix: '%'
                },
                subtitle: {
                    text:
                        'Source:<a href="https://www.mdpi.com/2072-6643/11/3/684/htm" target="_default">MDPI</a>'
                },
                plotOptions: {
                    series: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: [{
                            enabled: true,
                            distance: 20
                        }, {
                            enabled: true,
                            distance: -40,
                            format: '{point.percentage:.1f}%',
                            style: {
                                fontSize: '1.2em',
                                textOutline: 'none',
                                opacity: 0.7
                            },
                            filter: {
                                operator: '>',
                                property: 'percentage',
                                value: 10
                            }
                        }]
                    }
                },
                series: [
                    {
                        name: 'Percentage',
                        colorByPoint: true,
                        data: [
                            {
                                name: 'Water',
                                y: 55.02
                            },
                            {
                                name: 'Fat',
                                sliced: true,
                                selected: true,
                                y: 26.71
                            },
                            {
                                name: 'Carbohydrates',
                                y: 66.09
                            },
                            {
                                name: 'Protein',
                                y: 15.5
                            },
                            {
                                name: 'Ash',
                                y: 1.68
                            }
                        ]
                    }
                ]
            });


        </script>
    </body>

    </html>