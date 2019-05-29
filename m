Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E17CE2E2D6
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbfE2RG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:06:56 -0400
Received: from mga04.intel.com ([192.55.52.120]:16973 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfE2RGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 13:06:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 10:06:55 -0700
X-ExtLoop1: 1
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga002.jf.intel.com with ESMTP; 29 May 2019 10:06:54 -0700
Received: from orsmsx114.amr.corp.intel.com (10.22.240.10) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 29 May 2019 10:06:54 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.95]) by
 ORSMSX114.amr.corp.intel.com ([169.254.8.116]) with mapi id 14.03.0415.000;
 Wed, 29 May 2019 10:06:54 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>
Subject: Re: [PATCH net-next v1 3/7] taprio: Add the skeleton to enable
 hardware offloading
Thread-Topic: [PATCH net-next v1 3/7] taprio: Add the skeleton to enable
 hardware offloading
Thread-Index: AQHVFX1jRoxwIAipQEiZCaa8URTGlqaBmGAAgAEzxgA=
Date:   Wed, 29 May 2019 17:06:49 +0000
Message-ID: <62E2DD49-AC21-46DE-8E5B-EBC67230FA7D@intel.com>
References: <1559065608-27888-1-git-send-email-vedang.patel@intel.com>
 <1559065608-27888-4-git-send-email-vedang.patel@intel.com>
 <20190528154510.41b50723@cakuba.netronome.com>
