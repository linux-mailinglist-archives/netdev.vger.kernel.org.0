Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3350C39F227
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 11:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhFHJUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 05:20:21 -0400
Received: from mga05.intel.com ([192.55.52.43]:8030 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhFHJUU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 05:20:20 -0400
IronPort-SDR: D8CL9iELD7eLey0TOuZNJKW/8rdvmjeFPLrLQkEzGlSP+0wFEmRnRtJdihwLFzgzL082BfbFfG
 TdevDM56AiDA==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="290436438"
X-IronPort-AV: E=Sophos;i="5.83,257,1616482800"; 
   d="scan'208";a="290436438"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 02:18:27 -0700
IronPort-SDR: GDajdC8MJhvk5wqTu6SLmz4ZAXVzZLyf/WW27BtheqsWurerVi15umKsRwKk5BCwS6RZgoQqzH
 dQCXFxN/d2/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,257,1616482800"; 
   d="scan'208";a="401914262"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 08 Jun 2021 02:18:27 -0700
Received: from bgsmsx605.gar.corp.intel.com (10.67.234.7) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 8 Jun 2021 02:18:26 -0700
Received: from bgsmsx606.gar.corp.intel.com (10.67.234.8) by
 BGSMSX605.gar.corp.intel.com (10.67.234.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 8 Jun 2021 14:48:24 +0530
Received: from bgsmsx606.gar.corp.intel.com ([10.67.234.8]) by
 BGSMSX606.gar.corp.intel.com ([10.67.234.8]) with mapi id 15.01.2242.008;
 Tue, 8 Jun 2021 14:48:24 +0530
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Dan Williams <dcbw@redhat.com>
Subject: RE: WWAN rtnetlink follow-up
Thread-Topic: WWAN rtnetlink follow-up
Thread-Index: AQHXWSsAhfL5kcLBvUuJnYp5dxwMPasJ1rlw
Date:   Tue, 8 Jun 2021 09:18:24 +0000
Message-ID: <832997cdbd3a4f4bb87978d26d3e5ca5@intel.com>
References: <CAMZdPi-MrOAfLu6SaxdEqrZyUM=pyq7U8=dokmxdB+6-C3W3aA@mail.gmail.com>
In-Reply-To: <CAMZdPi-MrOAfLu6SaxdEqrZyUM=pyq7U8=dokmxdB+6-C3W3aA@mail.gmail.com>
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

SGkgTG9pYywNCiANCj4gVGhhbmtzIGZvciB5b3VyIGludm9sdmVtZW50IGFuZCBncmVhdCB3b3Jr
IG9uIHRoaXMgV1dBTiB0b3BpYy4gSSd2ZSBwaWNrZWQNCj4geW91ciBwYXRjaGVzIGluIG15IHRy
ZWUgZm9yIHRlc3RpbmcgKHdpdGggYSBRdWFsY29tbSBNSEkNCj4gbW9kZW0pOg0KPiBodHRwczov
L2dpdC5saW5hcm8ub3JnL3Blb3BsZS9sb2ljLnBvdWxhaW4vbGludXguZ2l0L2xvZy8/aD13d2Fu
LWRldg0KPiANCj4gVGhpcyBpcyBtaW5pbWFsIHN1cHBvcnQgZm9yIG5vdyBzaW5jZSBtaGlfbmV0
IG9ubHkgc3VwcG9ydHMgb25lIGxpbmssDQo+IEVzc2VudGlhbGx5IGZvciB0ZXN0aW5nIHB1cnBv
c2VzLCBidXQgSSBwbGFuIHRvIHJld29yayBpdCB0byBzdXBwb3J0IG1vcmUgdGhhbg0KPiBvbmUg
b25jZSB3d2FuIHJ0bmV0bGluayBpcyBhY2NlcHRlZCBhbmQgbWVyZ2VkLCBUaGlzIGxpbWl0YXRp
b24gd2lsbCBub3QNCj4gZXhpc3QgZm9yIHRoZSBJbnRlbCBJT1NNIGRyaXZlci4NCj4gDQo+IEkn
bSBwcm9iYWJseSBnb2luZyB0byByZWJhc2UgdGhhdCBhbmQgc3F1YXNoIHRoZSBmaXggY29tbWl0
cyAoZnJvbSBTZXJnZXkNCj4gYW5kIEkpIHRvIEpvaGFubmVzIGNoYW5nZXMgaWYgZXZlcnlvbmUg
YWdyZWVzLiBUaGVuIEknbGwgc3VibWl0IHRoZSBlbnRpcmUNCj4gc2VyaWVzLg0KDQpDb3VsZCB5
b3UgcGxlYXNlIHRlbGwgdXMgd2hlbiB5b3UgaW50ZW5kIHRvIHJlcG9zdCBwYXRjaCBzZXJpZXMg
Pw0KDQpSZWdhcmRzLA0KQ2hldGFuDQo=
