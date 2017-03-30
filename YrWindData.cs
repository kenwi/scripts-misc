using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using HtmlAgilityPack;

namespace YrWeatherData
{
    internal class Program
    {
        public static void Main(string[] args)
        {
            Console.WriteLine("Tidspunkt;Vind");
            var date = new DateTime(2017, 1, 1);
            while (date < DateTime.Now)
            {
                var url = $"https://www.yr.no/sted/Norge/Finnmark/Vardø/Vardø/almanakk.html?dato={date:yyyy-MM-dd}";
                var html = new WebClient().DownloadString(url).Replace("<td>-</td><td>", "<td class=\"text-left\">0 m/s</td><td>");
                var document = new HtmlDocument();
                document.LoadHtml(html);

                var rows = document.DocumentNode.SelectNodes("//table//tbody//tr").Where(node => node.ChildNodes.Count != 5);
                foreach (var row in rows)
                {
                    var timeNode = row.ChildNodes.FirstOrDefault(node => node.Name == "th")?.ChildNodes?.LastOrDefault();
                    var windNode = row.ChildNodes.Where(node => node.Name == "td").Reverse().Skip(1).FirstOrDefault();
                    var hours = timeNode.InnerText.Split(' ').LastOrDefault();

                    var timeText = new DateTime().AddHours(int.Parse(hours)).ToString("HH:mm");
                    var windText = windNode.InnerText.Split(' ').FirstOrDefault();

                    Console.WriteLine($"{date:yyyy-MM-dd} {timeText};{windText}");
                }
                date = date.AddDays(1);
            }
        }
    }
}
