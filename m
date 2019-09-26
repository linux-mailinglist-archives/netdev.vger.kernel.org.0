Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF01BE9CD
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 02:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfIZAsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 20:48:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:29490 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbfIZAsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 20:48:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 17:48:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,549,1559545200"; 
   d="scan'208";a="214235078"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga004.fm.intel.com with ESMTP; 25 Sep 2019 17:48:36 -0700
Received: from fmsmsx118.amr.corp.intel.com (10.18.116.18) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Sep 2019 17:48:35 -0700
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 fmsmsx118.amr.corp.intel.com (10.18.116.18) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Sep 2019 17:48:35 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.32]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.86]) with mapi id 14.03.0439.000;
 Thu, 26 Sep 2019 08:48:33 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
CC:     "christophe.de.dinechin@gmail.com" <christophe.de.dinechin@gmail.com>,
        "sebott@linux.ibm.com" <sebott@linux.ibm.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "joonas.lahtinen@linux.intel.com" <joonas.lahtinen@linux.intel.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "idos@mellanox.com" <idos@mellanox.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>
Subject: RE: [PATCH V2 6/8] mdev: introduce virtio device and its device ops
Thread-Topic: [PATCH V2 6/8] mdev: introduce virtio device and its device ops
Thread-Index: AQHVct/nWfANpdabEEm3hvDI5WX0fqc8F18A//+69ICAAU1IIA==
Date:   Thu, 26 Sep 2019 00:48:32 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D590FE4@SHSMSX104.ccr.corp.intel.com>
References: <20190924135332.14160-1-jasowang@redhat.com>
 <20190924135332.14160-7-jasowang@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58F7DA@SHSMSX104.ccr.corp.intel.com>
 <2210d23d-38e4-e654-e53d-7867348de86a@redhat.com>
