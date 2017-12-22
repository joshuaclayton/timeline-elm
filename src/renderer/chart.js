const $ = require("jquery");
window.jQuery = window.$ = $;
const Highcharts = require("highcharts");
require("highcharts/highcharts-more")(Highcharts);
require("highcharts/modules/exporting")(Highcharts);
const moment = require("moment");

const typeToHighchartsRenderedType = type => {
  switch (type) {
    case "line":
      return "spline";
    case "scatter-plot":
      return "scatter";
    case "bar":
      return "column";
    case "stacked-bar":
      return "column";
    case "box-plot":
      return "boxplot";
  }
};

const difference = (a1, a2) => {
  return a1.filter(x => a2.indexOf(x) < 0);
};

const range = (bottom, top) => {
  const genList = i => {
    return [...Array(i).keys()];
  };
  return difference(genList(top + 1), genList(bottom)).map(i => i + 1);
};

const generatePlotlines = startDate => {
  return range(0, 50).map(i => {
    return {
      color: "gray",
      dashStyle: "longDash",
      width: 1,
      value: startDate.clone().startOf("year").add(i, "years")
    };
  });
};

const groupBy = (xs, key) => {
  return xs.reduce((rv, x) => {
    (rv[x[key]] = rv[x[key]] || []).push(x);
    return rv;
  }, {});
};

const scatterPlotDataToGroups = tuples => {
  const groupedTuples = groupBy(tuples, 0);

  return Object.keys(groupedTuples).reduce((acc, i) => {
    return acc.concat({
      name: i,
      type: "scatter",
      data: groupedTuples[i].map(v => [v[1], v[2]])
    });
  }, []);
};

const dateForIndex = (startDate, interval, idx) => {
  return startDate.clone().add(idx, interval).toDate().getTime();
};

const generateSeriesFromData = (startDate, dateInterval, data) => {
  return data.graphs
    .map((graph, idx) => {
      if (graph._type === "scatter-plot") {
        const res = scatterPlotDataToGroups(graph.points);
        return res;
      } else if (graph._type === "box-plot") {
        const points = graph.points.map((v, i) => {
          let _v;
          if (v.length === 0) {
            _v = [0, 0, 0, 0, 0];
          }

          return [dateForIndex(startDate, dateInterval, i), ...(_v || v)];
        });
        return {
          type: typeToHighchartsRenderedType(graph._type),
          data: points,
          name: graph.name
        };
      } else {
        if ($.isArray(graph.points[0])) {
          return graph.points.map(points => {
            return {
              type: typeToHighchartsRenderedType(graph._type),
              data: points.map((v, i) => [
                dateForIndex(startDate, dateInterval, i),
                v
              ]),
              stack: `Series ${idx + 1}`,
              name: graph.name || `Series ${idx + 1}`
            };
          });
        } else {
          return [
            {
              type: typeToHighchartsRenderedType(graph._type),
              data: graph.points.map((v, i) => [
                dateForIndex(startDate, dateInterval, i),
                v
              ]),
              name: graph.name || `Series ${idx + 1}`,
              stack: `Series ${idx + 1}`
            }
          ];
        }
      }
    })
    .reduce((acc, a) => acc.concat(a), []);
};

const doesContainScatter = data => {
  return data.graphs.filter(a => a._type === "scatter-plot").length > 0;
};

const generateXAxis = (startDate, data) => {
  if (doesContainScatter(data)) {
    return {};
  } else {
    return {
      type: "datetime",
      labels: {
        formatter() {
          return moment(this.value).format("MMM YYYY");
        }
      },
      plotLines: generatePlotlines(startDate)
    };
  }
};

const generateTooltip = data => {
  if (doesContainScatter(data)) {
    return {
      formatter() {
        const amount = this.point.y;
        const days = this.point.x;
        const category = this.point.series.name;
        return `<b>${days} Days: ${amount} (${category})</b>`;
      }
    };
  } else {
    return {
      formatter() {
        const value = this.point.y;
        const date = moment(this.point.x);
        return `<b>${date.format("MMM YYYY")}: ${value}</b>`;
      }
    };
  }
};

class Chart {
  constructor(selector, period, startDate) {
    this.selector = selector;
    this.period = period;
    this.startDate = startDate;
    this.data = null;
    this.period.change(() => this.renderData(this.data));
    this.startDate.change(() => this.renderData(this.data));
  }

  get startDateValue() {
    return moment(this.startDate.val(), "YYYY-MM-DD");
  }

  renderData(data) {
    this.data = data;
    $(this.selector).highcharts({
      title: { text: null },
      xAxis: generateXAxis(this.startDateValue, data),
      tooltip: generateTooltip(data),
      series: generateSeriesFromData(
        this.startDateValue,
        this.period.val(),
        data
      ),
      plotOptions: {
        column: {
          stacking: "normal"
        },

        spline: {
          marker: {
            enabled: false
          }
        }
      }
    });
  }

  show() {
    $(this.selector).css({ visibility: "visible" });
  }

  hide() {
    $(this.selector).css({ visibility: "hidden" });
  }
}

module.exports = Chart;
