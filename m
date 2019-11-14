Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 521F2FCE94
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 20:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfKNTQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 14:16:47 -0500
Received: from mga07.intel.com ([134.134.136.100]:43901 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfKNTQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 14:16:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 11:16:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="406428637"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by fmsmga006.fm.intel.com with ESMTP; 14 Nov 2019 11:16:45 -0800
Received: from orsmsx115.amr.corp.intel.com (10.22.240.11) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 14 Nov 2019 11:16:45 -0800
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.169]) by
 ORSMSX115.amr.corp.intel.com ([169.254.4.121]) with mapi id 14.03.0439.000;
 Thu, 14 Nov 2019 11:16:45 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        David Miller <davem@davemloft.net>,
        Brandon Streiff <brandon.streiff@ni.com>,
        "Hall, Christopher S" <christopher.s.hall@intel.com>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        "Feras Daoud" <ferasda@mellanox.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Stefan Sorensen <stefan.sorensen@spectralink.com>
Subject: RE: [PATCH net 00/13] ptp: Validate the ancillary ioctl flags more
 carefully.
Thread-Topic: [PATCH net 00/13] ptp: Validate the ancillary ioctl flags more
 carefully.
Thread-Index: AQHVmxupzwcs4maF+0CjqiKu9dXf7qeLCV2g
Date:   Thu, 14 Nov 2019 19:16:44 +0000
Message-ID: <02874ECE860811409154E81DA85FBB589698F714@ORSMSX121.amr.corp.intel.com>
References: <20191114184507.18937-1-richardcochran@gmail.com>
In-Reply-To: <20191114184507.18937-1-richardcochran@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMDc2MGViMzYtODcxOC00YmY1LWI5ZWUtOWExZjRlMWJiYzQyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMnhhVXViaXJvckRDYVBEbVZxeFFycVwveTJiSTdzK2FPZjZ3SFdIZHhnYjRmdnJqK1wvTUVJZjR5VDU5bTBRb2RBIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNoYXJkIENvY2hyYW4gPHJp
Y2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIE5vdmVtYmVyIDE0LCAy
MDE5IDEwOjQ1IEFNDQo+IFRvOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBpbnRlbC13
aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZzsgRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQu
bmV0PjsNCj4gQnJhbmRvbiBTdHJlaWZmIDxicmFuZG9uLnN0cmVpZmZAbmkuY29tPjsgSGFsbCwg
Q2hyaXN0b3BoZXIgUw0KPiA8Y2hyaXN0b3BoZXIucy5oYWxsQGludGVsLmNvbT47IEV1Z2VuaWEg
RW1hbnRheWV2IDxldWdlbmlhQG1lbGxhbm94LmNvbT47DQo+IEZlbGlwZSBCYWxiaSA8ZmVsaXBl
LmJhbGJpQGxpbnV4LmludGVsLmNvbT47IEZlcmFzIERhb3VkDQo+IDxmZXJhc2RhQG1lbGxhbm94
LmNvbT47IEtlbGxlciwgSmFjb2IgRSA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPjsgS2lyc2hl
ciwNCj4gSmVmZnJleSBUIDxqZWZmcmV5LnQua2lyc2hlckBpbnRlbC5jb20+OyBTZXJnZWkgU2h0
eWx5b3YNCj4gPHNlcmdlaS5zaHR5bHlvdkBjb2dlbnRlbWJlZGRlZC5jb20+OyBTdGVmYW4gU29y
ZW5zZW4NCj4gPHN0ZWZhbi5zb3JlbnNlbkBzcGVjdHJhbGluay5jb20+DQo+IFN1YmplY3Q6IFtQ
QVRDSCBuZXQgMDAvMTNdIHB0cDogVmFsaWRhdGUgdGhlIGFuY2lsbGFyeSBpb2N0bCBmbGFncyBt
b3JlIGNhcmVmdWxseS4NCj4gDQo+IFRoZSBmbGFncyBwYXNzZWQgdG8gdGhlIGlvY3RscyBmb3Ig
cGVyaW9kaWMgb3V0cHV0IHNpZ25hbHMgYW5kDQo+IHRpbWUgc3RhbXBpbmcgb2YgZXh0ZXJuYWwg
c2lnbmFscyB3ZXJlIG5ldmVyIGNoZWNrZWQsIGFuZCB0aHVzIGZvcm1lZA0KPiBhIHVzZWxlc3Mg
QUJJIGluYWR2ZXJ0ZW50bHkuICBNb3JlIHJlY2VudGx5LCBhIHZlcnNpb24gMiBvZiB0aGUgaW9j
dGxzDQo+IHdhcyBpbnRyb2R1Y2VkIGluIG9yZGVyIG1ha2UgdGhlIGZsYWdzIG1lYW5pbmdmdWwu
ICBUaGlzIHNlcmllcw0KPiB0aWdodGVucyB1cCB0aGUgY2hlY2tzIG9uIHRoZSBuZXcgaW9jdGwg
ZmxhZ3MuDQo+IA0KPiAtIFBhdGNoIDEgZW5zdXJlcyBhdCBsZWFzdCBvbmUgZWRnZSBmbGFnIGlz
IHNldCBmb3IgdGhlIG5ldyBpb2N0bC4NCj4gLSBQYXRjaGVzIDItNyBhcmUgSmFjb2IncyByZWNl
bnQgY2hlY2tzLCBwaWNraW5nIHVwIHRoZSB0YWdzLg0KPiAtIFBhdGNoIDggaW50cm9kdWNlcyBh
ICJzdHJpY3QiIGZsYWcgZm9yIHBhc3NpbmcgdG8gdGhlIGRyaXZlcnMgd2hlbiB0aGUNCj4gICBu
ZXcgaW9jdGwgaXMgdXNlZC4NCj4gLSBQYXRjaGVzIDktMTIgaW1wbGVtZW50IHRoZSAic3RyaWN0
IiBjaGVja2luZyBpbiB0aGUgZHJpdmVycy4NCj4gLSBQYXRjaCAxMyBleHRlbmRzIHRoZSB0ZXN0
IHByb2dyYW0gdG8gZXhlcmNpc2UgY29tYmluYXRpb25zIG9mIGZsYWdzLg0KPiANCj4gSmFjb2Ig
S2VsbGVyICg2KToNCj4gICBuZXQ6IHJlamVjdCBQVFAgcGVyaW9kaWMgb3V0cHV0IHJlcXVlc3Rz
IHdpdGggdW5zdXBwb3J0ZWQgZmxhZ3MNCj4gICBtdjg4ZTZ4eHg6IHJlamVjdCB1bnN1cHBvcnRl
ZCBleHRlcm5hbCB0aW1lc3RhbXAgZmxhZ3MNCj4gICBkcDgzNjQwOiByZWplY3QgdW5zdXBwb3J0
ZWQgZXh0ZXJuYWwgdGltZXN0YW1wIGZsYWdzDQo+ICAgaWdiOiByZWplY3QgdW5zdXBwb3J0ZWQg
ZXh0ZXJuYWwgdGltZXN0YW1wIGZsYWdzDQo+ICAgbWx4NTogcmVqZWN0IHVuc3VwcG9ydGVkIGV4
dGVybmFsIHRpbWVzdGFtcCBmbGFncw0KPiAgIHJlbmVzYXM6IHJlamVjdCB1bnN1cHBvcnRlZCBl
eHRlcm5hbCB0aW1lc3RhbXAgZmxhZ3MNCj4gDQoNClRoZSBwYXRjaGVzIGZyb20gbWUgYWNjdXJh
dGVseSByZXByZXNlbnQgd2hhdCBJIHN1Ym1pdHRlZCBhbmQgSSdtIGhhcHB5IHRvIGhhdmUgdGhl
bSBjb21taXR0ZWQgdmlhIHRoaXMgc2VyaWVzLg0KDQo+IFJpY2hhcmQgQ29jaHJhbiAoNyk6DQo+
ICAgcHRwOiBWYWxpZGF0ZSByZXF1ZXN0cyB0byBlbmFibGUgdGltZSBzdGFtcGluZyBvZiBleHRl
cm5hbCBzaWduYWxzLg0KPiAgIHB0cDogSW50cm9kdWNlIHN0cmljdCBjaGVja2luZyBvZiBleHRl
cm5hbCB0aW1lIHN0YW1wIG9wdGlvbnMuDQo+ICAgbXY4OGU2eHh4OiBSZWplY3QgcmVxdWVzdHMg
dG8gZW5hYmxlIHRpbWUgc3RhbXBpbmcgb24gYm90aCBlZGdlcy4NCj4gICBkcDgzNjQwOiBSZWpl
Y3QgcmVxdWVzdHMgdG8gZW5hYmxlIHRpbWUgc3RhbXBpbmcgb24gYm90aCBlZGdlcy4NCj4gICBp
Z2I6IFJlamVjdCByZXF1ZXN0cyB0aGF0IGZhaWwgdG8gZW5hYmxlIHRpbWUgc3RhbXBpbmcgb24g
Ym90aCBlZGdlcy4NCj4gICBtbHg1OiBSZWplY3QgcmVxdWVzdHMgdG8gZW5hYmxlIHRpbWUgc3Rh
bXBpbmcgb24gYm90aCBlZGdlcy4NCj4gICBwdHA6IEV4dGVuZCB0aGUgdGVzdCBwcm9ncmFtIHRv
IGNoZWNrIHRoZSBleHRlcm5hbCB0aW1lIHN0YW1wIGZsYWdzLg0KDQpNeSBvbmx5IHN1Z2dlc3Rp
b24gaGVyZSB3b3VsZCBiZSB0byBpbXBsZW1lbnQgdGhlIFNUUklDVCBmbGFnIHdpdGhvdXQgbW9k
aWZ5aW5nIGRyaXZlcnMsIGFuZCBoYXZlIGRyaXZlcnMgYWxsb3cgU1RSSUNUIGFuZCBiZWdpbiBj
aGVja2luZyBmb3IgaXQgYXQgdGhlIHNhbWUgdGltZS4NCg0KR2l2ZW4gdGhpcyBzZXJpZXMgYWxs
IGxhbmRzIHRvZ2V0aGVyIHRob3VnaCwgaXQncyBub3QgcmVhbGx5IGEgYmlnIGRlYWwgYmVjYXVz
ZSB0aGUgcmVzdWx0aW5nIHRyZWUgYWZ0ZXIgYWxsIHBhdGNoZXMgYXBwbHkgaXMgdGhlIHNhbWUu
DQoNCk92ZXJhbGw6DQoNCkFja2VkLWJ5OiBKYWNvYiBLZWxsZXIgPGphY29iLmUua2VsbGVyQGlu
dGVsLmNvbT4NCg0KVGhhbmtzLA0KSmFrZQ0KPiANCj4gIGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4
eHgvcHRwLmMgICAgICAgICAgICAgICB8IDEzICsrKysrDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5l
dC9icm9hZGNvbS90ZzMuYyAgICAgICAgICAgfCAgNCArKw0KPiAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaWdiL2lnYl9wdHAuYyAgICAgIHwgMTcgKysrKysrDQo+ICAuLi4vZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2xpYi9jbG9jay5jICAgfCAxNyArKysrKysNCj4gIGRyaXZlcnMv
bmV0L2V0aGVybmV0L21pY3JvY2hpcC9sYW43NDN4X3B0cC5jICB8ICA0ICsrDQo+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfcHRwLmMgICAgICAgfCAxMSArKysrDQo+ICAuLi4v
bmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19wdHAuYyAgfCAgNCArKw0KPiAgZHJp
dmVycy9uZXQvcGh5L2RwODM2NDAuYyAgICAgICAgICAgICAgICAgICAgIHwgMTYgKysrKysrDQo+
ICBkcml2ZXJzL3B0cC9wdHBfY2hhcmRldi5jICAgICAgICAgICAgICAgICAgICAgfCAyMCArKysr
Ky0tDQo+ICBpbmNsdWRlL3VhcGkvbGludXgvcHRwX2Nsb2NrLmggICAgICAgICAgICAgICAgfCAg
NSArLQ0KPiAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvcHRwL3Rlc3RwdHAuYyAgICAgICAgIHwg
NTMgKysrKysrKysrKysrKysrKysrLQ0KPiAgMTEgZmlsZXMgY2hhbmdlZCwgMTU2IGluc2VydGlv
bnMoKyksIDggZGVsZXRpb25zKC0pDQo+IA0KPiAtLQ0KPiAyLjIwLjENCg0K
