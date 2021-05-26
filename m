Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7A439220E
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 23:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbhEZVbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 17:31:22 -0400
Received: from mga18.intel.com ([134.134.136.126]:43572 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232250AbhEZVbV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 17:31:21 -0400
IronPort-SDR: UvtgcdIhybZp3CTrjBfkn+acpD0+IKC2qSt72/SDK9/BMjZqvFil9wY8XG+i/pOzYgeaZHSgwy
 N7XVk7724tpg==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="189958947"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="189958947"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 14:29:49 -0700
IronPort-SDR: 9sumek9bf37/34v+u0U4qT3XPM79BlekVcQ5p5Z7wUrxgenrdJf5z795RJ/8WVhNvbs969ElOv
 A9LF6VZtNWmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="436287853"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 26 May 2021 14:29:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 26 May 2021 14:29:48 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 26 May 2021 14:29:47 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2242.008;
 Wed, 26 May 2021 14:29:47 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Latif, Faisal" <faisal.latif@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH][next] i40e: Replace one-element array with flexible-array
 member
Thread-Topic: [PATCH][next] i40e: Replace one-element array with
 flexible-array member
Thread-Index: AQHXUbmnzar0Q0wWCEa4qeRHOhKPAqr2Rt4Q
Date:   Wed, 26 May 2021 21:29:47 +0000
Message-ID: <bf46b428deef4e9e89b0ea1704b1f0e5@intel.com>
References: <20210525230038.GA175516@embeddedor>
In-Reply-To: <20210525230038.GA175516@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBbUEFUQ0hdW25leHRdIGk0MGU6IFJlcGxhY2Ugb25lLWVsZW1lbnQgYXJyYXkg
d2l0aCBmbGV4aWJsZS1hcnJheSBtZW1iZXINCj4gDQo+IFRoZXJlIGlzIGEgcmVndWxhciBuZWVk
IGluIHRoZSBrZXJuZWwgdG8gcHJvdmlkZSBhIHdheSB0byBkZWNsYXJlIGhhdmluZyBhDQo+IGR5
bmFtaWNhbGx5IHNpemVkIHNldCBvZiB0cmFpbGluZyBlbGVtZW50cyBpbiBhIHN0cnVjdHVyZS4g
S2VybmVsIGNvZGUgc2hvdWxkIGFsd2F5cw0KPiB1c2Ug4oCcZmxleGlibGUgYXJyYXkgbWVtYmVy
c+KAnVsxXSBmb3IgdGhlc2UgY2FzZXMuIFRoZSBvbGRlciBzdHlsZSBvZiBvbmUtZWxlbWVudCBv
cg0KPiB6ZXJvLWxlbmd0aCBhcnJheXMgc2hvdWxkIG5vIGxvbmdlciBiZSB1c2VkWzJdLg0KPiAN
Cj4gUmVmYWN0b3IgdGhlIGNvZGUgYWNjb3JkaW5nIHRvIHRoZSB1c2Ugb2YgYSBmbGV4aWJsZS1h
cnJheSBtZW1iZXIgaW4gc3RydWN0DQo+IGk0MGVfcXZsaXN0X2luZm8gaW5zdGVhZCBvZiBvbmUt
ZWxlbWVudCBhcnJheSwgYW5kIHVzZSB0aGUgc3RydWN0X3NpemUoKSBoZWxwZXIuDQo+IA0KPiBb
MV0gaHR0cHM6Ly9lbi53aWtpcGVkaWEub3JnL3dpa2kvRmxleGlibGVfYXJyYXlfbWVtYmVyDQo+
IFsyXSBodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9odG1sL3Y1LjEwL3Byb2Nlc3MvZGVwcmVj
YXRlZC5odG1sI3plcm8tbGVuZ3RoLQ0KPiBhbmQtb25lLWVsZW1lbnQtYXJyYXlzDQo+IA0KPiBM
aW5rOiBodHRwczovL2dpdGh1Yi5jb20vS1NQUC9saW51eC9pc3N1ZXMvNzkNCj4gU2lnbmVkLW9m
Zi1ieTogR3VzdGF2byBBLiBSLiBTaWx2YSA8Z3VzdGF2b2Fyc0BrZXJuZWwub3JnPg0KDQpUaGlz
IGxvb2tzIG9rIHRvIG1lLg0KQWNrZWQtYnk6IFNoaXJheiBTYWxlZW0gPHNoaXJhei5zYWxlZW1A
aW50ZWwuY29tPg0KDQpJdCBzZWVtcyB3ZSBzaG91bGQgYWRkIHRoaXMgdG8gdGhlIG5ldyBpcmRt
YSBkcml2ZXIgc3VibWlzc2lvbiBhcyB3ZWxsIHdoaWNoIHJlcGxhY2VzIGk0MGl3Lg0KSSB3aWxs
IGZvbGQgaXQgaW50byB2NyBvZiB0aGUgcmRtYSBwb3J0aW9uIG9mIHRoZSBzZXJpZXMNCmh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXJkbWEvMjAyMTA1MjAyMDAzMjYuR1gxMDk2OTQwQHpp
ZXBlLmNhLw0KDQpBZGRpdGlvbmFsbHkgd2Ugd2lsbCBhZGQgdGhpcyBwYXRjaCB3aGVuIHdlIHJl
c2VuZCB0aGlzIFBSIG9uIGl3bC1uZXh0Lg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgt
cmRtYS82MjU1NWM2ZGU2NDFlMTBjYjQxNjk2NTM3MzEzODlhNTFkMDg2MzQ1LmNhbWVsQGludGVs
LmNvbS8NCg0KDQo+IC0tLQ0KPiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L2k0MGl3L2k0MGl3X21h
aW4uYyAgICAgIHwgNSArKy0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9p
NDBlX2NsaWVudC5jIHwgMiArLQ0KPiAgaW5jbHVkZS9saW51eC9uZXQvaW50ZWwvaTQwZV9jbGll
bnQuaCAgICAgICAgIHwgMiArLQ0KPiAgMyBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyks
IDUgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3
L2k0MGl3L2k0MGl3X21haW4uYw0KPiBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9pNDBpdy9pNDBp
d19tYWluLmMNCj4gaW5kZXggYjQ5NmYzMGNlMDY2Li4zNjRmNjljZDYyMGYgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9pNDBpdy9pNDBpd19tYWluLmMNCj4gKysrIGIvZHJp
dmVycy9pbmZpbmliYW5kL2h3L2k0MGl3L2k0MGl3X21haW4uYw0KPiBAQCAtMTQyMyw3ICsxNDIz
LDcgQEAgc3RhdGljIGVudW0gaTQwaXdfc3RhdHVzX2NvZGUNCj4gaTQwaXdfc2F2ZV9tc2l4X2lu
Zm8oc3RydWN0IGk0MGl3X2RldmljZSAqaXdkZXYsDQo+ICAJc3RydWN0IGk0MGVfcXZfaW5mbyAq
aXdfcXZpbmZvOw0KPiAgCXUzMiBjZXFfaWR4Ow0KPiAgCXUzMiBpOw0KPiAtCXUzMiBzaXplOw0K
PiArCXNpemVfdCBzaXplOw0KPiANCj4gIAlpZiAoIWxkZXYtPm1zaXhfY291bnQpIHsNCj4gIAkJ
aTQwaXdfcHJfZXJyKCJObyBNU0ktWCB2ZWN0b3JzXG4iKTsNCj4gQEAgLTE0MzMsOCArMTQzMyw3
IEBAIHN0YXRpYyBlbnVtIGk0MGl3X3N0YXR1c19jb2RlDQo+IGk0MGl3X3NhdmVfbXNpeF9pbmZv
KHN0cnVjdCBpNDBpd19kZXZpY2UgKml3ZGV2LA0KPiAgCWl3ZGV2LT5tc2l4X2NvdW50ID0gbGRl
di0+bXNpeF9jb3VudDsNCj4gDQo+ICAJc2l6ZSA9IHNpemVvZihzdHJ1Y3QgaTQwaXdfbXNpeF92
ZWN0b3IpICogaXdkZXYtPm1zaXhfY291bnQ7DQo+IC0Jc2l6ZSArPSBzaXplb2Yoc3RydWN0IGk0
MGVfcXZsaXN0X2luZm8pOw0KPiAtCXNpemUgKz0gIHNpemVvZihzdHJ1Y3QgaTQwZV9xdl9pbmZv
KSAqIGl3ZGV2LT5tc2l4X2NvdW50IC0gMTsNCj4gKwlzaXplICs9IHN0cnVjdF9zaXplKGl3X3F2
bGlzdCwgcXZfaW5mbywgaXdkZXYtPm1zaXhfY291bnQpOw0KPiAgCWl3ZGV2LT5pd19tc2l4dGJs
ID0ga3phbGxvYyhzaXplLCBHRlBfS0VSTkVMKTsNCj4gDQo+ICAJaWYgKCFpd2Rldi0+aXdfbXNp
eHRibCkNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQw
ZV9jbGllbnQuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV9jbGll
bnQuYw0KPiBpbmRleCAzMmYzZmFjYmVkMWEuLjYzZWFiMTRhMjZkZiAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX2NsaWVudC5jDQo+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV9jbGllbnQuYw0KPiBAQCAtNTc5LDcg
KzU3OSw3IEBAIHN0YXRpYyBpbnQgaTQwZV9jbGllbnRfc2V0dXBfcXZsaXN0KHN0cnVjdCBpNDBl
X2luZm8gKmxkZXYsDQo+ICAJdTMyIHZfaWR4LCBpLCByZWdfaWR4LCByZWc7DQo+IA0KPiAgCWxk
ZXYtPnF2bGlzdF9pbmZvID0ga3phbGxvYyhzdHJ1Y3Rfc2l6ZShsZGV2LT5xdmxpc3RfaW5mbywg
cXZfaW5mbywNCj4gLQkJCQkgICAgcXZsaXN0X2luZm8tPm51bV92ZWN0b3JzIC0gMSksIEdGUF9L
RVJORUwpOw0KPiArCQkJCSAgICBxdmxpc3RfaW5mby0+bnVtX3ZlY3RvcnMpLCBHRlBfS0VSTkVM
KTsNCj4gIAlpZiAoIWxkZXYtPnF2bGlzdF9pbmZvKQ0KPiAgCQlyZXR1cm4gLUVOT01FTTsNCj4g
IAlsZGV2LT5xdmxpc3RfaW5mby0+bnVtX3ZlY3RvcnMgPSBxdmxpc3RfaW5mby0+bnVtX3ZlY3Rv
cnM7IGRpZmYgLS1naXQNCj4gYS9pbmNsdWRlL2xpbnV4L25ldC9pbnRlbC9pNDBlX2NsaWVudC5o
IGIvaW5jbHVkZS9saW51eC9uZXQvaW50ZWwvaTQwZV9jbGllbnQuaA0KPiBpbmRleCBmNDEzODdh
ODk2OWYuLmZkN2JjODYwYTI0MSAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9uZXQvaW50
ZWwvaTQwZV9jbGllbnQuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L25ldC9pbnRlbC9pNDBlX2Ns
aWVudC5oDQo+IEBAIC00OCw3ICs0OCw3IEBAIHN0cnVjdCBpNDBlX3F2X2luZm8gew0KPiANCj4g
IHN0cnVjdCBpNDBlX3F2bGlzdF9pbmZvIHsNCj4gIAl1MzIgbnVtX3ZlY3RvcnM7DQo+IC0Jc3Ry
dWN0IGk0MGVfcXZfaW5mbyBxdl9pbmZvWzFdOw0KPiArCXN0cnVjdCBpNDBlX3F2X2luZm8gcXZf
aW5mb1tdOw0KPiAgfTsNCj4gDQo+IA0KPiAtLQ0KPiAyLjI3LjANCg0K
