Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193A428BF08
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 19:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404014AbgJLRaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 13:30:19 -0400
Received: from mga18.intel.com ([134.134.136.126]:16410 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403805AbgJLRaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 13:30:18 -0400
IronPort-SDR: Lte+Qdh+kiDFRsMAYSeuhwSd9OZjqGSucHI6YYUFD16otlR28Vv6I7kg9DWKuNTndE1GTf/yMO
 jsJhXVvYkuOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="153607049"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="153607049"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 10:30:15 -0700
IronPort-SDR: fN6YXJQH1FWPsqbVK6pjvstylIuY0gJD/e8afyRVwg//EZbPgE7Lyo/xg03xOTv4/RSm+Zpwuj
 YgDZtY5bhl9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="329826478"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga002.jf.intel.com with ESMTP; 12 Oct 2020 10:30:14 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Oct 2020 10:30:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Oct 2020 10:30:13 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.1713.004;
 Mon, 12 Oct 2020 10:30:13 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Subject: RE: [iproute2-next v2 1/1] devlink: display elapsed time during flash
 update
Thread-Topic: [iproute2-next v2 1/1] devlink: display elapsed time during
 flash update
Thread-Index: AQHWl4Mt/hJpQ0sC1UikC4FCWd+lOqmMI3SAgAgn/oA=
Date:   Mon, 12 Oct 2020 17:30:13 +0000
Message-ID: <e039e78a96c7442aa542f4bac60eb186@intel.com>
References: <20200930234012.137020-1-jacob.e.keller@intel.com>
 <5ebd3324-1acc-8d9b-2f45-7c4878ad7acc@gmail.com>
In-Reply-To: <5ebd3324-1acc-8d9b-2f45-7c4878ad7acc@gmail.com>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRz
YWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBPY3RvYmVyIDA2LCAyMDIwIDEwOjU2
IFBNDQo+IFRvOiBLZWxsZXIsIEphY29iIEUgPGphY29iLmUua2VsbGVyQGludGVsLmNvbT47IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IEpha3ViDQo+IEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+
OyBTaGFubm9uIE5lbHNvbiA8c25lbHNvbkBwZW5zYW5kby5pbz4NCj4gU3ViamVjdDogUmU6IFtp
cHJvdXRlMi1uZXh0IHYyIDEvMV0gZGV2bGluazogZGlzcGxheSBlbGFwc2VkIHRpbWUgZHVyaW5n
IGZsYXNoDQo+IHVwZGF0ZQ0KPiANCj4gT24gOS8zMC8yMCA0OjQwIFBNLCBKYWNvYiBLZWxsZXIg
d3JvdGU6DQo+ID4gQEAgLTMxMjQsMTIgKzMxNDAsMTkgQEAgc3RhdGljIGludCBjbWRfZGV2X2Zs
YXNoX3N0YXR1c19jYihjb25zdCBzdHJ1Y3QNCj4gbmxtc2doZHIgKm5saCwgdm9pZCAqZGF0YSkN
Cj4gPiAgCQlkb25lID0NCj4gbW5sX2F0dHJfZ2V0X3U2NCh0YltERVZMSU5LX0FUVFJfRkxBU0hf
VVBEQVRFX1NUQVRVU19ET05FXSk7DQo+ID4gIAlpZiAodGJbREVWTElOS19BVFRSX0ZMQVNIX1VQ
REFURV9TVEFUVVNfVE9UQUxdKQ0KPiA+ICAJCXRvdGFsID0NCj4gbW5sX2F0dHJfZ2V0X3U2NCh0
YltERVZMSU5LX0FUVFJfRkxBU0hfVVBEQVRFX1NUQVRVU19UT1RBTF0pOw0KPiA+ICsJaWYgKHRi
W0RFVkxJTktfQVRUUl9GTEFTSF9VUERBVEVfU1RBVFVTX1RJTUVPVVRdKQ0KPiA+ICsJCWN0eC0+
c3RhdHVzX21zZ190aW1lb3V0ID0NCj4gbW5sX2F0dHJfZ2V0X3U2NCh0YltERVZMSU5LX0FUVFJf
RkxBU0hfVVBEQVRFX1NUQVRVU19USU1FT1VUXSk7DQo+ID4gKwllbHNlDQo+ID4gKwkJY3R4LT5z
dGF0dXNfbXNnX3RpbWVvdXQgPSAwOw0KPiA+DQo+ID4gIAlpZiAoIW51bGxzdHJjbXAobXNnLCBj
dHgtPmxhc3RfbXNnKSAmJg0KPiA+ICAJICAgICFudWxsc3RyY21wKGNvbXBvbmVudCwgY3R4LT5s
YXN0X2NvbXBvbmVudCkgJiYNCj4gPiAgCSAgICBjdHgtPmxhc3RfcGMgJiYgY3R4LT5ub3RfZmly
c3QpIHsNCj4gPiAgCQlwcl9vdXRfdHR5KCJcYlxiXGJcYlxiIik7IC8qIGNsZWFuIHBlcmNlbnRh
Z2UgKi8NCj4gPiAgCX0gZWxzZSB7DQo+ID4gKwkJLyogb25seSB1cGRhdGUgdGhlIGxhc3Qgc3Rh
dHVzIHRpbWVzdGFtcCBpZiB0aGUgbWVzc2FnZSBjaGFuZ2VkDQo+ICovDQo+ID4gKwkJZ2V0dGlt
ZW9mZGF5KCZjdHgtPnRpbWVfb2ZfbGFzdF9zdGF0dXMsIE5VTEwpOw0KPiANCj4gZ2V0dGltZW9m
ZGF5L1JFQUxDTE9DSyBzaG91bGQgbm90IGJlIHVzZWQgZm9yIG1lYXN1cmluZyB0aW1lIGRpZmZl
cmVuY2VzLg0KPiANCg0KQWguIEdvb2QgcG9pbnQuIFRoaXMgc2hvdWxkIHVzZSBDTE9DS19NT05P
VE9OSUMgaW5zdGVhZCwgcmlnaHQ/DQoNCj4gPiArDQo+ID4gIAkJaWYgKGN0eC0+bm90X2ZpcnN0
KQ0KPiA+ICAJCQlwcl9vdXQoIlxuIik7DQo+ID4gIAkJaWYgKGNvbXBvbmVudCkgew0KPiA+IEBA
IC0zMTU1LDExICszMTc4LDcyIEBAIHN0YXRpYyBpbnQgY21kX2Rldl9mbGFzaF9zdGF0dXNfY2Io
Y29uc3Qgc3RydWN0DQo+IG5sbXNnaGRyICpubGgsIHZvaWQgKmRhdGEpDQo+ID4gIAlyZXR1cm4g
TU5MX0NCX1NUT1A7DQo+ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMgdm9pZCBjbWRfZGV2X2ZsYXNo
X3RpbWVfZWxhcHNlZChzdHJ1Y3QgY21kX2Rldl9mbGFzaF9zdGF0dXNfY3R4DQo+ICpjdHgpDQo+
ID4gK3sNCj4gPiArCXN0cnVjdCB0aW1ldmFsIG5vdywgcmVzOw0KPiA+ICsNCj4gPiArCWdldHRp
bWVvZmRheSgmbm93LCBOVUxMKTsNCj4gPiArCXRpbWVyc3ViKCZub3csICZjdHgtPnRpbWVfb2Zf
bGFzdF9zdGF0dXMsICZyZXMpOw0KPiA+ICsNCg==
