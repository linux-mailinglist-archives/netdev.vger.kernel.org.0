Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C18B3AD28B
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbhFRTMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:12:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:9107 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234004AbhFRTML (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:12:11 -0400
IronPort-SDR: DTHzcpPNea34cN//grxhvhiUZDHhuLIRfhO04MSD8t8/zRdM6kyjfFgqVEydEgOa6rKrXh5Cre
 UClFHVT5Sg+A==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="206558140"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="206558140"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 12:10:01 -0700
IronPort-SDR: x0kcwiBUVhLhtwOITWrSC5urJzsQAJW3Qz47P4YZ/dkPlv6bmZ2K05DnQngjWz7jnxyLw0KH43
 HcQojfmuIZWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="485791039"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga001.jf.intel.com with ESMTP; 18 Jun 2021 12:10:01 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 18 Jun 2021 12:10:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 18 Jun 2021 12:10:00 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2242.008;
 Fri, 18 Jun 2021 12:10:00 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Edward Harold Cree <ecree@xilinx.com>,
        "Dinan Gunawardena" <dinang@xilinx.com>,
        Pablo Cascon <pabloc@xilinx.com>
Subject: RE: Correct interpretation of VF link-state=auto
Thread-Topic: Correct interpretation of VF link-state=auto
Thread-Index: AQHXYdH/Wsv1Rjp0ckS+3imFUbY9K6sacX8A//+1hOA=
Date:   Fri, 18 Jun 2021 19:10:00 +0000
Message-ID: <9a0836b2f5ed487bb7d9c03a4b17222f@intel.com>
References: <CACT4oueyNoQAVW1FDcS_aus9sUqNvJhj87e_kUEkzz3azm2+pQ@mail.gmail.com>
 <20210618093506.245a4186@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210618093506.245a4186@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogRnJpZGF5LCBKdW5lIDE4LCAyMDIxIDk6MzUgQU0N
Cj4gVG86IMONw7FpZ28gSHVndWV0IDxpaHVndWV0QHJlZGhhdC5jb20+DQo+IENjOiBuZXRkZXZA
dmdlci5rZXJuZWwub3JnOyBJdmFuIFZlY2VyYSA8aXZlY2VyYUByZWRoYXQuY29tPjsgRWR3YXJk
IEhhcm9sZA0KPiBDcmVlIDxlY3JlZUB4aWxpbnguY29tPjsgRGluYW4gR3VuYXdhcmRlbmEgPGRp
bmFuZ0B4aWxpbnguY29tPjsgUGFibG8NCj4gQ2FzY29uIDxwYWJsb2NAeGlsaW54LmNvbT4NCj4g
U3ViamVjdDogUmU6IENvcnJlY3QgaW50ZXJwcmV0YXRpb24gb2YgVkYgbGluay1zdGF0ZT1hdXRv
DQo+IA0KPiBPbiBUdWUsIDE1IEp1biAyMDIxIDEyOjM0OjAwICswMjAwIMONw7FpZ28gSHVndWV0
IHdyb3RlOg0KPiA+IEhpLA0KPiA+DQo+ID4gUmVnYXJkaW5nIGxpbmstc3RhdGUgYXR0cmlidXRl
IGZvciBhIFZGLCAnbWFuIGlwLWxpbmsnIHNheXM6DQo+ID4gc3RhdGUgYXV0b3xlbmFibGV8ZGlz
YWJsZSAtIHNldCB0aGUgdmlydHVhbCBsaW5rIHN0YXRlIGFzIHNlZW4gYnkgdGhlDQo+ID4gc3Bl
Y2lmaWVkIFZGLiBTZXR0aW5nIHRvIGF1dG8gbWVhbnMgYSByZWZsZWN0aW9uIG9mIHRoZSBQRiBs
aW5rIHN0YXRlLA0KPiA+IGVuYWJsZSBsZXRzIHRoZSBWRiB0byBjb21tdW5pY2F0ZSB3aXRoIG90
aGVyIFZGcyBvbiB0aGlzIGhvc3QgZXZlbiBpZg0KPiA+IHRoZSBQRiBsaW5rIHN0YXRlIGlzIGRv
d24sIGRpc2FibGUgY2F1c2VzIHRoZSBIVyB0byBkcm9wIGFueSBwYWNrZXRzDQo+ID4gc2VudCBi
eSB0aGUgVkYuDQo+ID4NCj4gPiBIb3dldmVyLCBJJ3ZlIHNlZW4gdGhhdCBkaWZmZXJlbnQgaW50
ZXJwcmV0YXRpb25zIGFyZSBtYWRlIGFib3V0IHRoYXQNCj4gPiBleHBsYW5hdGlvbiwgZXNwZWNp
YWxseSBhYm91dCAiYXV0byIgY29uZmlndXJhdGlvbi4gSXQgaXMgbm90IGNsZWFyIGlmDQo+ID4g
aXQgc2hvdWxkIGZvbGxvdyBQRiAicGh5c2ljYWwgbGluayBzdGF0dXMiIG9yIFBGICJhZG1pbmlz
dHJhdGl2ZSBsaW5rDQo+ID4gc3RhdHVzIi4gV2l0aCB0aGUgbGF0dGVyLCBgaXAgc2V0IFBGIGRv
d25gIHdvdWxkIHB1dCB0aGUgVkYgZG93biB0b28sDQo+ID4gYnV0IHdpdGggdGhlIGZvcm1lciB5
b3UnZCBoYXZlIHRvIGRpc2Nvbm5lY3QgdGhlIHBoeXNpY2FsIHBvcnQuDQo+IA0KPiBMaWtlIGFs
bCBsZWdhY3kgU1ItSU9WIG5ldHdvcmtpbmcgdGhlIGNvcnJlY3QgdGhpbmcgdG8gZG8gaGVyZSBp
cyBjbGVhcg0KPiBhcyBtdWQuIEknZCBnbyBmb3IgdGhlIGxpbmsgc3RhdHVzIG9mIHRoZSBQRiBu
ZXRkZXYuIElmIHRoZSBuZXRkZXYNCj4gY2Fubm90IHBhc3MgdHJhZmZpYyAoZWl0aGVyIGZvciBh
ZG1pbmlzdHJhdGl2ZSBvciBwaHlzaWNhbCBsaW5rIHJlYXNvbnMpDQo+IHRoZW4gVkZzIHNob3Vs
ZG4ndCB0YWxrIGVpdGhlci4gQnV0IGFzIEkgc2FpZCwgZXZlcnkgdmVuZG9yIHdpbGwgaGF2ZSB0
aGVpcg0KPiBvd24gaW50ZXJwcmV0YXRpb24sIGFuZCBkaWZmZXJlbnQgdXNlcnMgbWF5IGV4cGVj
dCBkaWZmZXJlbnQgdGhpbmdzLi4uDQoNCkkgbGlrZSB0aGlzIGludGVycHJldGF0aW9uIHRvby4u
IGJ1dCBJIGFncmVlIHRoYXQgaXQncyB1bmZvcnR1bmF0ZWx5IGNvbmZ1c2luZyBhbmQgZWFjaCB2
ZW5kb3IgaGFzIGRvbmUgc29tZXRoaW5nIGRpZmZlcmVudC4uIDooDQo=
