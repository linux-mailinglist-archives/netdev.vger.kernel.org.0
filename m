Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8774D168451
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgBURBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:01:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:19856 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbgBURBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 12:01:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 09:01:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,469,1574150400"; 
   d="scan'208";a="240383036"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga006.jf.intel.com with ESMTP; 21 Feb 2020 09:01:27 -0800
Received: from fmsmsx123.amr.corp.intel.com (10.18.125.38) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 21 Feb 2020 09:01:26 -0800
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.69]) by
 fmsmsx123.amr.corp.intel.com ([169.254.7.117]) with mapi id 14.03.0439.000;
 Fri, 21 Feb 2020 09:01:26 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Parav Pandit <parav@mellanox.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>
Subject: RE: [RFC PATCH v4 10/25] RDMA/irdma: Add driver framework
 definitions
Thread-Topic: [RFC PATCH v4 10/25] RDMA/irdma: Add driver framework
 definitions
Thread-Index: AQHV4dioDC3nzfOBDEenlR28w/w9U6gbyl6AgAV2V/CAA/qhgIAAi8Wg
Date:   Fri, 21 Feb 2020 17:01:25 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7C60CE4C4@fmsmsx124.amr.corp.intel.com>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-11-jeffrey.t.kirsher@intel.com>
 <6f01d517-3196-1183-112e-8151b821bd72@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7C60C94AF@fmsmsx124.amr.corp.intel.com>
 <AM0PR05MB4866395BD477FAD269BCAE07D1130@AM0PR05MB4866.eurprd05.prod.outlook.com>
