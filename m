Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1990D375292
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 12:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbhEFKqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 06:46:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:17452 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234403AbhEFKqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 06:46:01 -0400
IronPort-SDR: BiAO4G/i2c8+BEHpuk12Nuf9cP3P6KJuie/c2IK5mi2srmz7QZ5kH4QUFjWtZo5Y4Rk+NLq0zU
 EfZo/2W2Cl6w==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="195321721"
X-IronPort-AV: E=Sophos;i="5.82,277,1613462400"; 
   d="scan'208";a="195321721"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 03:45:00 -0700
IronPort-SDR: fKcwNUguyyiTGt7q4SIq1fzMQi+hXKu/Qb98aiQtckcMGryJczNfWVD3dqachWK+pmj/+futyD
 FVptrCBjR9Hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,277,1613462400"; 
   d="scan'208";a="406958446"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga002.jf.intel.com with ESMTP; 06 May 2021 03:45:00 -0700
Received: from bgsmsx603.gar.corp.intel.com (10.109.78.82) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 6 May 2021 03:44:58 -0700
Received: from bgsmsx606.gar.corp.intel.com (10.67.234.8) by
 BGSMSX603.gar.corp.intel.com (10.109.78.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 6 May 2021 16:14:56 +0530
Received: from bgsmsx606.gar.corp.intel.com ([10.67.234.8]) by
 BGSMSX606.gar.corp.intel.com ([10.67.234.8]) with mapi id 15.01.2106.013;
 Thu, 6 May 2021 16:14:56 +0530
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Loic Poulain <loic.poulain@linaro.org>
CC:     Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        linuxwwan <linuxwwan@intel.com>
Subject: RE: [PATCH V2 07/16] net: iosm: mbim control device
Thread-Topic: [PATCH V2 07/16] net: iosm: mbim control device
Thread-Index: AQHXNgBFu68cEEPLMkK+xtAuWpN4BKrV62GAgABsimA=
Date:   Thu, 6 May 2021 10:44:56 +0000
Message-ID: <fd6b57f1e3b1444383ad5387de36e1cc@intel.com>
References: <20210420161310.16189-1-m.chetan.kumar@intel.com>
 <20210420161310.16189-8-m.chetan.kumar@intel.com>
 <CAMZdPi8h7ubOvUBaF2wh87UBwzJz3GpQ3gZwSXy0miV7Aw2NXw@mail.gmail.com>
In-Reply-To: <CAMZdPi8h7ubOvUBaF2wh87UBwzJz3GpQ3gZwSXy0miV7Aw2NXw@mail.gmail.com>
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

SGkgTG9pYywNCg0KPiA+DQo+ID4gSW1wbGVtZW50cyBhIGNoYXIgZGV2aWNlIGZvciBNQklNIHBy
b3RvY29sIGNvbW11bmljYXRpb24gJiBwcm92aWRlcyBhDQo+ID4gc2ltcGxlIElPQ1RMIGZvciBt
YXggdHJhbnNmZXIgYnVmZmVyIHNpemUgY29uZmlndXJhdGlvbi4NCj4gPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IE0gQ2hldGFuIEt1bWFyIDxtLmNoZXRhbi5rdW1hckBpbnRlbC5jb20+DQo+IA0KPiBO
b3cgdGhhdCB0aGUgaW5pdGlhbCB3d2FuIGZyYW1ld29yayBzdXBwb3J0IGxhbmRlZCwgY291bGQg
eW91IG1pZ3JhdGUgdG8gaXQNCj4gZm9yIGNyZWF0aW5nIHRoZSBNQklNICdXV0FOIHBvcnQnIGlu
c3RlYWQgb2YgY3JlYXRpbmcgeWV0IGFub3RoZXIgY2hhcg0KPiBkcml2ZXI/IEkgc2VlIHlvdSBp
bnRyb2R1Y2VkIGFuIElPQ1RMIGZvciBwYWNrZXQgc2l6ZSwgSSBzZWUgbm8gb2JqZWN0aW9uIHRv
DQo+IGFkZCB0aGF0IGluIHRoZSB3d2FuIGNvcmUuDQo+IA0KDQpTdXJlLCB3ZSBoYXZlIHN0YXJ0
ZWQgdGhlIG1pZ3JhdGlvbiB0byBNQklNICdXV0FOIHBvcnQnLiBUaGUgbmV4dCB2ZXJzaW9uIG9m
IHBhdGNoDQp3b3VsZCBjb250YWluIHRoZXNlIGFkYXB0YXRpb25zLg0KDQpJZiB3d2FuIGNvcmUg
c3VwcG9ydHMgSU9DVEwgZm9yIHBhY2tldCBzaXplLCB0aGVuIHdlIHNoYWxsIHJlbW92ZSB0aGF0
IHBpZWNlIG9mDQppbXBsZW1lbnRhdGlvbiBpbiBkcml2ZXIgY29kZS4NCg0KUmVnYXJkcw0KQ2hl
dGFuDQo=
