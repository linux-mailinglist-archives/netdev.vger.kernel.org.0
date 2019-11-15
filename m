Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2457FD24D
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfKOBPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:15:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:45647 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbfKOBPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 20:15:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 17:15:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,306,1569308400"; 
   d="scan'208";a="214666950"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga001.fm.intel.com with ESMTP; 14 Nov 2019 17:15:29 -0800
Received: from orsmsx125.amr.corp.intel.com (10.22.240.125) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 14 Nov 2019 17:15:29 -0800
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.169]) by
 ORSMSX125.amr.corp.intel.com ([169.254.3.139]) with mapi id 14.03.0439.000;
 Thu, 14 Nov 2019 17:15:29 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Hall, Christopher S" <christopher.s.hall@intel.com>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        Feras Daoud <ferasda@mellanox.com>,
        "stefan.sorensen@spectralink.com" <stefan.sorensen@spectralink.com>,
        "brandon.streiff@ni.com" <brandon.streiff@ni.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>
Subject: RE: [PATCH net 06/13] mlx5: reject unsupported external timestamp
 flags
Thread-Topic: [PATCH net 06/13] mlx5: reject unsupported external timestamp
 flags
Thread-Index: AQHVmxuu8tFLlm8e7EeBgcX3fQ5mDaeL4AsA//+Nx0A=
Date:   Fri, 15 Nov 2019 01:15:27 +0000
Message-ID: <02874ECE860811409154E81DA85FBB5896990AC2@ORSMSX121.amr.corp.intel.com>
References: <20191114184507.18937-7-richardcochran@gmail.com>
 <c90050bd6a63ef3a6f0c7ea999f44ec51c07e917.camel@mellanox.com>
