Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3ED270A5D
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 22:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbfGVULw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 16:11:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:1644 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbfGVULw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 16:11:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jul 2019 13:11:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,296,1559545200"; 
   d="scan'208";a="196866280"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga002.fm.intel.com with ESMTP; 22 Jul 2019 13:11:51 -0700
Received: from orsmsx157.amr.corp.intel.com (10.22.240.23) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 22 Jul 2019 13:11:50 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.6]) by
 ORSMSX157.amr.corp.intel.com ([169.254.9.94]) with mapi id 14.03.0439.000;
 Mon, 22 Jul 2019 13:11:50 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     David Ahern <dsahern@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>
Subject: Re: [PATCH iproute2] etf: make printing of variable JSON friendly
Thread-Topic: [PATCH iproute2] etf: make printing of variable JSON friendly
Thread-Index: AQHVPnqjzjEUTHyXSkOLocBekrLjQ6bXbP6AgAAexoA=
Date:   Mon, 22 Jul 2019 20:11:49 +0000
Message-ID: <98A741A5-EAC0-408F-84C2-34E4714A2097@intel.com>
References: <1563572443-10879-1-git-send-email-vedang.patel@intel.com>
 <a7c60706-562a-429d-400f-af2ad1606ba3@gmail.com>
In-Reply-To: <a7c60706-562a-429d-400f-af2ad1606ba3@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.167]
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC5CD10A41F1834D95DD67E792C40B3B@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gSnVsIDIyLCAyMDE5LCBhdCAxMToyMSBBTSwgRGF2aWQgQWhlcm4gPGRzYWhlcm5A
Z21haWwuY29tPiB3cm90ZToNCj4gDQo+IE9uIDcvMTkvMTkgMzo0MCBQTSwgVmVkYW5nIFBhdGVs
IHdyb3RlOg0KPj4gSW4gaXByb3V0ZTIgdHh0aW1lLWFzc2lzdCBzZXJpZXMsIGl0IHdhcyBwb2lu
dGVkIG91dCB0aGF0IHByaW50X2Jvb2woKQ0KPj4gc2hvdWxkIGJlIHVzZWQgdG8gcHJpbnQgYmlu
YXJ5IHZhbHVlcy4gVGhpcyBpcyB0byBtYWtlIGl0IEpTT04gZnJpZW5kbHkuDQo+PiANCj4+IFNv
LCBtYWtlIHRoZSBjb3JyZXNwb25kaW5nIGNoYW5nZXMgaW4gRVRGLg0KPj4gDQo+PiBGaXhlczog
OGNjZDQ5MzgzY2RjICgiZXRmOiBBZGQgc2tpcF9zb2NrX2NoZWNrIikNCj4+IFJlcG9ydGVkLWJ5
OiBTdGVwaGVuIEhlbW1pbmdlciA8c3RlcGhlbkBuZXR3b3JrcGx1bWJlci5vcmc+DQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBWZWRhbmcgUGF0ZWwgPHZlZGFuZy5wYXRlbEBpbnRlbC5jb20+DQo+PiAtLS0N
Cj4+IHRjL3FfZXRmLmMgfCAxMiArKysrKystLS0tLS0NCj4+IDEgZmlsZSBjaGFuZ2VkLCA2IGlu
c2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS90Yy9xX2V0
Zi5jIGIvdGMvcV9ldGYuYw0KPj4gaW5kZXggYzIwOTA1ODliYzY0Li4zMDdjNTBlZWQ0OGIgMTAw
NjQ0DQo+PiAtLS0gYS90Yy9xX2V0Zi5jDQo+PiArKysgYi90Yy9xX2V0Zi5jDQo+PiBAQCAtMTc2
LDEyICsxNzYsMTIgQEAgc3RhdGljIGludCBldGZfcHJpbnRfb3B0KHN0cnVjdCBxZGlzY191dGls
ICpxdSwgRklMRSAqZiwgc3RydWN0IHJ0YXR0ciAqb3B0KQ0KPj4gCQkgICAgIGdldF9jbG9ja19u
YW1lKHFvcHQtPmNsb2NraWQpKTsNCj4+IA0KPj4gCXByaW50X3VpbnQoUFJJTlRfQU5ZLCAiZGVs
dGEiLCAiZGVsdGEgJWQgIiwgcW9wdC0+ZGVsdGEpOw0KPj4gLQlwcmludF9zdHJpbmcoUFJJTlRf
QU5ZLCAib2ZmbG9hZCIsICJvZmZsb2FkICVzICIsDQo+PiAtCQkJCShxb3B0LT5mbGFncyAmIFRD
X0VURl9PRkZMT0FEX09OKSA/ICJvbiIgOiAib2ZmIik7DQo+PiAtCXByaW50X3N0cmluZyhQUklO
VF9BTlksICJkZWFkbGluZV9tb2RlIiwgImRlYWRsaW5lX21vZGUgJXMgIiwNCj4+IC0JCQkJKHFv
cHQtPmZsYWdzICYgVENfRVRGX0RFQURMSU5FX01PREVfT04pID8gIm9uIiA6ICJvZmYiKTsNCj4+
IC0JcHJpbnRfc3RyaW5nKFBSSU5UX0FOWSwgInNraXBfc29ja19jaGVjayIsICJza2lwX3NvY2tf
Y2hlY2sgJXMiLA0KPj4gLQkJCQkocW9wdC0+ZmxhZ3MgJiBUQ19FVEZfU0tJUF9TT0NLX0NIRUNL
KSA/ICJvbiIgOiAib2ZmIik7DQo+PiArCWlmIChxb3B0LT5mbGFncyAmIFRDX0VURl9PRkZMT0FE
X09OKQ0KPj4gKwkJcHJpbnRfYm9vbChQUklOVF9BTlksICJvZmZsb2FkIiwgIm9mZmxvYWQgIiwg
dHJ1ZSk7DQo+PiArCWlmIChxb3B0LT5mbGFncyAmIFRDX0VURl9ERUFETElORV9NT0RFX09OKQ0K
Pj4gKwkJcHJpbnRfYm9vbChQUklOVF9BTlksICJkZWFkbGluZV9tb2RlIiwgImRlYWRsaW5lX21v
ZGUgIiwgdHJ1ZSk7DQo+PiArCWlmIChxb3B0LT5mbGFncyAmIFRDX0VURl9TS0lQX1NPQ0tfQ0hF
Q0spDQo+PiArCQlwcmludF9ib29sKFBSSU5UX0FOWSwgInNraXBfc29ja19jaGVjayIsICJza2lw
X3NvY2tfY2hlY2siLCB0cnVlKTsNCj4+IA0KPj4gCXJldHVybiAwOw0KPj4gfQ0KPj4gDQo+IA0K
PiBUaGlzIGNoYW5nZXMgZXhpc3Rpbmcgb3V0cHV0IGZvciBUQ19FVEZfT0ZGTE9BRF9PTiBhbmQN
Cj4gVENfRVRGX0RFQURMSU5FX01PREVfT04gd2hpY2ggd2VyZSBhZGRlZCBhIHllYXIgYWdvLg0K
WWVzLCB0aGlzIGlzIGEgZ29vZCBwb2ludC4gSSBtaXNzZWQgdGhhdC4gDQoNCkFub3RoZXIgaWRl
YSBpcyB0byB1c2UgaXNfanNvbl9jb250ZXh0KCkgYW5kIGNhbGwgcHJpbnRfYm9vbCgpIHRoZXJl
LiBCdXQsIHRoYXQgd2lsbCBzdGlsbCBjaGFuZ2UgdmFsdWVzIGNvcnJlc3BvbmRpbmcgdG8gdGhl
IGpzb24gb3V0cHV0IGZvciB0aGUgYWJvdmUgZmxhZ3MgZnJvbSDigJxvbuKAnS/igJxvZmbigJ0g
dG8g4oCcdHJ1ZeKAnS/igJxmYWxzZeKAnS4gSSBhbSBub3Qgc3VyZSBpZiB0aGlzIGlzIGEgYmln
IGlzc3VlLiANCg0KTXkgc3VnZ2VzdGlvbiBpcyB0byBrZWVwIHRoZSBjb2RlIGFzIGlzLiB3aGF0
IGRvIHlvdSB0aGluaz8NCg0KVGhhbmtzLA0KVmVkYW5n
