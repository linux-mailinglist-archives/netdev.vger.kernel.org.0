Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1647C4DECF
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 03:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfFUBuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 21:50:44 -0400
Received: from mga04.intel.com ([192.55.52.120]:42035 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbfFUBuo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 21:50:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 18:50:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="359145778"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by fmsmga006.fm.intel.com with ESMTP; 20 Jun 2019 18:50:43 -0700
Received: from orsmsx159.amr.corp.intel.com (10.22.240.24) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 20 Jun 2019 18:50:42 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.135]) by
 ORSMSX159.amr.corp.intel.com ([169.254.11.185]) with mapi id 14.03.0439.000;
 Thu, 20 Jun 2019 18:50:42 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     "Patel, Vedang" <vedang.patel@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "l@dorileo.org" <l@dorileo.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH net-next v3 1/6] igb: clear out tstamp
 after sending the packet.
Thread-Topic: [Intel-wired-lan] [PATCH net-next v3 1/6] igb: clear out
 tstamp after sending the packet.
Thread-Index: AQHVJ9O7k16MTucar0qvpvUYjOZ3Eg==
Date:   Fri, 21 Jun 2019 01:50:42 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B970B1283@ORSMSX103.amr.corp.intel.com>
References: <1560799870-18956-1-git-send-email-vedang.patel@intel.com>
 <1560799870-18956-2-git-send-email-vedang.patel@intel.com>
In-Reply-To: <1560799870-18956-2-git-send-email-vedang.patel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA2LTE3IGF0IDEyOjMxIC0wNzAwLCBWZWRhbmcgUGF0ZWwgd3JvdGU6Cj4g
c2tiLT50c3RhbXAgaXMgYmVpbmcgdXNlZCBhdCBtdWx0aXBsZSBwbGFjZXMuIE9uIHRoZSB0cmFu
c21pdCBzaWRlLCBpdAo+IGlzIHVzZWQgdG8gZGV0ZXJtaW5lIHRoZSBsYXVuY2h0aW1lIG9mIHRo
ZSBwYWNrZXQuIEl0IGlzIGFsc28gdXNlZCB0bwo+IGRldGVybWluZSB0aGUgc29mdHdhcmUgdGlt
ZXN0YW1wIGFmdGVyIHRoZSBwYWNrZXQgaGFzIGJlZW4gdHJhbnNtaXR0ZWQuCj4gCj4gU28sIGNs
ZWFyIG91dCB0aGUgdHN0YW1wIHZhbHVlIGFmdGVyIGl0IGhhcyBiZWVuIHJlYWQgc28gdGhhdCB3
ZSBkbyBub3QKPiByZXBvcnQgZmFsc2Ugc29mdHdhcmUgdGltZXN0YW1wIG9uIHRoZSByZWNlaXZl
IHNpZGUuCj4gCj4gU2lnbmVkLW9mZi1ieTogVmVkYW5nIFBhdGVsIDx2ZWRhbmcucGF0ZWxAaW50
ZWwuY29tPgo+IC0tLQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2IvaWdiX21haW4u
YyB8IDEgKwo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykKPiAKClRlc3RlZC1ieTog
QWFyb24gQnJvd24gPGFhcm9uLmYuYnJvd25AaW50ZWwuY29tPgo=