In-Reply-To: <2210d23d-38e4-e654-e53d-7867348de86a@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZjBmZWE3NDEtODAyMC00YWM5LTgwMzctNGMzY2M1MTgxNWJhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNVQ5cWRBeUpYbWtWc3JLNmNDVmxOMlBReEVnMW5YZVFmQU5SaTB1SWd5V29IVWJuMlhyU0VkY1BVd3FORFpHUiJ9
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBKYXNvbiBXYW5nDQo+IFNlbnQ6IFdlZG5lc2RheSwgU2VwdGVtYmVyIDI1LCAyMDE5
IDg6NDUgUE0NCj4gDQo+IA0KPiBPbiAyMDE5LzkvMjUg5LiL5Y2INTowOSwgVGlhbiwgS2V2aW4g
d3JvdGU6DQo+ID4+IEZyb206IEphc29uIFdhbmcgW21haWx0bzpqYXNvd2FuZ0ByZWRoYXQuY29t
XQ0KPiA+PiBTZW50OiBUdWVzZGF5LCBTZXB0ZW1iZXIgMjQsIDIwMTkgOTo1NCBQTQ0KPiA+Pg0K
PiA+PiBUaGlzIHBhdGNoIGltcGxlbWVudHMgYmFzaWMgc3VwcG9ydCBmb3IgbWRldiBkcml2ZXIg
dGhhdCBzdXBwb3J0cw0KPiA+PiB2aXJ0aW8gdHJhbnNwb3J0IGZvciBrZXJuZWwgdmlydGlvIGRy
aXZlci4NCj4gPj4NCj4gPj4gU2lnbmVkLW9mZi1ieTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVk
aGF0LmNvbT4NCj4gPj4gLS0tDQo+ID4+ICAgaW5jbHVkZS9saW51eC9tZGV2LmggICAgICAgIHwg
ICAyICsNCj4gPj4gICBpbmNsdWRlL2xpbnV4L3ZpcnRpb19tZGV2LmggfCAxNDUNCj4gPj4gKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4+ICAgMiBmaWxlcyBjaGFuZ2Vk
LCAxNDcgaW5zZXJ0aW9ucygrKQ0KPiA+PiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBpbmNsdWRlL2xp
bnV4L3ZpcnRpb19tZGV2LmgNCj4gPj4NCj4gPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgv
bWRldi5oIGIvaW5jbHVkZS9saW51eC9tZGV2LmgNCj4gPj4gaW5kZXggMzQxNDMwNzMxMWYxLi43
M2FjMjdiM2I4NjggMTAwNjQ0DQo+ID4+IC0tLSBhL2luY2x1ZGUvbGludXgvbWRldi5oDQo+ID4+
ICsrKyBiL2luY2x1ZGUvbGludXgvbWRldi5oDQo+ID4+IEBAIC0xMjYsNiArMTI2LDggQEAgc3Ry
dWN0IG1kZXZfZGV2aWNlICptZGV2X2Zyb21fZGV2KHN0cnVjdA0KPiBkZXZpY2UNCj4gPj4gKmRl
dik7DQo+ID4+DQo+ID4+ICAgZW51bSB7DQo+ID4+ICAgCU1ERVZfSURfVkZJTyA9IDEsDQo+ID4+
ICsJTURFVl9JRF9WSVJUSU8gPSAyLA0KPiA+PiArCU1ERVZfSURfVkhPU1QgPSAzLA0KPiA+PiAg
IAkvKiBOZXcgZW50cmllcyBtdXN0IGJlIGFkZGVkIGhlcmUgKi8NCj4gPj4gICB9Ow0KPiA+Pg0K
PiA+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC92aXJ0aW9fbWRldi5oIGIvaW5jbHVkZS9s
aW51eC92aXJ0aW9fbWRldi5oDQo+ID4+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4+IGluZGV4
IDAwMDAwMDAwMDAwMC4uZDFhNDBhNzM5MjY2DQo+ID4+IC0tLSAvZGV2L251bGwNCj4gPj4gKysr
IGIvaW5jbHVkZS9saW51eC92aXJ0aW9fbWRldi5oDQo+ID4+IEBAIC0wLDAgKzEsMTQ1IEBADQo+
ID4+ICsvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovDQo+ID4+ICsv
Kg0KPiA+PiArICogVmlydGlvIG1lZGlhdGVkIGRldmljZSBkcml2ZXINCj4gPj4gKyAqDQo+ID4+
ICsgKiBDb3B5cmlnaHQgMjAxOSwgUmVkIEhhdCBDb3JwLg0KPiA+PiArICogICAgIEF1dGhvcjog
SmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gPj4gKyAqLw0KPiA+PiArI2lmbmRl
ZiBfTElOVVhfVklSVElPX01ERVZfSA0KPiA+PiArI2RlZmluZSBfTElOVVhfVklSVElPX01ERVZf
SA0KPiA+PiArDQo+ID4+ICsjaW5jbHVkZSA8bGludXgvaW50ZXJydXB0Lmg+DQo+ID4+ICsjaW5j
bHVkZSA8bGludXgvbWRldi5oPg0KPiA+PiArI2luY2x1ZGUgPHVhcGkvbGludXgvdmhvc3QuaD4N
Cj4gPj4gKw0KPiA+PiArI2RlZmluZSBWSVJUSU9fTURFVl9ERVZJQ0VfQVBJX1NUUklORwkJInZp
cnRpby0NCj4gbWRldiINCj4gPj4gKyNkZWZpbmUgVklSVElPX01ERVZfVkVSU0lPTiAweDENCj4g
PiBKdXN0IGJlIGN1cmlvdXMuIGlzIHRoaXMgdmVyc2lvbiBpZGVudGljYWwgdG8gdmlydGlvIHNw
ZWMgdmVyc2lvbiB0aGF0IGJlbG93DQo+ID4gY2FsbGJhY2tzIGFyZSBjcmVhdGVkIGZvciwgb3Ig
anVzdCBpcnJlbGV2YW50Pw0KPiANCj4gDQo+IEl0IGNvdWxkIGJlIGEgaGludCBidXQgYmFzaWNh
bGx5IGl0J3MgYSB3YXkgZm9yIHVzZXJzcGFjZSBkcml2ZXINCj4gY29tcGF0aWJpbGl0eS4gRm9y
IGtlcm5lbCB3ZSBkb24ndCBuZWVkIHRoaXMuDQo+IA0KPiANCj4gPg0KPiA+PiArDQo+ID4+ICtz
dHJ1Y3QgdmlydGlvX21kZXZfY2FsbGJhY2sgew0KPiA+PiArCWlycXJldHVybl90ICgqY2FsbGJh
Y2spKHZvaWQgKmRhdGEpOw0KPiA+PiArCXZvaWQgKnByaXZhdGU7DQo+ID4+ICt9Ow0KPiA+PiAr
DQo+ID4+ICsvKioNCj4gPj4gKyAqIHN0cnVjdCB2ZmlvX21kZXZfZGV2aWNlX29wcyAtIFN0cnVj
dHVyZSB0byBiZSByZWdpc3RlcmVkIGZvciBlYWNoDQo+ID4+ICsgKiBtZGV2IGRldmljZSB0byBy
ZWdpc3RlciB0aGUgZGV2aWNlIHRvIHZpcnRpby1tZGV2IG1vZHVsZS4NCj4gPj4gKyAqDQo+ID4+
ICsgKiBAc2V0X3ZxX2FkZHJlc3M6CQlTZXQgdGhlIGFkZHJlc3Mgb2YgdmlydHF1ZXVlDQo+ID4+
ICsgKgkJCQlAbWRldjogbWVkaWF0ZWQgZGV2aWNlDQo+ID4+ICsgKgkJCQlAaWR4OiB2aXJ0cXVl
dWUgaW5kZXgNCj4gPj4gKyAqCQkJCUBkZXNjX2FyZWE6IGFkZHJlc3Mgb2YgZGVzYyBhcmVhDQo+
ID4+ICsgKgkJCQlAZHJpdmVyX2FyZWE6IGFkZHJlc3Mgb2YgZHJpdmVyIGFyZWENCj4gPj4gKyAq
CQkJCUBkZXZpY2VfYXJlYTogYWRkcmVzcyBvZiBkZXZpY2UgYXJlYQ0KPiA+PiArICoJCQkJUmV0
dXJucyBpbnRlZ2VyOiBzdWNjZXNzICgwKSBvciBlcnJvciAoPCAwKQ0KPiA+PiArICogQHNldF92
cV9udW06CQlTZXQgdGhlIHNpemUgb2YgdmlydHF1ZXVlDQo+ID4+ICsgKgkJCQlAbWRldjogbWVk
aWF0ZWQgZGV2aWNlDQo+ID4+ICsgKgkJCQlAaWR4OiB2aXJ0cXVldWUgaW5kZXgNCj4gPj4gKyAq
CQkJCUBudW06IHRoZSBzaXplIG9mIHZpcnRxdWV1ZQ0KPiA+PiArICogQGtpY2tfdnE6CQkJS2lj
ayB0aGUgdmlydHF1ZXVlDQo+ID4+ICsgKgkJCQlAbWRldjogbWVkaWF0ZWQgZGV2aWNlDQo+ID4+
ICsgKgkJCQlAaWR4OiB2aXJ0cXVldWUgaW5kZXgNCj4gPj4gKyAqIEBzZXRfdnFfY2I6CQkJU2V0
IHRoZSBpbnRlcnJ1dCBjYWxiYWNrIGZ1bmN0aW9uIGZvcg0KPiA+PiArICoJCQkJYSB2aXJ0cXVl
dWUNCj4gPj4gKyAqCQkJCUBtZGV2OiBtZWRpYXRlZCBkZXZpY2UNCj4gPj4gKyAqCQkJCUBpZHg6
IHZpcnRxdWV1ZSBpbmRleA0KPiA+PiArICoJCQkJQGNiOiB2aXJ0aW8tbWRldiBpbnRlcnJ1cHQg
Y2FsbGJhY2sNCj4gPj4gc3RydWN0dXJlDQo+ID4+ICsgKiBAc2V0X3ZxX3JlYWR5OgkJU2V0IHJl
YWR5IHN0YXR1cyBmb3IgYSB2aXJ0cXVldWUNCj4gPj4gKyAqCQkJCUBtZGV2OiBtZWRpYXRlZCBk
ZXZpY2UNCj4gPj4gKyAqCQkJCUBpZHg6IHZpcnRxdWV1ZSBpbmRleA0KPiA+PiArICoJCQkJQHJl
YWR5OiByZWFkeSAodHJ1ZSkgbm90IHJlYWR5KGZhbHNlKQ0KPiA+PiArICogQGdldF92cV9yZWFk
eToJCUdldCByZWFkeSBzdGF0dXMgZm9yIGEgdmlydHF1ZXVlDQo+ID4+ICsgKgkJCQlAbWRldjog
bWVkaWF0ZWQgZGV2aWNlDQo+ID4+ICsgKgkJCQlAaWR4OiB2aXJ0cXVldWUgaW5kZXgNCj4gPj4g
KyAqCQkJCVJldHVybnMgYm9vbGVhbjogcmVhZHkgKHRydWUpIG9yIG5vdCAoZmFsc2UpDQo+ID4+
ICsgKiBAc2V0X3ZxX3N0YXRlOgkJU2V0IHRoZSBzdGF0ZSBmb3IgYSB2aXJ0cXVldWUNCj4gPj4g
KyAqCQkJCUBtZGV2OiBtZWRpYXRlZCBkZXZpY2UNCj4gPj4gKyAqCQkJCUBpZHg6IHZpcnRxdWV1
ZSBpbmRleA0KPiA+PiArICoJCQkJQHN0YXRlOiB2aXJ0cXVldWUgc3RhdGUgKGxhc3RfYXZhaWxf
aWR4KQ0KPiA+PiArICoJCQkJUmV0dXJucyBpbnRlZ2VyOiBzdWNjZXNzICgwKSBvciBlcnJvciAo
PCAwKQ0KPiA+PiArICogQGdldF92cV9zdGF0ZToJCUdldCB0aGUgc3RhdGUgZm9yIGEgdmlydHF1
ZXVlDQo+ID4+ICsgKgkJCQlAbWRldjogbWVkaWF0ZWQgZGV2aWNlDQo+ID4+ICsgKgkJCQlAaWR4
OiB2aXJ0cXVldWUgaW5kZXgNCj4gPj4gKyAqCQkJCVJldHVybnMgdmlydHF1ZXVlIHN0YXRlIChs
YXN0X2F2YWlsX2lkeCkNCj4gPj4gKyAqIEBnZXRfdnFfYWxpZ246CQlHZXQgdGhlIHZpcnRxdWV1
ZSBhbGlnbiByZXF1aXJlbWVudA0KPiA+PiArICoJCQkJZm9yIHRoZSBkZXZpY2UNCj4gPj4gKyAq
CQkJCUBtZGV2OiBtZWRpYXRlZCBkZXZpY2UNCj4gPj4gKyAqCQkJCVJldHVybnMgdmlydHF1ZXVl
IGFsZ2luIHJlcXVpcmVtZW50DQo+ID4+ICsgKiBAZ2V0X2ZlYXR1cmVzOgkJR2V0IHZpcnRpbyBm
ZWF0dXJlcyBzdXBwb3J0ZWQgYnkgdGhlIGRldmljZQ0KPiA+PiArICoJCQkJQG1kZXY6IG1lZGlh
dGVkIGRldmljZQ0KPiA+PiArICoJCQkJUmV0dXJucyB0aGUgZmVhdHVyZXMgc3VwcG9ydCBieSB0
aGUNCj4gPj4gKyAqCQkJCWRldmljZQ0KPiA+PiArICogQGdldF9mZWF0dXJlczoJCVNldCB2aXJ0
aW8gZmVhdHVyZXMgc3VwcG9ydGVkIGJ5IHRoZSBkcml2ZXINCj4gPj4gKyAqCQkJCUBtZGV2OiBt
ZWRpYXRlZCBkZXZpY2UNCj4gPj4gKyAqCQkJCUBmZWF0dXJlczogZmVhdHVyZSBzdXBwb3J0IGJ5
IHRoZSBkcml2ZXINCj4gPj4gKyAqCQkJCVJldHVybnMgaW50ZWdlcjogc3VjY2VzcyAoMCkgb3Ig
ZXJyb3IgKDwgMCkNCj4gPj4gKyAqIEBzZXRfY29uZmlnX2NiOgkJU2V0IHRoZSBjb25maWcgaW50
ZXJydXB0IGNhbGxiYWNrDQo+ID4+ICsgKgkJCQlAbWRldjogbWVkaWF0ZWQgZGV2aWNlDQo+ID4+
ICsgKgkJCQlAY2I6IHZpcnRpby1tZGV2IGludGVycnVwdCBjYWxsYmFjaw0KPiA+PiBzdHJ1Y3R1
cmUNCj4gPj4gKyAqIEBnZXRfZGV2aWNlX2lkOgkJR2V0IHZpcnRpbyBkZXZpY2UgaWQNCj4gPj4g
KyAqCQkJCUBtZGV2OiBtZWRpYXRlZCBkZXZpY2UNCj4gPj4gKyAqCQkJCVJldHVybnMgdTMyOiB2
aXJ0aW8gZGV2aWNlIGlkDQo+ID4+ICsgKiBAZ2V0X3ZlbmRvcl9pZDoJCUdldCB2aXJ0aW8gdmVu
ZG9yIGlkDQo+ID4+ICsgKgkJCQlAbWRldjogbWVkaWF0ZWQgZGV2aWNlDQo+ID4+ICsgKgkJCQlS
ZXR1cm5zIHUzMjogdmlydGlvIHZlbmRvciBpZA0KPiA+PiArICogQGdldF9zdGF0dXM6CQlHZXQg
dGhlIGRldmljZSBzdGF0dXMNCj4gPj4gKyAqCQkJCUBtZGV2OiBtZWRpYXRlZCBkZXZpY2UNCj4g
Pj4gKyAqCQkJCVJldHVybnMgdTg6IHZpcnRpbyBkZXZpY2Ugc3RhdHVzDQo+ID4+ICsgKiBAc2V0
X3N0YXR1czoJCVNldCB0aGUgZGV2aWNlIHN0YXR1cw0KPiA+PiArICoJCQkJQG1kZXY6IG1lZGlh
dGVkIGRldmljZQ0KPiA+PiArICoJCQkJQHN0YXR1czogdmlydGlvIGRldmljZSBzdGF0dXMNCj4g
Pj4gKyAqIEBnZXRfY29uZmlnOgkJUmVhZCBmcm9tIGRldmljZSBzcGVjaWZpYyBjb25maXVncmF0
aW9uDQo+ID4+IHNwYWNlDQo+ID4gY29uZmlndXJhdGlvbiAoYW5kIHNpbWlsYXIgdHlwb3MgZG93
bndhcmQpDQo+IA0KPiANCj4gTGV0IG1lIGZpeC4NCj4gDQo+IA0KPiA+DQo+ID4+ICsgKgkJCQlA
bWRldjogbWVkaWF0ZWQgZGV2aWNlDQo+ID4+ICsgKgkJCQlAb2Zmc2V0OiBvZmZzZXQgZnJvbSB0
aGUgYmVnaW5uaW5nIG9mDQo+ID4+ICsgKgkJCQljb25maWd1cmF0aW9uIHNwYWNlDQo+ID4+ICsg
KgkJCQlAYnVmOiBidWZmZXIgdXNlZCB0byByZWFkIHRvDQo+ID4+ICsgKgkJCQlAbGVuOiB0aGUg
bGVuZ3RoIHRvIHJlYWQgZnJvbQ0KPiA+PiArICoJCQkJY29uZmlncmF0aW9uIHNwYWNlDQo+ID4+
ICsgKiBAc2V0X2NvbmZpZzoJCVdyaXRlIHRvIGRldmljZSBzcGVjaWZpYyBjb25maXVncmF0aW9u
IHNwYWNlDQo+ID4+ICsgKgkJCQlAbWRldjogbWVkaWF0ZWQgZGV2aWNlDQo+ID4+ICsgKgkJCQlA
b2Zmc2V0OiBvZmZzZXQgZnJvbSB0aGUgYmVnaW5uaW5nIG9mDQo+ID4+ICsgKgkJCQljb25maWd1
cmF0aW9uIHNwYWNlDQo+ID4+ICsgKgkJCQlAYnVmOiBidWZmZXIgdXNlZCB0byB3cml0ZSBmcm9t
DQo+ID4+ICsgKgkJCQlAbGVuOiB0aGUgbGVuZ3RoIHRvIHdyaXRlIHRvDQo+ID4+ICsgKgkJCQlj
b25maWdyYXRpb24gc3BhY2UNCj4gPj4gKyAqIEBnZXRfdmVyc2lvbjoJCUdldCB0aGUgdmVyc2lv
biBvZiB2aXJ0aW8gbWRldiBkZXZpY2UNCj4gPj4gKyAqCQkJCUBtZGV2OiBtZWRpYXRlZCBkZXZp
Y2UNCj4gPj4gKyAqCQkJCVJldHVybnMgaW50ZWdlcjogdmVyc2lvbiBvZiB0aGUgZGV2aWNlDQo+
ID4+ICsgKiBAZ2V0X2dlbmVyYXRpb246CQlHZXQgZGV2aWNlIGdlbmVyYXRvbg0KPiA+PiArICoJ
CQkJQG1kZXY6IG1lZGlhdGVkIGRldmljZQ0KPiA+PiArICoJCQkJUmV0dXJucyB1MzI6IGRldmlj
ZSBnZW5lcmF0aW9uDQo+ID4+ICsgKi8NCj4gPj4gK3N0cnVjdCB2aXJ0aW9fbWRldl9kZXZpY2Vf
b3BzIHsNCj4gPj4gKwkvKiBWaXJ0cXVldWUgb3BzICovDQo+ID4+ICsJaW50ICgqc2V0X3ZxX2Fk
ZHJlc3MpKHN0cnVjdCBtZGV2X2RldmljZSAqbWRldiwNCj4gPj4gKwkJCSAgICAgIHUxNiBpZHgs
IHU2NCBkZXNjX2FyZWEsIHU2NCBkcml2ZXJfYXJlYSwNCj4gPj4gKwkJCSAgICAgIHU2NCBkZXZp
Y2VfYXJlYSk7DQo+ID4+ICsJdm9pZCAoKnNldF92cV9udW0pKHN0cnVjdCBtZGV2X2RldmljZSAq
bWRldiwgdTE2IGlkeCwgdTMyIG51bSk7DQo+ID4+ICsJdm9pZCAoKmtpY2tfdnEpKHN0cnVjdCBt
ZGV2X2RldmljZSAqbWRldiwgdTE2IGlkeCk7DQo+ID4+ICsJdm9pZCAoKnNldF92cV9jYikoc3Ry
dWN0IG1kZXZfZGV2aWNlICptZGV2LCB1MTYgaWR4LA0KPiA+PiArCQkJICBzdHJ1Y3QgdmlydGlv
X21kZXZfY2FsbGJhY2sgKmNiKTsNCj4gPj4gKwl2b2lkICgqc2V0X3ZxX3JlYWR5KShzdHJ1Y3Qg
bWRldl9kZXZpY2UgKm1kZXYsIHUxNiBpZHgsIGJvb2wNCj4gPj4gcmVhZHkpOw0KPiA+PiArCWJv
b2wgKCpnZXRfdnFfcmVhZHkpKHN0cnVjdCBtZGV2X2RldmljZSAqbWRldiwgdTE2IGlkeCk7DQo+
ID4+ICsJaW50ICgqc2V0X3ZxX3N0YXRlKShzdHJ1Y3QgbWRldl9kZXZpY2UgKm1kZXYsIHUxNiBp
ZHgsIHU2NCBzdGF0ZSk7DQo+ID4+ICsJdTY0ICgqZ2V0X3ZxX3N0YXRlKShzdHJ1Y3QgbWRldl9k
ZXZpY2UgKm1kZXYsIHUxNiBpZHgpOw0KPiA+PiArDQo+ID4+ICsJLyogRGV2aWNlIG9wcyAqLw0K
PiA+PiArCXUxNiAoKmdldF92cV9hbGlnbikoc3RydWN0IG1kZXZfZGV2aWNlICptZGV2KTsNCj4g
Pj4gKwl1NjQgKCpnZXRfZmVhdHVyZXMpKHN0cnVjdCBtZGV2X2RldmljZSAqbWRldik7DQo+ID4+
ICsJaW50ICgqc2V0X2ZlYXR1cmVzKShzdHJ1Y3QgbWRldl9kZXZpY2UgKm1kZXYsIHU2NCBmZWF0
dXJlcyk7DQo+ID4+ICsJdm9pZCAoKnNldF9jb25maWdfY2IpKHN0cnVjdCBtZGV2X2RldmljZSAq
bWRldiwNCj4gPj4gKwkJCSAgICAgIHN0cnVjdCB2aXJ0aW9fbWRldl9jYWxsYmFjayAqY2IpOw0K
PiA+PiArCXUxNiAoKmdldF9xdWV1ZV9tYXgpKHN0cnVjdCBtZGV2X2RldmljZSAqbWRldik7DQo+
ID4+ICsJdTMyICgqZ2V0X2RldmljZV9pZCkoc3RydWN0IG1kZXZfZGV2aWNlICptZGV2KTsNCj4g
Pj4gKwl1MzIgKCpnZXRfdmVuZG9yX2lkKShzdHJ1Y3QgbWRldl9kZXZpY2UgKm1kZXYpOw0KPiA+
PiArCXU4ICgqZ2V0X3N0YXR1cykoc3RydWN0IG1kZXZfZGV2aWNlICptZGV2KTsNCj4gPj4gKwl2
b2lkICgqc2V0X3N0YXR1cykoc3RydWN0IG1kZXZfZGV2aWNlICptZGV2LCB1OCBzdGF0dXMpOw0K
PiA+PiArCXZvaWQgKCpnZXRfY29uZmlnKShzdHJ1Y3QgbWRldl9kZXZpY2UgKm1kZXYsIHVuc2ln
bmVkIGludCBvZmZzZXQsDQo+ID4+ICsJCQkgICB2b2lkICpidWYsIHVuc2lnbmVkIGludCBsZW4p
Ow0KPiA+PiArCXZvaWQgKCpzZXRfY29uZmlnKShzdHJ1Y3QgbWRldl9kZXZpY2UgKm1kZXYsIHVu
c2lnbmVkIGludCBvZmZzZXQsDQo+ID4+ICsJCQkgICBjb25zdCB2b2lkICpidWYsIHVuc2lnbmVk
IGludCBsZW4pOw0KPiA+PiArCWludCAoKmdldF92ZXJzaW9uKShzdHJ1Y3QgbWRldl9kZXZpY2Ug
Km1kZXYpOw0KPiA+PiArCXUzMiAoKmdldF9nZW5lcmF0aW9uKShzdHJ1Y3QgbWRldl9kZXZpY2Ug
Km1kZXYpOw0KPiA+PiArfTsNCj4gPiBJJ20gbm90IHN1cmUgaG93IHN0YWJsZSBhYm92ZSBvcHMg
YXJlLg0KPiANCj4gDQo+IEl0J3MgdGhlIGtlcm5lbCBpbnRlcm5hbCBBUEksIHNvIHRoZXJlJ3Mg
bm8gc3RyaWN0IHJlcXVpcmVtZW50IGZvciB0aGlzLg0KPiBXZSB3aWxsIGV4cG9ydCBhIHZlcnNp
b24gdmFsdWUgZm9yIHVzZXJzcGFjZSBmb3IgY29tcGF0aWJpbGl0eS4NCj4gDQo+IA0KPiA+IERv
ZXMgaXQgbWFrZSBzZW5zZSBpZiBkZWZpbmluZw0KPiA+IGp1c3QgdHdvIGNhbGxiYWNrcyBoZXJl
LCBlLmcuIHZxX2N0cmwgYW5kIGRldmljZV9jdHJsLCBhbmQgdGhlbiBsZXQgdGhlDQo+ID4gdmVu
ZG9yIGRyaXZlciB0byBoYW5kbGUgc3BlY2lmaWMgb3BzIGluIGVhY2ggY2F0ZWdvcnkgKHNpbWls
YXIgdG8gaG93DQo+ID4gaW9jdGwgd29ya3MpPw0KPiANCj4gDQo+IE15IHVuZGVyc3RhbmRpbmcg
aXMgdGhhdCBpdCBpbnRyb2R1Y2UgYW5vdGhlciBpbmRpcmVjdGlvbiwgeW91IHN0aWxsDQo+IG5l
ZWQgdG8gZGlmZmVyIGZyb20gZGlmZmVyZW50IGNvbW1hbmQsIGFuZCBpdCdzIGxlc3MgZmxleGli
bGUgdGhhbg0KPiBkaXJlY3QgY2FsbGJhY2suDQo+IA0KPiBXaGF0J3MgdGhlIHZhbHVlIG9mIGRv
aW5nIHRoaXM/DQo+IA0KDQpJIGp1c3QgdGhvdWdodCBkb2luZyBzbyBtYXkgcHJvdmlkZSBiZXR0
ZXIgY29tcGF0aWJpbGl0eSB0byB0aGUNCnBhcmVudCBkcml2ZXIuIEV2ZW4gd2hlbiBuZXcgb3Ag
aXMgaW50cm9kdWNlZCwgYSBwYXJlbnQgZHJpdmVyDQp0aGF0IHdhcyBkZXZlbG9wZWQgYWdhaW5z
dCB0aGUgb2xkIHNldCBjYW4gc3RpbGwgYmUgbG9hZGVkIGluIHRoZQ0KbmV3IGtlcm5lbC4gSXQg
anVzdCByZXR1cm5zIGVycm9yIHdoZW4gdW5yZWNvZ25pemVkIG9wcyBhcmUNCnJvdXRlZCB0aHJv
dWdoIHZxX2N0cmwgYW5kIGRldmljZV9jdHJsLCBpZiB0aGUgdXNlcnNwYWNlIGRvZXNuJ3QNCmZh
dm9yIHRoZSBleHBvc2VkIHZlcnNpb24gdmFsdWUuIEJ1dCBpZiBhYm92ZSBvcHMgc2V0IGlzIHBy
ZXR0eQ0Kc3RhYmxlLCB0aGVuIHRoaXMgY29tbWVudCBjYW4gYmUgaWdub3JlZC4NCg0KVGhhbmtz
DQpLZXZpbg0K