In-Reply-To: <AM0PR05MB4866395BD477FAD269BCAE07D1130@AM0PR05MB4866.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZWI3OTU2ZjYtMDQwMi00MzMwLTk0MzMtMmUyNmEyNTM5MWQ0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiamFVVjQ3MzJRUUdnQkpUZjd0ekFVcEYzT1wvbHFXNVFDMXo1N3JBMDVJbVBydHVZMGxJcnhrTktrRlVybXo2SnkifQ==
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSRTogW1JGQyBQQVRDSCB2NCAxMC8yNV0gUkRNQS9pcmRtYTogQWRkIGRyaXZl
ciBmcmFtZXdvcmsNCj4gZGVmaW5pdGlvbnMNCj4gDQoNClsuLi4uXQ0KDQo+ID4gPiA+ICtzdGF0
aWMgaW50IGlyZG1hX2RldmxpbmtfcmVsb2FkX3VwKHN0cnVjdCBkZXZsaW5rICpkZXZsaW5rLA0K
PiA+ID4gPiArCQkJCSAgIHN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFjaykgew0KPiA+ID4g
PiArCXN0cnVjdCBpcmRtYV9kbF9wcml2ICpwcml2ID0gZGV2bGlua19wcml2KGRldmxpbmspOw0K
PiA+ID4gPiArCXVuaW9uIGRldmxpbmtfcGFyYW1fdmFsdWUgc2F2ZWRfdmFsdWU7DQo+ID4gPiA+
ICsJY29uc3Qgc3RydWN0IHZpcnRidXNfZGV2X2lkICppZCA9IHByaXYtPnZkZXYtPm1hdGNoZWRf
ZWxlbWVudDsNCj4gPiA+DQo+ID4gPiBMaWtlIGlyZG1hX3Byb2JlKCksIHN0cnVjdCBpaWRjX3Zp
cnRidXNfb2JqZWN0ICp2byBpcyBhY2Nlc2libGUgZm9yDQo+ID4gPiB0aGUgZ2l2ZW4NCj4gPiBw
cml2Lg0KPiA+ID4gUGxlYXNlIHVzZSBzdHJ1Y3QgaWlkY192aXJ0YnVzX29iamVjdCBmb3IgYW55
IHNoYXJpbmcgYmV0d2VlbiB0d28gZHJpdmVycy4NCj4gPiA+IG1hdGNoZWRfZWxlbWVudCBtb2Rp
ZmljYXRpb24gaW5zaWRlIHRoZSB2aXJ0YnVzIG1hdGNoKCkgZnVuY3Rpb24gYW5kDQo+ID4gPiBh
Y2Nlc3NpbmcgcG9pbnRlciB0byBzb21lIGRyaXZlciBkYXRhIGJldHdlZW4gdHdvIGRyaXZlciB0
aHJvdWdoDQo+ID4gPiB0aGlzIG1hdGNoZWRfZWxlbWVudCBpcyBub3QgYXBwcm9wcmlhdGUuDQo+
ID4NCj4gPiBXZSBjYW4gcG9zc2libHkgYXZvaWQgbWF0Y2hlZF9lbGVtZW50IGFuZCBkcml2ZXIg
ZGF0YSBsb29rIHVwIGhlcmUuDQo+ID4gQnV0IGZ1bmRhbWVudGFsbHksIGF0IHByb2JlIHRpbWUg
KHNlZSBpcmRtYV9nZW5fcHJvYmUpIHRoZSBpcmRtYQ0KPiA+IGRyaXZlciBuZWVkcyB0byBrbm93
IHdoaWNoIGdlbmVyYXRpb24gdHlwZSBvZiB2ZGV2IHdlIGJvdW5kIHRvLiBpLmUuIGk0MGUgb3Ig
aWNlDQo+ID8NCj4gPiBzaW5jZSB3ZSBzdXBwb3J0IGJvdGguDQo+ID4gQW5kIGJhc2VkIG9uIGl0
LCBleHRyYWN0IHRoZSBkcml2ZXIgc3BlY2lmaWMgdmlydGJ1cyBkZXZpY2Ugb2JqZWN0LA0KPiA+
IGkuZSBpNDBlX3ZpcnRidXNfZGV2aWNlIHZzIGlpZGNfdmlydGJ1c19vYmplY3QgYW5kIGluaXQg
dGhhdCBkZXZpY2UuDQo+ID4NCj4gPiBBY2Nlc3NpbmcgZHJpdmVyX2RhdGEgb2ZmIHRoZSB2ZGV2
IG1hdGNoZWQgZW50cnkgaW4NCj4gPiBpcmRtYV92aXJ0YnVzX2lkX3RhYmxlIGlzIGhvdyB3ZSBr
bm93IHRoaXMgZ2VuZXJhdGlvbiBpbmZvIGFuZCBtYWtlIHRoZQ0KPiBkZWNpc2lvbi4NCj4gPg0K
PiBJZiB0aGVyZSBpcyBzaW5nbGUgaXJkbWEgZHJpdmVyIGZvciB0d28gZGlmZmVyZW50IHZpcnRi
dXMgZGV2aWNlIHR5cGVzLCBpdCBpcyBiZXR0ZXIgdG8NCj4gaGF2ZSB0d28gaW5zdGFuY2VzIG9m
IHZpcnRidXNfcmVnaXN0ZXJfZHJpdmVyKCkgd2l0aCBkaWZmZXJlbnQgbWF0Y2hpbmcgc3RyaW5n
L2lkLg0KPiBTbyBiYXNlZCBvbiB0aGUgcHJvYmUoKSwgaXQgd2lsbCBiZSBjbGVhciB3aXRoIHZp
cnRidXMgZGV2aWNlIG9mIGludGVyZXN0IGdvdCBhZGRlZC4NCj4gVGhpcyB3YXksIGNvZGUgd2ls
bCBoYXZlIGNsZWFyIHNlcGFyYXRpb24gYmV0d2VlbiB0d28gZGV2aWNlIHR5cGVzLg0KDQpUaGFu
a3MgZm9yIHRoZSBmZWVkYmFjayENCklzIGl0IGNvbW1vbiBwbGFjZSB0byBoYXZlIG11bHRpcGxl
IGRyaXZlcl9yZWdpc3RlciBpbnN0YW5jZXMgb2Ygc2FtZSBidXMgdHlwZQ0KaW4gYSBkcml2ZXIg
dG8gc3VwcG9ydCBkaWZmZXJlbnQgZGV2aWNlcz8gU2VlbXMgb2RkLg0KVHlwaWNhbGx5IGEgc2lu
Z2xlIGRyaXZlciB0aGF0IHN1cHBvcnRzIG11bHRpcGxlIGRldmljZSB0eXBlcyBmb3IgYSBzcGVj
aWZpYyBidXMtdHlwZQ0Kd291bGQgZG8gYSBzaW5nbGUgYnVzLXNwZWNpZmljIGRyaXZlcl9yZWdp
c3RlciBhbmQgcGFzcyBpbiBhbiBhcnJheSBvZiBidXMtc3BlY2lmaWMNCmRldmljZSBJRHMgYW5k
IGxldCB0aGUgYnVzIGRvIHRoZSBtYXRjaCB1cCBmb3IgeW91IHJpZ2h0PyBBbmQgaW4gdGhlIHBy
b2JlKCksIGEgZHJpdmVyIGNvdWxkIGRvIGRldmljZQ0Kc3BlY2lmaWMgcXVpcmtzIGZvciB0aGUg
ZGV2aWNlIHR5cGVzLiBJc250IHRoYXQgcHVycG9zZSBvZiBkZXZpY2UgSUQgdGFibGVzIGZvciBw
Y2ksIHBsYXRmb3JtLCB1c2IgZXRjPw0KV2h5IGFyZSB3ZSB0cnlpbmcgdG8gaGFuZGxlIG11bHRp
cGxlIHZpcnRidXMgZGV2aWNlIHR5cGVzIGZyb20gYSBkcml2ZXIgYW55IGRpZmZlcmVudGx5Pw0K
DQpTaGlyYXoNCg0KDQoNCiAgDQo=
