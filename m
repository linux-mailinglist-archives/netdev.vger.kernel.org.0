Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EB33A8941
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 21:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhFOTM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 15:12:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:31617 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229965AbhFOTM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 15:12:27 -0400
IronPort-SDR: ce2NZFd+TeEI44pWfpuvinLsrLojCOaiBY77gkxL8JU2gt1jIsUKgU2fDGrolF+8W7lHdCURel
 qZwP4CAriDmA==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="185746833"
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="185746833"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 12:10:22 -0700
IronPort-SDR: BBNWZZGqMtdYPlOKGya2IVVrKlKIErJ1J1T/1nnCVwL0ngXPP8rByLkAWUcEtYQQTtERSHPUJ3
 97gvO98efxGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="421225339"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 15 Jun 2021 12:10:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 15 Jun 2021 12:10:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 15 Jun 2021 12:10:20 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2242.008;
 Tue, 15 Jun 2021 12:10:20 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>
Subject: RE: [PATCH net-next] net: ice: ptp: fix compilation warning if
 PTP_1588_CLOCK is disabled
Thread-Topic: [PATCH net-next] net: ice: ptp: fix compilation warning if
 PTP_1588_CLOCK is disabled
Thread-Index: AQHXYfC+2ycw0ilY+kC1Kg1v1BdMpqsVcB2w
Date:   Tue, 15 Jun 2021 19:10:20 +0000
Message-ID: <94536f439c894854b5109e77e830729c@intel.com>
References: <a4d2c3cd609708de38ca59b75e4eb7468750af47.1623766418.git.lorenzo@kernel.org>
In-Reply-To: <a4d2c3cd609708de38ca59b75e4eb7468750af47.1623766418.git.lorenzo@kernel.org>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTG9yZW56byBCaWFuY29u
aSA8bG9yZW56b0BrZXJuZWwub3JnPg0KPiBTZW50OiBUdWVzZGF5LCBKdW5lIDE1LCAyMDIxIDc6
MTQgQU0NCj4gVG86IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGxvcmVuem8uYmlhbmNv
bmlAcmVkaGF0LmNvbTsgS2VsbGVyLCBKYWNvYiBFIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+
DQo+IFN1YmplY3Q6IFtQQVRDSCBuZXQtbmV4dF0gbmV0OiBpY2U6IHB0cDogZml4IGNvbXBpbGF0
aW9uIHdhcm5pbmcgaWYNCj4gUFRQXzE1ODhfQ0xPQ0sgaXMgZGlzYWJsZWQNCj4gDQo+IEZpeCB0
aGUgZm9sbG93aW5nIGNvbXBpbGF0aW9uIHdhcm5pbmcgaWYgUFRQXzE1ODhfQ0xPQ0sgaXMgbm90
IGVuYWJsZWQNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfcHRwLmg6
MTQ5OjE6DQo+ICAgIGVycm9yOiByZXR1cm4gdHlwZSBkZWZhdWx0cyB0byDigJhpbnTigJkgWy1X
ZXJyb3I9cmV0dXJuLXR5cGVdDQo+ICAgIGljZV9wdHBfcmVxdWVzdF90cyhzdHJ1Y3QgaWNlX3B0
cF90eCAqdHgsIHN0cnVjdCBza19idWZmICpza2IpDQo+IA0KPiBGaXhlczogZWE5Yjg0N2NkYTY0
NyAoImljZTogZW5hYmxlIHRyYW5zbWl0IHRpbWVzdGFtcHMgZm9yIEU4MTAgZGV2aWNlcyIpDQo+
IFNpZ25lZC1vZmYtYnk6IExvcmVuem8gQmlhbmNvbmkgPGxvcmVuem9Aa2VybmVsLm9yZz4NCg0K
DQpIYWguIFRoYW5rcy4gVGhpcyBpcyBvYnZpb3VzbHkgY29ycmVjdC4NCg0KUmV2aWV3ZWQtYnk6
IEphY29iIEtlbGxlciA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPg0KDQo+IC0tLQ0KPiAgZHJp
dmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9wdHAuaCB8IDIgKy0NCj4gIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfcHRwLmgNCj4gYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3B0cC5oDQo+IGluZGV4IDQxZTE0Zjk4ZjBlNi4uZDAx
NTA3ZWJhMDM2IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2Uv
aWNlX3B0cC5oDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfcHRw
LmgNCj4gQEAgLTE0NSw3ICsxNDUsNyBAQCBzdGF0aWMgaW5saW5lIGludCBpY2VfZ2V0X3B0cF9j
bG9ja19pbmRleChzdHJ1Y3QgaWNlX3BmICpwZikNCj4gIAlyZXR1cm4gLTE7DQo+ICB9DQo+IA0K
PiAtc3RhdGljIGlubGluZQ0KPiArc3RhdGljIGlubGluZSBzOA0KPiAgaWNlX3B0cF9yZXF1ZXN0
X3RzKHN0cnVjdCBpY2VfcHRwX3R4ICp0eCwgc3RydWN0IHNrX2J1ZmYgKnNrYikNCj4gIHsNCj4g
IAlyZXR1cm4gLTE7DQo+IC0tDQo+IDIuMzEuMQ0KDQo=
