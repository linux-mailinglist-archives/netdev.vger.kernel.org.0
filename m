Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6900FD24A
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfKOBOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:14:18 -0500
Received: from mga03.intel.com ([134.134.136.65]:62225 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727121AbfKOBOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 20:14:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 17:14:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,306,1569308400"; 
   d="scan'208";a="355974696"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga004.jf.intel.com with ESMTP; 14 Nov 2019 17:14:17 -0800
Received: from orsmsx152.amr.corp.intel.com (10.22.226.39) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 14 Nov 2019 17:14:16 -0800
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.169]) by
 ORSMSX152.amr.corp.intel.com ([169.254.8.219]) with mapi id 14.03.0439.000;
 Thu, 14 Nov 2019 17:14:16 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Hall, Christopher S" <christopher.s.hall@intel.com>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        Feras Daoud <ferasda@mellanox.com>,
        "stefan.sorensen@spectralink.com" <stefan.sorensen@spectralink.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>,
        "brandon.streiff@ni.com" <brandon.streiff@ni.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>
Subject: RE: [PATCH net 02/13] net: reject PTP periodic output requests with
 unsupported flags
Thread-Topic: [PATCH net 02/13] net: reject PTP periodic output requests
 with unsupported flags
Thread-Index: AQHVmxupDYJzKkQgG0K/vc+RFtuzwqeL3n8A//+OXlA=
Date:   Fri, 15 Nov 2019 01:14:15 +0000
Message-ID: <02874ECE860811409154E81DA85FBB5896990A94@ORSMSX121.amr.corp.intel.com>
References: <20191114184507.18937-3-richardcochran@gmail.com>
 <7275436b02f9551807f68784d4f4ebaf0adbc35e.camel@mellanox.com>
In-Reply-To: <7275436b02f9551807f68784d4f4ebaf0adbc35e.camel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWQ3YTU0ODItZDc4Yi00ODMwLWIyY2ItOTA1OGY2NGY2ZjRhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRTZcL0QwMm1YZjJIQ1dYOXlLdFFYR1kxNWhWcFwvK3p2YTZqWHZrSTF0RGtxZjRwWFE2VURaWGQ1ek92NWJzcG9UIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTYWVlZCBNYWhhbWVlZCA8c2Fl
ZWRtQG1lbGxhbm94LmNvbT4NCj4gU2VudDogVGh1cnNkYXksIE5vdmVtYmVyIDE0LCAyMDE5IDM6
NTggUE0NCj4gVG86IHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZw0KPiBDYzogSGFsbCwgQ2hyaXN0b3BoZXIgUyA8Y2hyaXN0b3BoZXIucy5oYWxsQGludGVs
LmNvbT47IEV1Z2VuaWEgRW1hbnRheWV2DQo+IDxldWdlbmlhQG1lbGxhbm94LmNvbT47IGRhdmVt
QGRhdmVtbG9mdC5uZXQ7DQo+IHNlcmdlaS5zaHR5bHlvdkBjb2dlbnRlbWJlZGRlZC5jb207IEZl
cmFzIERhb3VkIDxmZXJhc2RhQG1lbGxhbm94LmNvbT47DQo+IHN0ZWZhbi5zb3JlbnNlbkBzcGVj
dHJhbGluay5jb207IEJyb3duLCBBYXJvbiBGIDxhYXJvbi5mLmJyb3duQGludGVsLmNvbT47DQo+
IGJyYW5kb24uc3RyZWlmZkBuaS5jb207IEtlbGxlciwgSmFjb2IgRSA8amFjb2IuZS5rZWxsZXJA
aW50ZWwuY29tPjsgS2lyc2hlciwNCj4gSmVmZnJleSBUIDxqZWZmcmV5LnQua2lyc2hlckBpbnRl
bC5jb20+OyBpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZzsNCj4gZmVsaXBlLmJhbGJp
QGxpbnV4LmludGVsLmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldCAwMi8xM10gbmV0OiBy
ZWplY3QgUFRQIHBlcmlvZGljIG91dHB1dCByZXF1ZXN0cyB3aXRoDQo+IHVuc3VwcG9ydGVkIGZs
YWdzDQo+IA0KPiBPbiBUaHUsIDIwMTktMTEtMTQgYXQgMTA6NDQgLTA4MDAsIFJpY2hhcmQgQ29j
aHJhbiB3cm90ZToNCj4gPiBGcm9tOiBKYWNvYiBLZWxsZXIgPGphY29iLmUua2VsbGVyQGludGVs
LmNvbT4NCj4gPg0KPiBMR1RNLCBqdXN0IHRoZXJlIG1pZ2h0IGJlIGEgcHJvYmxlbSB3aXRoIG9s
ZCB0b29scyB0aGF0IGRpZG4ndCBjbGVhcg0KPiB0aGUgZmxhZ3MgdXBvbiByZXF1ZXN0IGFuZCBl
eHBlY3RlZCBQVFAgcGVyaW9kaWMgLi4gdGhleSB3aWxsIHN0b3AgdG8NCj4gd29yayB3aXRoIG5l
dyBrZXJuZWwsIGFtIGkgYW0gbm90IHN1cmUgaWYgc3VjaCB0b29scyBkbyBleGlzdC4NCj4gDQoN
Ck5vdCBxdWl0ZS4gVGhpcyBpcyB3aHkgdGhlcmUgaXMgYSBWMiBpb2N0bCBub3cuIFRoZSBWMSBp
b2N0bCBub3cgZXhwbGljaXRseSBkaXNhYmxlcyBhbnkgYml0cyBzZXQgYmV5b25kIHRoZSBvcmln
aW5hbGx5IGRlZmluZWQgb25lcywgc28gdGhhdCBjYWxsZXJzIG9mIHYxIHdpbGwgY29udGludWUg
dG8gd29yaywgZXZlbiBpZiB0aGV5IHNlbmQganVuayBkYXRhLg0KDQpUaHVzLCBvbGQgdG9vbHMg
c2hvdWxkIGNvbnRpbnVlIHdvcmtpbmcgd2l0aCB0aGUgb2xkIGludGVyZmFjZSwgd2hpbGUgdG9v
bHMgdGhhdCB3YW50IG5ldyBmdW5jdGlvbmFsaXR5IG11c3QgYmUgdXBncmFkZWQgdG8gdXNlIHRo
ZSB2MiBpb2N0bHMuDQoNClRoYW5rcywNCkpha2UNCg0KPiBCdXQgdGhlIGZhY3Qgbm93IHRoYXQg
d2UgaGF2ZSBQVFBfUEVST1VUX09ORV9TSE9ULCB3ZSBuZWVkIHRvIHRydXN0DQo+IGJvdGggZHJp
dmVyIGFuZCB0b29scyB0byBkbyB0aGUgcmlnaHQgdGhpbmcuDQo+IA0KPiBXaGF0IGFyZSB0aGUg
dG9vbHMgdG8gdGVzdCBQVFBfUEVST1VUX09ORV9TSE9UID8gdG8gc3VwcG9ydCB0aGlzIGluDQo+
IG1seDUgaXQgaXMganVzdCBhIG1hdHRlciBvZiBhIGZsaXBwaW5nIGEgYml0Lg0KPiANCj4gUmV2
aWV3ZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiANCg0K