In-Reply-To: <c90050bd6a63ef3a6f0c7ea999f44ec51c07e917.camel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZDViNmVlYzgtMDI3Ny00NTkxLWJjMTEtMTU5ODQ0ZDY4ZjEyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTHNnaTVlV1NOakN6ZCtudm1mT1NMa0k4NFVcL2hyUnBTZW9IdHppR0Y1c2MzdEdnMnFpYlBZN2VwcFRlblZwQVMifQ==
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
ZWRtQG1lbGxhbm94LmNvbT4NCj4gU2VudDogVGh1cnNkYXksIE5vdmVtYmVyIDE0LCAyMDE5IDQ6
MDMgUE0NCj4gVG86IEFyaWVsIExldmtvdmljaCA8bGFyaWVsQG1lbGxhbm94LmNvbT47IHJpY2hh
cmRjb2NocmFuQGdtYWlsLmNvbTsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzogSGFs
bCwgQ2hyaXN0b3BoZXIgUyA8Y2hyaXN0b3BoZXIucy5oYWxsQGludGVsLmNvbT47IEV1Z2VuaWEg
RW1hbnRheWV2DQo+IDxldWdlbmlhQG1lbGxhbm94LmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7
DQo+IHNlcmdlaS5zaHR5bHlvdkBjb2dlbnRlbWJlZGRlZC5jb207IEZlcmFzIERhb3VkIDxmZXJh
c2RhQG1lbGxhbm94LmNvbT47DQo+IHN0ZWZhbi5zb3JlbnNlbkBzcGVjdHJhbGluay5jb207IGJy
YW5kb24uc3RyZWlmZkBuaS5jb207IEtlbGxlciwgSmFjb2IgRQ0KPiA8amFjb2IuZS5rZWxsZXJA
aW50ZWwuY29tPjsgS2lyc2hlciwgSmVmZnJleSBUIDxqZWZmcmV5LnQua2lyc2hlckBpbnRlbC5j
b20+Ow0KPiBpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZzsgZmVsaXBlLmJhbGJpQGxp
bnV4LmludGVsLmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldCAwNi8xM10gbWx4NTogcmVq
ZWN0IHVuc3VwcG9ydGVkIGV4dGVybmFsIHRpbWVzdGFtcA0KPiBmbGFncw0KPiANCj4gT24gVGh1
LCAyMDE5LTExLTE0IGF0IDEwOjQ1IC0wODAwLCBSaWNoYXJkIENvY2hyYW4gd3JvdGU6DQo+ID4g
RnJvbTogSmFjb2IgS2VsbGVyIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+DQo+ID4NCj4gPiBG
aXggdGhlIG1seDUgY29yZSBQVFAgc3VwcG9ydCB0byBleHBsaWNpdGx5IHJlamVjdCBhbnkgZnV0
dXJlIGZsYWdzDQo+ID4gdGhhdA0KPiA+IGdldCBhZGRlZCB0byB0aGUgZXh0ZXJuYWwgdGltZXN0
YW1wIHJlcXVlc3QgaW9jdGwuDQo+ID4NCj4gPiBJbiBvcmRlciB0byBtYWludGFpbiBjdXJyZW50
bHkgZnVuY3Rpb25pbmcgY29kZSwgdGhpcyBwYXRjaCBhY2NlcHRzDQo+ID4gYWxsDQo+ID4gdGhy
ZWUgY3VycmVudCBmbGFncy4gVGhpcyBpcyBiZWNhdXNlIHRoZSBQVFBfUklTSU5HX0VER0UgYW5k
DQo+ID4gUFRQX0ZBTExJTkdfRURHRSBmbGFncyBoYXZlIHVuY2xlYXIgc2VtYW50aWNzIGFuZCBl
YWNoIGRyaXZlciBzZWVtcw0KPiA+IHRvDQo+ID4gaGF2ZSBpbnRlcnByZXRlZCB0aGVtIHNsaWdo
dGx5IGRpZmZlcmVudGx5Lg0KPiA+DQo+ID4gWyBSQzogSSdtIG5vdCAxMDAlIHN1cmUgd2hhdCB0
aGlzIGRyaXZlciBkb2VzLCBidXQgaWYgSSdtIG5vdCB3cm9uZw0KPiA+IGl0DQo+ID4gICAgICAg
Zm9sbG93cyB0aGUgZHA4MzY0MDoNCj4gPg0KPiANCj4gVGhlIGRyaXZlciB3aWxsIGNoZWNrIGlm
IHRoZSBQVFBfRkFMTElOR19FREdFIGZsYWcgd2FzIHNldCB0aGVuIGl0IHdpbGwNCj4gc2V0IGl0
IGluIEhXLCBpZiBub3QgdGhlbiBpdCBpcyBnb2luZyB0byBkZWZhdWx0IHRvIFBUUF9SSVNJTkdf
RURHRSwgc28NCj4gTEdUTS4NCj4gDQo+IFJldmlld2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2Fl
ZWRtQG1lbGxhbm94LmNvbT4NCj4gDQo+IEJ1dCBzYW1lIHN0b3J5IGhlcmUsIG9sZCB0b29scyB0
aGF0IGxhemlseSBzZXQgMHhmZmZmIG9yIDB4MDAwMCBhbmQNCj4gZXhwZWN0ZWQgZXZlcnkgdGhp
bmcgdG8gd29yay4uIGFnYWluIG5vdCBzdXJlIGlmIHRoZXkgZG8gZXhpc3QuDQo+IA0KPiBBcmll
bCBwbGVhc2UgaGF2ZSBhIGxvb2sgYXQgdGhpcyBwYXRjaC4NCj4gDQoNCkFzIGxvbmcgYXMgdGhl
eSBzdGljayB0byB0aGUgb3JpZ2luYWwgaW9jdGxzIHRoaXMgd29uJ3QgYmUgYSBwcm9ibGVtLCBi
ZWNhdXNlIHRoZSB2MSBpb2N0bCBub3cgZXhwbGljaXRseSBjbGVhcnMgdW5zdXBwb3J0ZWQgYml0
cyBiZWZvcmUgY2FsbGluZyBkcml2ZXIsIHNvIHRoaXMgY2hlY2sgd2lsbCBwYXNzLiBPYnZpb3Vz
bHksIHRoaXMgY2hhbmdlIHNob3VsZCBub3QgYmUgYmFja3BvcnRlZCB0byBlYXJsaWVyIHRoYW4g
NS40IHdpdGhvdXQgYWxzbyBiYWNrcG9ydGluZyB0aGF0IG1hc2tpbmcgaW4gdGhlIG9yaWdpbmFs
IGlvY3RsIGZ1bmN0aW9ucy4NCg0KVGhhbmtzLA0KSmFrZQ0KDQo=
