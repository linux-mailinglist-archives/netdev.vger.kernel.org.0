Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 632E7B293F
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 03:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388357AbfINBPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 21:15:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:8582 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730673AbfINBPl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 21:15:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Sep 2019 18:15:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,503,1559545200"; 
   d="scan'208";a="185279529"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by fmsmga008.fm.intel.com with ESMTP; 13 Sep 2019 18:15:40 -0700
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 13 Sep 2019 18:15:39 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.221]) by
 ORSMSX151.amr.corp.intel.com ([169.254.7.201]) with mapi id 14.03.0439.000;
 Fri, 13 Sep 2019 18:15:39 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Wenwen Wang <wenwen@cs.uga.edu>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] e1000: fix memory leaks
Thread-Topic: [PATCH] e1000: fix memory leaks
Thread-Index: AQHVapnrDYrnlrBttEqplt4FS5pEXg==
Date:   Sat, 14 Sep 2019 01:15:38 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B971184F9@ORSMSX103.amr.corp.intel.com>
References: <1565589561-5910-1-git-send-email-wenwen@cs.uga.edu>
In-Reply-To: <1565589561-5910-1-git-send-email-wenwen@cs.uga.edu>
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

T24gTW9uLCAyMDE5LTA4LTEyIGF0IDAwOjU5IC0wNTAwLCBXZW53ZW4gV2FuZyB3cm90ZToKPiBJ
biBlMTAwMF9zZXRfcmluZ3BhcmFtKCksICd0eF9vbGQnIGFuZCAncnhfb2xkJyBhcmUgbm90IGRl
YWxsb2NhdGVkIGlmCj4gZTEwMDBfdXAoKSBmYWlscywgbGVhZGluZyB0byBtZW1vcnkgbGVha3Mu
IFJlZmFjdG9yIHRoZSBjb2RlIHRvIGZpeCB0aGlzCj4gaXNzdWUuCj4gCj4gU2lnbmVkLW9mZi1i
eTogV2Vud2VuIFdhbmcgPHdlbndlbkBjcy51Z2EuZWR1Pgo+IC0tLQo+ICBkcml2ZXJzL25ldC9l
dGhlcm5ldC9pbnRlbC9lMTAwMC9lMTAwMF9ldGh0b29sLmMgfCA3ICsrKy0tLS0KPiAgMSBmaWxl
IGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKClRlc3RlZC1ieTogQWFy
b24gQnJvd24gPGFhcm9uLmYuYnJvd25AaW50ZWwuY29tPgo=
