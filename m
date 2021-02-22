Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3341E321A6E
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 15:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhBVOei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 09:34:38 -0500
Received: from mga18.intel.com ([134.134.136.126]:12735 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231166AbhBVOdb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 09:33:31 -0500
IronPort-SDR: DIcTKC4v2J5R089v2PgW+iWMeTrUUETwGwdKw+pBIBEoZXAyGzlKWaz78ieh+qZCAaQm3A1IpR
 ypztg6uUYWOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9902"; a="172119165"
X-IronPort-AV: E=Sophos;i="5.81,197,1610438400"; 
   d="scan'208";a="172119165"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 06:30:01 -0800
IronPort-SDR: UkUjvYSpMKL1rXVBdewB8SBNe5WvepTpSh4246t4Xdy6AE4eWyZn7/EAphsi75EeVDrmjPfRFe
 ttsuQdvTIEtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,197,1610438400"; 
   d="scan'208";a="592672094"
Received: from irsmsx606.ger.corp.intel.com ([163.33.146.139])
  by fmsmga006.fm.intel.com with ESMTP; 22 Feb 2021 06:30:00 -0800
Received: from irsmsx604.ger.corp.intel.com (163.33.146.137) by
 IRSMSX606.ger.corp.intel.com (163.33.146.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 22 Feb 2021 14:29:59 +0000
Received: from irsmsx604.ger.corp.intel.com ([163.33.146.137]) by
 IRSMSX604.ger.corp.intel.com ([163.33.146.137]) with mapi id 15.01.2106.002;
 Mon, 22 Feb 2021 14:29:59 +0000
From:   "Loftus, Ciara" <ciara.loftus@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Janjua, Weqaar A" <weqaar.a.janjua@intel.com>
Subject: RE: [PATCH bpf-next 2/4] selftests/bpf: expose debug arg to shell
 script for xsk tests
Thread-Topic: [PATCH bpf-next 2/4] selftests/bpf: expose debug arg to shell
 script for xsk tests
Thread-Index: AQHXBUqRfSBtw5zmgka4lNy3B6X5Q6pfdyOAgATLqvA=
Date:   Mon, 22 Feb 2021 14:29:59 +0000
Message-ID: <6695a6275b504b4b9acc5f952a123ea0@intel.com>
References: <20210217160214.7869-1-ciara.loftus@intel.com>
 <20210217160214.7869-3-ciara.loftus@intel.com>
 <CAJ8uoz0CnquDSRZDRAYhLu=y8m-_Dzqs-J0d+-NSJk73wxfh4Q@mail.gmail.com>
In-Reply-To: <CAJ8uoz0CnquDSRZDRAYhLu=y8m-_Dzqs-J0d+-NSJk73wxfh4Q@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [163.33.253.164]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gT24gV2VkLCBGZWIgMTcsIDIwMjEgYXQgNTozNiBQTSBDaWFyYSBMb2Z0dXMgPGNpYXJh
LmxvZnR1c0BpbnRlbC5jb20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gTGF1bmNoaW5nIHhkcHhjZWl2
ZXIgd2l0aCAtRCBlbmFibGVzIGRlYnVnIG1vZGUuIE1ha2UgaXQgcG9zc2libGUNCj4gDQo+IFdv
dWxkIGJlIGNsZWFyZXIgaWYgdGhlIG9wdGlvbiB3YXMgdGhlIHNhbWUgYm90aCBpbiB0aGUgc2hl
bGwgYW5kIGluDQo+IHRoZSB4ZHByZWNlaXZlciBhcHAsIHNvIHBsZWFzZSBwaWNrIC1kIG9yIC1E
IGFuZCBzdGljayB3aXRoIGl0LiBBbmQNCj4gaG93IGFib3V0IGNhbGxpbmcgdGhlIG1vZGUgImR1
bXAgcGFja2V0cyIgaW5zdGVhZCBvZiBkZWJ1ZywgYmVjYXVzZQ0KPiB0aGF0IGlzIHdoYXQgaXQg
aXMgZG9pbmcgcmlnaHQgbm93Pw0KDQorMS4gV2lsbCBzdGljayB3aXRoIC1EIHRvIGJlIGNvbnNp
c3RlbnQgd2l0aCB0aGUgY3VycmVudCBpbnRlcmZhY2UuDQpXaWxsIG1ha2UgdGhlIGxvbmcgb3B0
ICctLWR1bXBfcGt0cycuDQoNClRoYW5rcywNCkNpYXJhDQoNCj4gDQo+ID4gdG8gcGFzcyB0aGlz
IGZsYWcgdG8gdGhlIGFwcCB2aWEgdGhlIHRlc3RfeHNrLnNoIHNoZWxsIHNjcmlwdCBsaWtlDQo+
ID4gc286DQo+ID4NCj4gPiAuL3Rlc3RfeHNrLnNoIC1kDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBDaWFyYSBMb2Z0dXMgPGNpYXJhLmxvZnR1c0BpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIHRv
b2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X3hzay5zaCAgICB8IDcgKysrKysrLQ0KPiA+
ICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYveHNrX3ByZXJlcXMuc2ggfCAzICsrLQ0KPiA+
ICAyIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0K
PiA+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF94c2suc2gN
Cj4gYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF94c2suc2gNCj4gPiBpbmRleCA5
MTEyN2E1YmU5MGQuLmE3MmY4ZWQyOTMyZCAxMDA3NTUNCj4gPiAtLS0gYS90b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9icGYvdGVzdF94c2suc2gNCj4gPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0
ZXN0cy9icGYvdGVzdF94c2suc2gNCj4gPiBAQCAtNzQsMTEgKzc0LDEyIEBADQo+ID4NCj4gPiAg
LiB4c2tfcHJlcmVxcy5zaA0KPiA+DQo+ID4gLXdoaWxlIGdldG9wdHMgImN2IiBmbGFnDQo+ID4g
K3doaWxlIGdldG9wdHMgImN2ZCIgZmxhZw0KPiA+ICBkbw0KPiA+ICAgICAgICAgY2FzZSAiJHtm
bGFnfSIgaW4NCj4gPiAgICAgICAgICAgICAgICAgYykgY29sb3Jjb25zb2xlPTE7Ow0KPiA+ICAg
ICAgICAgICAgICAgICB2KSB2ZXJib3NlPTE7Ow0KPiA+ICsgICAgICAgICAgICAgICBkKSBkZWJ1
Zz0xOzsNCj4gPiAgICAgICAgIGVzYWMNCj4gPiAgZG9uZQ0KPiA+DQo+ID4gQEAgLTEzNSw2ICsx
MzYsMTAgQEAgaWYgW1sgJHZlcmJvc2UgLWVxIDEgXV07IHRoZW4NCj4gPiAgICAgICAgIFZFUkJP
U0VfQVJHPSItdiINCj4gPiAgZmkNCj4gPg0KPiA+ICtpZiBbWyAkZGVidWcgLWVxIDEgXV07IHRo
ZW4NCj4gPiArICAgICAgIERFQlVHX0FSRz0iLUQiDQo+ID4gK2ZpDQo+ID4gKw0KPiA+ICB0ZXN0
X3N0YXR1cyAkcmV0dmFsICIke1RFU1RfTkFNRX0iDQo+ID4NCj4gPiAgIyMgU1RBUlQgVEVTVFMN
Cj4gPiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3hza19wcmVyZXFz
LnNoDQo+IGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3hza19wcmVyZXFzLnNoDQo+ID4g
aW5kZXggZWY4YzViMzFmNGI2Li5kOTUwMTgwNTFmY2MgMTAwNzU1DQo+ID4gLS0tIGEvdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMvYnBmL3hza19wcmVyZXFzLnNoDQo+ID4gKysrIGIvdG9vbHMvdGVz
dGluZy9zZWxmdGVzdHMvYnBmL3hza19wcmVyZXFzLnNoDQo+ID4gQEAgLTEyOCw1ICsxMjgsNiBA
QCBleGVjeGRweGNlaXZlcigpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgY29weVskaW5k
ZXhdPSR7IWN1cnJlbnR9DQo+ID4gICAgICAgICAgICAgICAgIGRvbmUNCj4gPg0KPiA+IC0gICAg
ICAgLi8ke1hTS09CSn0gLWkgJHtWRVRIMH0gLWkgJHtWRVRIMX0sJHtOUzF9ICR7Y29weVsqXX0g
LUMgJHtOVU1QS1RTfQ0KPiAke1ZFUkJPU0VfQVJHfQ0KPiA+ICsgICAgICAgLi8ke1hTS09CSn0g
LWkgJHtWRVRIMH0gLWkgJHtWRVRIMX0sJHtOUzF9ICR7Y29weVsqXX0gLUMgJHtOVU1QS1RTfQ0K
PiAke1ZFUkJPU0VfQVJHfSBcDQo+ID4gKyAgICAgICAgICAgICAgICR7REVCVUdfQVJHfQ0KPiA+
ICB9DQo+ID4gLS0NCj4gPiAyLjE3LjENCj4gPg0K
