Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32F4A3807D
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfFFWWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:22:31 -0400
Received: from mga03.intel.com ([134.134.136.65]:65395 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbfFFWWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 18:22:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 15:22:30 -0700
X-ExtLoop1: 1
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga004.fm.intel.com with ESMTP; 06 Jun 2019 15:22:30 -0700
Received: from orsmsx156.amr.corp.intel.com (10.22.240.22) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 6 Jun 2019 15:22:29 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.229]) by
 ORSMSX156.amr.corp.intel.com ([169.254.8.64]) with mapi id 14.03.0415.000;
 Thu, 6 Jun 2019 15:22:29 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>
Subject: Re: [PATCH iproute2 net-next v1 3/6] taprio: Add support for
 enabling offload mode
Thread-Topic: [PATCH iproute2 net-next v1 3/6] taprio: Add support for
 enabling offload mode
Thread-Index: AQHVHJCoV3T3WxPxBkGvdj/9wljud6aPfImAgAAZJoCAAAktAIAACgEA
Date:   Thu, 6 Jun 2019 22:22:29 +0000
Message-ID: <3A6C406E-7CD2-49D3-B019-EEC0BF766B37@intel.com>
References: <1559843541-12695-1-git-send-email-vedang.patel@intel.com>
 <1559843541-12695-3-git-send-email-vedang.patel@intel.com>
 <20190606124349.653454ab@hermes.lan>
 <E3C41041-64E5-4C95-9057-1F2A0E6ECEAC@intel.com>
 <20190606144640.1611428d@hermes.lan>
In-Reply-To: <20190606144640.1611428d@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.182]
Content-Type: text/plain; charset="utf-8"
Content-ID: <98B0EF13FBC53749B940B31B04D84007@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gSnVuIDYsIDIwMTksIGF0IDI6NDYgUE0sIFN0ZXBoZW4gSGVtbWluZ2VyIDxzdGVw
aGVuQG5ldHdvcmtwbHVtYmVyLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBUaHUsIDYgSnVuIDIwMTkg
MjE6MTM6NTAgKzAwMDANCj4gIlBhdGVsLCBWZWRhbmciIDx2ZWRhbmcucGF0ZWxAaW50ZWwuY29t
PiB3cm90ZToNCj4gDQo+Pj4gT24gSnVuIDYsIDIwMTksIGF0IDEyOjQzIFBNLCBTdGVwaGVuIEhl
bW1pbmdlciA8c3RlcGhlbkBuZXR3b3JrcGx1bWJlci5vcmc+IHdyb3RlOg0KPj4+IA0KPj4+IE9u
IFRodSwgIDYgSnVuIDIwMTkgMTA6NTI6MTggLTA3MDANCj4+PiBWZWRhbmcgUGF0ZWwgPHZlZGFu
Zy5wYXRlbEBpbnRlbC5jb20+IHdyb3RlOg0KPj4+IA0KPj4+PiBAQCAtNDA1LDYgKzQyMCw3IEBA
IHN0YXRpYyBpbnQgdGFwcmlvX3ByaW50X29wdChzdHJ1Y3QgcWRpc2NfdXRpbCAqcXUsIEZJTEUg
KmYsIHN0cnVjdCBydGF0dHIgKm9wdCkNCj4+Pj4gCXN0cnVjdCBydGF0dHIgKnRiW1RDQV9UQVBS
SU9fQVRUUl9NQVggKyAxXTsNCj4+Pj4gCXN0cnVjdCB0Y19tcXByaW9fcW9wdCAqcW9wdCA9IDA7
DQo+Pj4+IAlfX3MzMiBjbG9ja2lkID0gQ0xPQ0tJRF9JTlZBTElEOw0KPj4+PiArCV9fdTMyIG9m
ZmxvYWRfZmxhZ3MgPSAwOw0KPj4+PiAJaW50IGk7DQo+Pj4+IA0KPj4+PiAJaWYgKG9wdCA9PSBO
VUxMKQ0KPj4+PiBAQCAtNDQyLDYgKzQ1OCwxMSBAQCBzdGF0aWMgaW50IHRhcHJpb19wcmludF9v
cHQoc3RydWN0IHFkaXNjX3V0aWwgKnF1LCBGSUxFICpmLCBzdHJ1Y3QgcnRhdHRyICpvcHQpDQo+
Pj4+IA0KPj4+PiAJcHJpbnRfc3RyaW5nKFBSSU5UX0FOWSwgImNsb2NraWQiLCAiY2xvY2tpZCAl
cyIsIGdldF9jbG9ja19uYW1lKGNsb2NraWQpKTsNCj4+Pj4gDQo+Pj4+ICsJaWYgKHRiW1RDQV9U
QVBSSU9fQVRUUl9PRkZMT0FEX0ZMQUdTXSkNCj4+Pj4gKwkJb2ZmbG9hZF9mbGFncyA9IHJ0YV9n
ZXRhdHRyX3UzMih0YltUQ0FfVEFQUklPX0FUVFJfT0ZGTE9BRF9GTEFHU10pOw0KPj4+PiArDQo+
Pj4+ICsJcHJpbnRfdWludChQUklOVF9BTlksICJvZmZsb2FkIiwgIiBvZmZsb2FkICV4Iiwgb2Zm
bG9hZF9mbGFncyk7ICANCj4+PiANCj4+PiBJIGRvbid0IHRoaW5rIG9mZmxvYWQgZmxhZ3Mgc2hv
dWxkIGJlICBwcmludGVkIGF0IGFsbCBpZiBub3QgcHJlc2VudC4NCj4+PiANCj4+PiBXaHkgbm90
PyAgDQo+PiBXaWxsIG1ha2UgdGhpcyBpbiB0aGUgbmV4dCB2ZXJzaW9uLg0KPiANCj4gTW9zdGx5
IHRoaXMgaXMgc28gdGhhdCBvdXRwdXQgZG9lc24ndCBjaGFuZ2UgZm9yIHVzZXJzIHdobyBhcmVu
J3QgdXNpbmcgb2ZmbG9hZCBvciBoYXZlIG9sZCBrZXJuZWwuDQpZZXMsIEkgYWdyZWUgd2l0aCB0
aGF0LiBCdXQsIHRoaXMgY2hhbmdlIGFsb25lIHdvbuKAmXQgYmUgZW5vdWdoLiBUaGVyZSBpcyBh
IG1pbm9yIGtlcm5lbCBjaGFuZ2UgYWxzbyByZXF1aXJlZCB3aGljaCB3aWxsIG5vdCBzZW5kIHRo
ZSBwYXJhbWV0ZXJzIGlmIHRoZXkgYXJlIG5vdCBzZXQuIEkgd2lsbCBpbmNsdWRlIHRoYXQgY2hh
bmdlIGluIHRoZSBuZXh0IHZlcnNpb24gb2YgbXkga2VybmVsIHBhdGNoZXMuIA0KDQpJcHJvdXRl
MiBwYXRjaGVzIGluY29taW5nIG1vbWVudGFyaWx5LiBUaGlzIGlzIHRoZSB2MiB3aGljaCBJIHdh
cyBzdXBwb3NlZCB0byBzZW5kIG91dC4NCg0KVGhhbmtzLA0KVmVkYW5n
