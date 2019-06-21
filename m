Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB364DEC5
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 03:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfFUBrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 21:47:52 -0400
Received: from mga04.intel.com ([192.55.52.120]:41947 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfFUBrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 21:47:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 18:47:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="359145176"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by fmsmga006.fm.intel.com with ESMTP; 20 Jun 2019 18:47:51 -0700
Received: from orsmsx154.amr.corp.intel.com (10.22.226.12) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 20 Jun 2019 18:47:51 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.135]) by
 ORSMSX154.amr.corp.intel.com ([169.254.11.187]) with mapi id 14.03.0439.000;
 Thu, 20 Jun 2019 18:47:51 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Artem Bityutskiy <dedekind1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Fujinaka, Todd" <todd.fujinaka@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] net: intel: igb: add RR2DCDELAY to ethtool
 registers dump
Thread-Topic: [PATCH 2/2] net: intel: igb: add RR2DCDELAY to ethtool
 registers dump
Thread-Index: AQHVJ9NVgGkqkqdx+EWP8Pmc6SGThg==
Date:   Fri, 21 Jun 2019 01:47:50 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B970B1271@ORSMSX103.amr.corp.intel.com>
References: <20190618115513.99661-1-dedekind1@gmail.com>
 <20190618115513.99661-2-dedekind1@gmail.com>
In-Reply-To: <20190618115513.99661-2-dedekind1@gmail.com>
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

T24gVHVlLCAyMDE5LTA2LTE4IGF0IDE0OjU1ICswMzAwLCBBcnRlbSBCaXR5dXRza2l5IHdyb3Rl
Ogo+IEZyb206IEFydGVtIEJpdHl1dHNraXkgPGFydGVtLmJpdHl1dHNraXlAbGludXguaW50ZWwu
Y29tPgo+IAo+IFRoaXMgcGF0Y2ggYWRkcyB0aGUgUlIyRENERUxBWSByZWdpc3RlciB0byB0aGUg
ZXRodG9vbCByZWdpc3RlcnMgZHVtcC4KPiBSUjJEQ0RFTEFZIGV4aXN0cyBvbiBJMjEwIGFuZCBJ
MjExIEludGVsIEdpZ2FiaXQgRXRoZXJuZXQgY2hpcHMgYW5kIGl0IHN0YW5kcwo+IGZvciAiUmVh
ZCBSZXF1ZXN0IFRvIERhdGEgQ29tcGxldGlvbiBEZWxheSIuIEhlcmUgaXMgaG93IHRoaXMgcmVn
aXN0ZXIgaXMKPiBkZXNjcmliZWQgaW4gdGhlIEkyMTAgZGF0YXNoZWV0Ogo+IAo+ICJUaGlzIGZp
ZWxkIGNhcHR1cmVzIHRoZSBtYXhpbXVtIFBDSWUgc3BsaXQgdGltZSBpbiAxNiBucyB1bml0cywg
d2hpY2ggaXMgdGhlCj4gbWF4aW11bSBkZWxheSBiZXR3ZWVuIHRoZSByZWFkIHJlcXVlc3QgdG8g
dGhlIGZpcnN0IGRhdGEgY29tcGxldGlvbi4gVGhpcyBpcwo+IGdpdmluZyBhbiBlc3RpbWF0aW9u
IG9mIHRoZSBQQ0llIHJvdW5kIHRyaXAgdGltZS4iCj4gCj4gSW4gb3RoZXIgd29yZHMsIHdoZW5l
dmVyIEkyMTAgcmVhZHMgZnJvbSB0aGUgaG9zdCBtZW1vcnkgKGUuZy4sIGZldGNoZXMgYQo+IGRl
c2NyaXB0b3IgZnJvbSB0aGUgcmluZyksIHRoZSBjaGlwIG1lYXN1cmVzIGV2ZXJ5IFBDSSBETUEg
cmVhZCB0cmFuc2FjdGlvbiBhbmQKPiBjYXB0dXJlcyB0aGUgbWF4aW11bSB2YWx1ZS4gU28gaXQg
ZW5kcyB1cCBjb250YWluaW5nIHRoZSBsb25nZXN0IERNQQo+IHRyYW5zYWN0aW9uIHRpbWUuCj4g
Cj4gVGhpcyByZWdpc3RlciBpcyB2ZXJ5IHVzZWZ1bCBmb3IgdHJvdWJsZXNob290aW5nIGFuZCBy
ZXNlYXJjaCBwdXJwb3Nlcy4gSWYgeW91Cj4gYXJlIGRlYWxpbmcgd2l0aCB0aW1lLXNlbnNpdGl2
ZSBuZXR3b3JrcywgdGhpcyByZWdpc3RlciBjYW4gaGVscCB5b3UgZ2V0Cj4gYW4gaWRlYSBvZiB5
b3VyICJJMjEwLXRvLXJpbmciIGxhdGVuY3kuIFRoaXMgaGVscHMgYW5zd2VyaW5nIHF1ZXN0aW9u
cyBsaWtlCj4gInNob3VsZCBJIGhhdmUgUENJZSBBU1BNIGVuYWJsZWQ/IiBvciAic2hvdWxkIEkg
ZW5hYmxlIGRlZXAgQy1zdGF0ZXM/IiBvbgo+IG15IHN5c3RlbS4KPiAKPiBJdCBpcyBzYWZlIHRv
IHJlYWQgdGhpcyByZWdpc3RlciBhdCBhbnkgcG9pbnQsIHJlYWRpbmcgaXQgaGFzIG5vIGVmZmVj
dCBvbgo+IHRoZSBJMjEwIGNoaXAgZnVuY3Rpb25hbGl0eS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBB
cnRlbSBCaXR5dXRza2l5IDxhcnRlbS5iaXR5dXRza2l5QGxpbnV4LmludGVsLmNvbT4KPiAtLS0K
PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2UxMDAwX3JlZ3MuaCAgfCAyICsrCj4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYi9pZ2JfZXRodG9vbC5jIHwgNSArKysrLQo+
ICAyIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+IAoKVGVz
dGVkLWJ5OiBBYXJvbiBCcm93biA8YWFyb24uZi5icm93bkBpbnRlbC5jb20+Cg==
