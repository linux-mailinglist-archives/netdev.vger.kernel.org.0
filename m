Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBBD37529D
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 12:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbhEFKwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 06:52:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:12689 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234508AbhEFKwR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 06:52:17 -0400
IronPort-SDR: +gzycfLx1ASjYHztv+JYxZ2B59lJ/4IE02FcETdwTl2YuL/eOMPksVmnfAfN3AVf6DNMO9KyUK
 vSkHnVJuBYqg==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="185570481"
X-IronPort-AV: E=Sophos;i="5.82,277,1613462400"; 
   d="scan'208";a="185570481"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 03:51:17 -0700
IronPort-SDR: 2raVY+fbAcShSc3Q65m5skKtlrBGD+bF4n0Z8ZALwBF5O1vxBLtSTsSW+Eo0/FNSMFj/gbZDlQ
 wjZCjZ4Ea18w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,277,1613462400"; 
   d="scan'208";a="464704326"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 06 May 2021 03:51:16 -0700
Received: from bgsmsx602.gar.corp.intel.com (10.109.78.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 6 May 2021 03:51:14 -0700
Received: from bgsmsx606.gar.corp.intel.com (10.67.234.8) by
 BGSMSX602.gar.corp.intel.com (10.109.78.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 6 May 2021 16:21:12 +0530
Received: from bgsmsx606.gar.corp.intel.com ([10.67.234.8]) by
 BGSMSX606.gar.corp.intel.com ([10.67.234.8]) with mapi id 15.01.2106.013;
 Thu, 6 May 2021 16:21:12 +0530
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Aleksander Morgado <aleksander@aleksander.es>,
        Loic Poulain <loic.poulain@linaro.org>
CC:     Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        linuxwwan <linuxwwan@intel.com>
Subject: RE: [PATCH V2 00/16] net: iosm: PCIe Driver for Intel M.2 Modem
Thread-Topic: [PATCH V2 00/16] net: iosm: PCIe Driver for Intel M.2 Modem
Thread-Index: AQHXNgA2O9IZst3fr0yOwGq3HtthJqrV4o4AgAB7P/A=
Date:   Thu, 6 May 2021 10:51:12 +0000
Message-ID: <2d2d9b2b138c454db0481d1c65b54a70@intel.com>
References: <20210420161310.16189-1-m.chetan.kumar@intel.com>
 <CAAP7ucLwXqvc8sNpm8NtowFnKxcWKAwqwJEE89s9eME1YgCowQ@mail.gmail.com>
In-Reply-To: <CAAP7ucLwXqvc8sNpm8NtowFnKxcWKAwqwJEE89s9eME1YgCowQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
x-originating-ip: [10.223.10.1]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxla3NhbmRlciwNCg0KPiA+IFRoZSBJT1NNIChJUEMgb3ZlciBTaGFyZWQgTWVtb3J5KSBk
cml2ZXIgaXMgYSBQQ0llIGhvc3QgZHJpdmVyDQo+ID4gaW1wbGVtZW50ZWQgZm9yIGxpbnV4IG9y
IGNocm9tZSBwbGF0Zm9ybSBmb3IgZGF0YSBleGNoYW5nZSBvdmVyIFBDSWUNCj4gPiBpbnRlcmZh
Y2UgYmV0d2VlbiBIb3N0IHBsYXRmb3JtICYgSW50ZWwgTS4yIE1vZGVtLiBUaGUgZHJpdmVyIGV4
cG9zZXMNCj4gPiBpbnRlcmZhY2UgY29uZm9ybWluZyB0byB0aGUgTUJJTSBwcm90b2NvbC4gQW55
IGZyb250IGVuZCBhcHBsaWNhdGlvbiAoDQo+ID4gZWc6IE1vZGVtIE1hbmFnZXIpIGNvdWxkIGVh
c2lseSBtYW5hZ2UgdGhlIE1CSU0gaW50ZXJmYWNlIHRvIGVuYWJsZQ0KPiBkYXRhIGNvbW11bmlj
YXRpb24gdG93YXJkcyBXV0FOLg0KPiA+DQo+ID4gSW50ZWwgTS4yIG1vZGVtIHVzZXMgMiBCQVIg
cmVnaW9ucy4gVGhlIGZpcnN0IHJlZ2lvbiBpcyBkZWRpY2F0ZWQgdG8NCj4gPiBEb29yYmVsbCBy
ZWdpc3RlciBmb3IgSVJRcyBhbmQgdGhlIHNlY29uZCByZWdpb24gaXMgdXNlZCBhcyBzY3JhdGNo
cGFkDQo+ID4gYXJlYSBmb3IgYm9vayBrZWVwaW5nIG1vZGVtIGV4ZWN1dGlvbiBzdGFnZSBkZXRh
aWxzIGFsb25nIHdpdGggaG9zdA0KPiA+IHN5c3RlbSBzaGFyZWQgbWVtb3J5IHJlZ2lvbiBjb250
ZXh0IGRldGFpbHMuIFRoZSB1cHBlciBlZGdlIG9mIHRoZQ0KPiA+IGRyaXZlciBleHBvc2VzIHRo
ZSBjb250cm9sIGFuZCBkYXRhIGNoYW5uZWxzIGZvciB1c2VyIHNwYWNlDQo+ID4gYXBwbGljYXRp
b24gaW50ZXJhY3Rpb24uIEF0IGxvd2VyIGVkZ2UgdGhlc2UgZGF0YSBhbmQgY29udHJvbCBjaGFu
bmVscw0KPiA+IGFyZSBhc3NvY2lhdGVkIHRvIHBpcGVzLiBUaGUgcGlwZXMgYXJlIGxvd2VzdCBs
ZXZlbCBpbnRlcmZhY2VzIHVzZWQNCj4gPiBvdmVyIFBDSWUgYXMgYSBsb2dpY2FsIGNoYW5uZWwg
Zm9yIG1lc3NhZ2UgZXhjaGFuZ2UuIEEgc2luZ2xlIGNoYW5uZWwgbWFwcw0KPiB0byBVTCBhbmQg
REwgcGlwZSBhbmQgYXJlIGluaXRpYWxpemVkIG9uIGRldmljZSBvcGVuLg0KPiA+DQo+ID4gT24g
VUwgcGF0aCwgZHJpdmVyIGNvcGllcyBhcHBsaWNhdGlvbiBzZW50IGRhdGEgdG8gU0tCcyBhc3Nv
Y2lhdGUgaXQNCj4gPiB3aXRoIHRyYW5zZmVyIGRlc2NyaXB0b3IgYW5kIHB1dHMgaXQgb24gdG8g
cmluZyBidWZmZXIgZm9yIERNQQ0KPiA+IHRyYW5zZmVyLiBPbmNlIGluZm9ybWF0aW9uIGhhcyBi
ZWVuIHVwZGF0ZWQgaW4gc2hhcmVkIG1lbW9yeSByZWdpb24sDQo+ID4gaG9zdCBnaXZlcyBhIERv
b3JiZWxsIHRvIG1vZGVtIHRvIHBlcmZvcm0gRE1BIGFuZCBtb2RlbSB1c2VzIE1TSSB0bw0KPiBj
b21tdW5pY2F0ZSBiYWNrIHRvIGhvc3QuDQo+ID4gRm9yIHJlY2VpdmluZyBkYXRhIGluIERMIHBh
dGgsIFNLQnMgYXJlIHByZS1hbGxvY2F0ZWQgZHVyaW5nIHBpcGUgb3Blbg0KPiA+IGFuZCB0cmFu
c2ZlciBkZXNjcmlwdG9ycyBhcmUgZ2l2ZW4gdG8gbW9kZW0gZm9yIERNQSB0cmFuc2Zlci4NCj4g
Pg0KPiA+IFRoZSBkcml2ZXIgZXhwb3NlcyB0d28gdHlwZXMgb2YgcG9ydHMsIG5hbWVseSAid3dh
bmN0cmwiLCBhIGNoYXINCj4gPiBkZXZpY2Ugbm9kZSB3aGljaCBpcyB1c2VkIGZvciBNQklNIGNv
bnRyb2wgb3BlcmF0aW9uIGFuZCAiSU5NeCIsKHggPQ0KPiA+IDAsMSwyLi43KSBuZXR3b3JrIGlu
dGVyZmFjZXMgZm9yIElQIGRhdGEgY29tbXVuaWNhdGlvbi4NCj4gDQo+IElzIHRoZXJlIGFueSBw
bGFuIHRvIGludGVncmF0ZSB0aGlzIGRyaXZlciBpbiB0aGUgbmV3ICJ3d2FuIiBzdWJzeXN0ZW0g
c28NCj4gdGhhdCB0aGUgY2hhcmFjdGVyIGRldmljZSBmb3IgTUJJTSBjb250cm9sIGlzIGV4cG9z
ZWQgaW4gdGhlIHNhbWUgZm9ybWF0DQo+IChpLmUuIHNhbWUgbmFtZSBydWxlcyBhbmQgc3VjaCkg
YXMgd2l0aCB0aGUgTUhJIGRyaXZlcj8NCj4gDQpZZXMsIHdlIGFyZSB3b3JraW5nIG9uIGl0LiBU
aGUgbmV4dCB2ZXJzaW9uIG9mIGRyaXZlciB3b3VsZCBoYXZlIHRoZXNlIGFkYXB0YXRpb24gdG8g
ZXhwb3NlIE1CSU0gIldXQU4gUG9ydCIuDQoNClJlZ2FyZHMsDQpDaGV0YW4NCg==
