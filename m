Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF1B4DEC1
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 03:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbfFUBpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 21:45:24 -0400
Received: from mga17.intel.com ([192.55.52.151]:19633 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfFUBpX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 21:45:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 18:45:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="183269301"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga004.fm.intel.com with ESMTP; 20 Jun 2019 18:45:22 -0700
Received: from orsmsx112.amr.corp.intel.com (10.22.240.13) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 20 Jun 2019 18:45:22 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.135]) by
 ORSMSX112.amr.corp.intel.com ([169.254.3.232]) with mapi id 14.03.0439.000;
 Thu, 20 Jun 2019 18:45:22 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Artem Bityutskiy <dedekind1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Fujinaka, Todd" <todd.fujinaka@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] net: intel: igb: minor ethool regdump amendment
Thread-Topic: [PATCH 1/2] net: intel: igb: minor ethool regdump amendment
Thread-Index: AQHVJ9L8tWjB5B1JmkOwuk4JULmEJA==
Date:   Fri, 21 Jun 2019 01:45:21 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B970B125D@ORSMSX103.amr.corp.intel.com>
References: <20190618115513.99661-1-dedekind1@gmail.com>
In-Reply-To: <20190618115513.99661-1-dedekind1@gmail.com>
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
Y29tPgo+IAo+IFRoaXMgcGF0Y2ggaGFzIG5vIGZ1bmN0aW9uYWwgaW1wYWN0IGFuZCBpdCBpcyBq
dXN0IGEgcHJlcGFyYXRpb24KPiBmb3IgdGhlIGZvbGxvd2luZyBwYXRjaC4gSXQgcmVtb3ZlcyBh
biBlYXJseSByZXR1cm4gZnJvbSB0aGUKPiAnaWdiX2dldF9yZWdzKCknIGZ1bmN0aW9uIGJ5IG1v
dmluZyB0aGUgODI1NzYtb25seSByZWdpc3RlcnMKPiBkdW1wIGludG8gYW4gImlmIiBibG9jay4g
V2l0aCB0aGlzIHByZXBhcmF0aW9uLCB3ZSBjYW4gZHVtcCBtb3JlCj4gbm9uLTgyNTc2IHJlZ2lz
dGVycyBhdCB0aGUgZW5kIG9mIHRoaXMgZnVuY3Rpb24uCj4gCj4gU2lnbmVkLW9mZi1ieTogQXJ0
ZW0gQml0eXV0c2tpeSA8YXJ0ZW0uYml0eXV0c2tpeUBsaW51eC5pbnRlbC5jb20+Cj4gLS0tCj4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYi9pZ2JfZXRodG9vbC5jIHwgNzAgKysrKysr
KysrKy0tLS0tLS0tLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDM1IGluc2VydGlvbnMoKyksIDM1IGRl
bGV0aW9ucygtKQo+IApBc2lkZSBmcm9tIHRlaCBtaXNzaW5nICJ0IiBmb3IgZXRodG9vbCBpbiB0
aGUgc3ViamVjdCB0aGF0IEFuZHJldyBMdW5uIHBvaW50ZWQgb3V0Li4uCgpUZXN0ZWQtYnk6IEFh
cm9uIEJyb3duIDxhYXJvbi5mLmJyb3duQGludGVsLmNvbT4K
