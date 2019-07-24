Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5AD3741BE
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbfGXWwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:52:40 -0400
Received: from mga05.intel.com ([192.55.52.43]:53541 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbfGXWwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 18:52:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 15:52:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,304,1559545200"; 
   d="scan'208";a="175028915"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by orsmga006.jf.intel.com with ESMTP; 24 Jul 2019 15:52:39 -0700
Received: from orsmsx155.amr.corp.intel.com (10.22.240.21) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 24 Jul 2019 15:52:39 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.29]) by
 ORSMSX155.amr.corp.intel.com ([169.254.7.34]) with mapi id 14.03.0439.000;
 Wed, 24 Jul 2019 15:52:39 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-wired-lan] [PATCH v2] e1000e: Make speed detection on
 hotplugging cable more reliable
Thread-Topic: [Intel-wired-lan] [PATCH v2] e1000e: Make speed detection on
 hotplugging cable more reliable
Thread-Index: AQHVQnJ+Yzd19bMtS0elY63lZscBog==
Date:   Wed, 24 Jul 2019 22:52:38 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B970D75A2@ORSMSX103.amr.corp.intel.com>
References: <20190715084355.9962-1-kai.heng.feng@canonical.com>
 <20190715122555.11922-1-kai.heng.feng@canonical.com>
In-Reply-To: <20190715122555.11922-1-kai.heng.feng@canonical.com>
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

T24gTW9uLCAyMDE5LTA3LTE1IGF0IDIwOjI1ICswODAwLCBLYWktSGVuZyBGZW5nIHdyb3RlOgo+
IEFmdGVyIGhvdHBsdWdnaW5nIGFuIDFHYnBzIGV0aGVybmV0IGNhYmxlIHdpdGggMUdicHMgbGlu
ayBwYXJ0bmVyLCB0aGUKPiBNSUlfQk1TUiBtYXkgcmVwb3J0IDEwTWJwcywgcmVuZGVycyB0aGUg
bmV0d29yayByYXRoZXIgc2xvdy4KPiAKPiBUaGUgaXNzdWUgaGFzIG11Y2ggbG93ZXIgZmFpbCBy
YXRlIGFmdGVyIGNvbW1pdCA1OTY1M2U2NDk3ZDEgKCJlMTAwMGU6Cj4gTWFrZSB3YXRjaGRvZyB1
c2UgZGVsYXllZCB3b3JrIiksIHdoaWNoIGVzc2VudGlhbGx5IGludHJvZHVjZXMgc29tZQo+IGRl
bGF5IGJlZm9yZSBydW5uaW5nIHRoZSB3YXRjaGRvZyB0YXNrLgo+IAo+IEJ1dCB0aGVyZSdzIHN0
aWxsIGEgY2hhbmNlIHRoYXQgdGhlIGhvdHBsdWdnaW5nIGV2ZW50IGFuZCB0aGUgcXVldWVkCj4g
d2F0Y2hkb2cgdGFzayBnZXRzIHJ1biBhdCB0aGUgc2FtZSB0aW1lLCB0aGVuIHRoZSBvcmlnaW5h
bCBpc3N1ZSBjYW4gYmUKPiBvYnNlcnZlZCBvbmNlIGFnYWluLgo+IAo+IFNvIGxldCdzIHVzZSBt
b2RfZGVsYXllZF93b3JrKCkgdG8gYWRkIGEgZGV0ZXJtaW5pc3RpYyAxIHNlY29uZCBkZWxheQo+
IGJlZm9yZSBydW5uaW5nIHdhdGNoZG9nIHRhc2ssIGFmdGVyIGFuIGludGVycnVwdC4KPiAKPiBT
aWduZWQtb2ZmLWJ5OiBLYWktSGVuZyBGZW5nIDxrYWkuaGVuZy5mZW5nQGNhbm9uaWNhbC5jb20+
Cj4gLS0tCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2UxMDAwZS9uZXRkZXYuYyB8IDEy
ICsrKysrKy0tLS0tLQo+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA2IGRlbGV0
aW9ucygtKQoKVGVzdGVkLWJ5OiBBYXJvbiBCcm93biA8YWFyb24uZi5icm93bkBpbnRlbC5jb20+
Cg==
