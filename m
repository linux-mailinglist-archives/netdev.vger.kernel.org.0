Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDF4399B33
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 09:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhFCHEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:04:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:8426 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhFCHD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 03:03:59 -0400
IronPort-SDR: 1Cr0q/wBcoSZDg6h2swDDf++UjWXXfQMDQ0bz5hbySN4agWVPeI/CO86eWprLZ3bhLm+ehZqId
 C0QuMmE1L2+A==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="204010079"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="204010079"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 00:02:15 -0700
IronPort-SDR: sLtaOMwH7jxXOvRL51/Bl8Z+rZ4U4JNgws6DYMv07bL2cZ6l0fqGu9jtvKfpcDi8BL9scLnwkv
 X4mECOdkog6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="480058408"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga001.jf.intel.com with ESMTP; 03 Jun 2021 00:02:14 -0700
Received: from bgsmsx604.gar.corp.intel.com (10.67.234.6) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 00:02:14 -0700
Received: from bgsmsx606.gar.corp.intel.com (10.67.234.8) by
 BGSMSX604.gar.corp.intel.com (10.67.234.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 12:32:11 +0530
Received: from bgsmsx606.gar.corp.intel.com ([10.67.234.8]) by
 BGSMSX606.gar.corp.intel.com ([10.67.234.8]) with mapi id 15.01.2242.008;
 Thu, 3 Jun 2021 12:32:11 +0530
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Subject: RE: [RFC 3/4] wwan: add interface creation support
Thread-Topic: [RFC 3/4] wwan: add interface creation support
Thread-Index: AQHXVrzwth9rAeMT/EurfkJKf4HZ/qr+ieMAgABsYf6AAPfWgIAAd1ZlgAEdJoCAAFr+8A==
Date:   Thu, 3 Jun 2021 07:02:11 +0000
Message-ID: <bdc4713c82b64ad9a6e9690ab8f2ad20@intel.com>
References: <20210601080538.71036-1-johannes@sipsolutions.net>
 <20210601100320.7d39e9c33a18.I0474861dad426152ac7e7afddfd7fe3ce70870e4@changeid>
 <CAMZdPi-ZaH8WWKfhfKzy0OKpUtNAiCUfekh9R1de5awFP-ed=A@mail.gmail.com>
 <0555025c6d7a88f4f3dcdd6704612ed8ba33b175.camel@sipsolutions.net>
 <CAMZdPi8Ca3YRaVWGL6Fjd7yfowQcX2V2RYNDNm-2kQdEZ-Z1Bw@mail.gmail.com>
 <17fd0311eb8b51e6d23fce8b7eb23e3d2581cf54.camel@sipsolutions.net>
 <CAMZdPi8RQ7580nTLHf+GYavU3CTME76P86haB8VCdVjXxrgqLA@mail.gmail.com>
In-Reply-To: <CAMZdPi8RQ7580nTLHf+GYavU3CTME76P86haB8VCdVjXxrgqLA@mail.gmail.com>
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

SGkgTG9pYywNCg0KPiA+ID4gT0sgbm8gcHJvYiA7LSksIGFyZSB5b3UgZ29pbmcgdG8gcmVzdWJt
aXQgc29tZXRoaW5nIG9yIGRvIHlvdSB3YW50IEkNCj4gPiA+IHRha2UgY2FyZSBvZiB0aGlzPw0K
PiA+DQo+ID4gSSBqdXN0IHJlc3B1biBhIHYyLCBidXQgSSdtIHN0aWxsIG5vdCBhYmxlIHRvIHRl
c3QgYW55IG9mIHRoaXMgKEknbSBpbg0KPiA+IGEgY29tcGxldGVseSBkaWZmZXJlbnQgZ3JvdXAg
dGhhbiBDaGV0YW4sIGp1c3QgaGF2ZSBiZWVuDQo+ID4gaGVscGluZy9hZHZpc2luZyB0aGVtLCBz
byBJIGRvbid0IGV2ZW4gaGF2ZSB0aGVpciBIVykuDQo+ID4NCj4gPiBTbyBpZiB5b3Ugd2FudCB0
byB0YWtlIG92ZXIgYXQgc29tZSBwb2ludCBhbmQgYXJlIGFibGUgdG8gdGVzdCBpdCwgSSdkDQo+
ID4gbXVjaCBhcHByZWNpYXRlIGl0Lg0KPiANCj4gVGhhbmtzIGZvciB0aGlzIHdvcmssIHllcyBJ
IGNhbiB0cnkgdGVzdGluZyB0aGlzIHdpdGggbWhpX25ldC4NCj4gDQo+IENoZXRhbiwgd291bGQg
eW91IGJlIGFibGUgdG8gdGVzdCB0aGF0IGFzIHdlbGw/IGJhc2ljYWxseSB3aXRoIHRoZSB0d28g
a2VybmVsDQo+IHNlcmllcyAoSm9oYW5uZXMsIFNlcmdleSkgYXBwbGllZCBvbiB0b3Agb2YgeW91
ciBJT1NNIG9uZSArIHRoZQ0KPiBpcHJvdXRlMiBjaGFuZ2VzIGZvciB0aGUgdXNlcnNwYWNlIHNp
ZGUgKFNlcmdleSksIHRoYXQgc2hvdWxkIHdvcmssIGJ1dCBsZXQgdXMNCj4ga25vdyBpZiBhbnkg
aXNzdWVzLg0KDQpTdXJlLiBJIHdpbGwgdGVzdCB0aGVzZSBjaGFuZ2VzIHdpdGggdGhlIGhhcmR3
YXJlIGFuZCBzaGFyZSBteSBvYnNlcnZhdGlvbi4NCg0KUmVnYXJkcywNCkNoZXRhbg0K