In-Reply-To: <20190528154510.41b50723@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.201]
Content-Type: text/plain; charset="utf-8"
Content-ID: <55D5CAF235ABE14E81A33FF047D69744@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIEphY3ViIGZvciB0aGV5IGlucHV0cy4NCg0KPiBPbiBNYXkgMjgsIDIwMTksIGF0IDM6
NDUgUE0sIEpha3ViIEtpY2luc2tpIDxqYWt1Yi5raWNpbnNraUBuZXRyb25vbWUuY29tPiB3cm90
ZToNCj4gDQo+IE9uIFR1ZSwgMjggTWF5IDIwMTkgMTA6NDY6NDQgLTA3MDAsIFZlZGFuZyBQYXRl
bCB3cm90ZToNCj4+IEZyb206IFZpbmljaXVzIENvc3RhIEdvbWVzIDx2aW5pY2l1cy5nb21lc0Bp
bnRlbC5jb20+DQo+PiANCj4+IFRoaXMgYWRkcyB0aGUgVUFQSSBhbmQgdGhlIGNvcmUgYml0cyBu
ZWNlc3NhcnkgZm9yIHVzZXJzcGFjZSB0bw0KPj4gcmVxdWVzdCBoYXJkd2FyZSBvZmZsb2FkaW5n
IHRvIGJlIGVuYWJsZWQuDQo+PiANCj4+IFRoZSBmdXR1cmUgY29tbWl0cyB3aWxsIGVuYWJsZSBo
eWJyaWQgb3IgZnVsbCBvZmZsb2FkaW5nIGZvciB0YXByaW8uIFRoaXMNCj4+IGNvbW1pdCBzZXRz
IHVwIHRoZSBpbmZyYXN0cnVjdHVyZSB0byBlbmFibGUgaXQgdmlhIHRoZSBuZXRsaW5rIGludGVy
ZmFjZS4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogVmluaWNpdXMgQ29zdGEgR29tZXMgPHZpbmlj
aXVzLmdvbWVzQGludGVsLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IFZlZGFuZyBQYXRlbCA8dmVk
YW5nLnBhdGVsQGludGVsLmNvbT4NCj4gDQo+IE90aGVyIHFkaXNjcyBvZmZsb2FkIGJ5IGRlZmF1
bHQsIHRoaXMgb2ZmbG9hZC1sZXZlbCBzZWxlY3Rpb24gaGVyZSBpcyBhDQo+IGxpdHRsZSBiaXQg
aW5jb25zaXN0ZW50IHdpdGggdGhhdCA6KA0KPiANClRoZXJlIGFyZSAyIGRpZmZlcmVudCBvZmZs
b2FkIG1vZGVzIGludHJvZHVjZWQgaW4gdGhpcyBwYXRjaC4NCg0KMS4gVHh0aW1lIG9mZmxvYWQg
bW9kZTogVGhpcyBtb2RlIGRlcGVuZHMgb24gc2tpcF9zb2NrX2NoZWNrIGZsYWcgYmVpbmcgc2V0
IGluIHRoZSBldGYgcWRpc2MuIEFsc28sIGl0IHJlcXVpcmVzIHNvbWUgbWFudWFsIGNvbmZpZ3Vy
YXRpb24gd2hpY2ggbWlnaHQgYmUgc3BlY2lmaWMgdG8gdGhlIG5ldHdvcmsgYWRhcHRlciBjYXJk
LiBGb3IgZXhhbXBsZSwgZm9yIHRoZSBpMjEwIGNhcmQsIHRoZSB1c2VyIHdpbGwgaGF2ZSB0byBy
b3V0ZSBhbGwgdGhlIHRyYWZmaWMgdG8gdGhlIGhpZ2hlc3QgcHJpb3JpdHkgcXVldWUgYW5kIGlu
c3RhbGwgZXRmIHFkaXNjIHdpdGggb2ZmbG9hZCBlbmFibGVkIG9uIHRoYXQgcXVldWUuIFNvLCBJ
IGRvbuKAmXQgdGhpbmsgdGhpcyBtb2RlIHNob3VsZCBiZSBlbmFibGVkIGJ5IGRlZmF1bHQuDQoy
LiBGdWxsIG9mZmxvYWQgbW9kZTogVGhpcyBtb2RlIGlzIGN1cnJlbnRseSBub3Qgc3VwcG9ydGVk
IGJ5IGFueSBuZXR3b3JrIGRyaXZlci4gVGhlIHN1cHBvcnQgZm9yIHRoaXMgd2lsbCBiZSBjb21p
bmcgc29vbi4gQnV0LCB3ZSBjYW4gZW5hYmxlIHRoaXMgbW9kZSBieSBkZWZhdWx0LiANCg0KQWxz
bywgZnJvbSB3aGF0IFZpbmljaXVzIHRlbGxzIG1lLCBvZmZsb2FkIG1vZGVzIGZvciBjYnMsIGV0
ZiBhbmQgbXFwcmlvIGFyZSBhbHNvIGRpc2FibGVkIGJ5IGRlZmF1bHQuIFNvLCBpdCB3aWxsIG1h
a2UgbW9yZSBzZW5zZSB0byBrZWVwIGl0IGRpc2FibGVkIHRvIGJlIGNvbnNpc3RlbnQgd2l0aCBv
dGhlciBxZGlzY3Mgc2ltaWxhciB0byB0aGlzIG9uZS4NCj4+IEBAIC03MzEsNiArODU3LDkgQEAg
c3RhdGljIGludCB0YXByaW9fY2hhbmdlKHN0cnVjdCBRZGlzYyAqc2NoLCBzdHJ1Y3QgbmxhdHRy
ICpvcHQsDQo+PiAJaWYgKGVyciA8IDApDQo+PiAJCXJldHVybiBlcnI7DQo+PiANCj4+ICsJaWYg
KHRiW1RDQV9UQVBSSU9fQVRUUl9PRkZMT0FEX0ZMQUdTXSkNCj4+ICsJCW9mZmxvYWRfZmxhZ3Mg
PSBubGFfZ2V0X3UzMih0YltUQ0FfVEFQUklPX0FUVFJfT0ZGTE9BRF9GTEFHU10pOw0KPiANCj4g
WW91IHNob3VsZCBtYWtlIHN1cmUgdXNlciBkb2Vzbid0IHNldCB1bmtub3duIGJpdHMuICBPdGhl
cndpc2UgdXNpbmcNCj4gb3RoZXIgYml0cyB3aWxsIG5vdCBiZSBwb3NzaWJsZSBpbiB0aGUgZnV0
dXJlLg0KPiANClllcywgSSBhZ3JlZSBoZXJlLCB3aWxsIGluY2x1ZGUgdGhpcyBpbiB0aGUgbmV4
dCBwYXRjaHNldC4NCg0KVGhhbmtzLA0KVmVkYW5nDQo+PiAJbmV3X2FkbWluID0ga3phbGxvYyhz
aXplb2YoKm5ld19hZG1pbiksIEdGUF9LRVJORUwpOw0KPj4gCWlmICghbmV3X2FkbWluKSB7DQo+
PiAJCU5MX1NFVF9FUlJfTVNHKGV4dGFjaywgIk5vdCBlbm91Z2ggbWVtb3J5IGZvciBhIG5ldyBz
Y2hlZHVsZSIpOw0KDQo=
