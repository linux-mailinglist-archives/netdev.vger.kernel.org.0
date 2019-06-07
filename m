Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A36CB3989D
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731324AbfFGW1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:27:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:44174 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729867AbfFGW1J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 18:27:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 15:27:08 -0700
X-ExtLoop1: 1
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jun 2019 15:27:08 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.13]) by
 ORSMSX110.amr.corp.intel.com ([169.254.10.60]) with mapi id 14.03.0415.000;
 Fri, 7 Jun 2019 15:27:07 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH net-next v2 4/6] taprio: Add support for txtime-assist
 mode.
Thread-Topic: [PATCH net-next v2 4/6] taprio: Add support for txtime-assist
 mode.
Thread-Index: AQHVHJBzjS7vryb4PEKbp2Rx8Aj1tqaPuV4AgAFmBICAABZMgIAABssA
Date:   Fri, 7 Jun 2019 22:27:07 +0000
Message-ID: <0ED5E88B-E95A-4899-975D-00912685CEEF@intel.com>
References: <1559843458-12517-1-git-send-email-vedang.patel@intel.com>
 <1559843458-12517-5-git-send-email-vedang.patel@intel.com>
 <20190606162132.0591cc37@cakuba.netronome.com>
 <FF3C8B8E-421E-4C93-8895-C21A38BB55EE@intel.com>
 <20190607150243.369f6e2c@cakuba.netronome.com>
In-Reply-To: <20190607150243.369f6e2c@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.138]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B4A59B9DD932D4A86C885652AE398AF@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFjdWIsIA0KDQo+IE9uIEp1biA3LCAyMDE5LCBhdCAzOjAyIFBNLCBKYWt1YiBLaWNpbnNr
aSA8amFrdWIua2ljaW5za2lAbmV0cm9ub21lLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBGcmksIDcg
SnVuIDIwMTkgMjA6NDI6NTUgKzAwMDAsIFBhdGVsLCBWZWRhbmcgd3JvdGU6DQo+Pj4gVGhhbmtz
IGZvciB0aGUgY2hhbmdlcywgc2luY2UgeW91IG5vdyB2YWxpZGF0ZSBubyB1bmtub3duIGZsYWdz
IGFyZQ0KPj4+IHBhc3NlZCwgcGVyaGFwcyB0aGVyZSBpcyBubyBuZWVkIHRvIGNoZWNrIGlmIGZs
YWdzIGFyZSA9PSB+MD8NCj4+PiANCj4+PiBJU19FTkFCTEVEKCkgY291bGQganVzdCBkbzogKGZs
YWdzKSAmIFRDQV9UQVBSSU9fQVRUUl9GTEFHX1RYVElNRV9BU1NJU1QNCj4+PiBObz8NCj4+PiAN
Cj4+IFRoaXMgaXMgc3BlY2lmaWNhbGx5IGRvbmUgc28gdGhhdCB1c2VyIGRvZXMgbm90IGhhdmUg
dG8gc3BlY2lmeSB0aGUNCj4+IG9mZmxvYWQgZmxhZ3Mgd2hlbiB0cnlpbmcgdG8gaW5zdGFsbCB0
aGUgYW5vdGhlciBzY2hlZHVsZSB3aGljaCB3aWxsDQo+PiBiZSBzd2l0Y2hlZCB0byBhdCBhIGxh
dGVyIHBvaW50IG9mIHRpbWUgKGkuZS4gdGhlIGFkbWluIHNjaGVkdWxlDQo+PiBpbnRyb2R1Y2Vk
IGluIFZpbmljaXVz4oCZIGxhc3Qgc2VyaWVzKS4gU2V0dGluZyB0YXByaW9fZmxhZ3MgdG8gfjAN
Cj4+IHdpbGwgaGVscCB1cyBkaXN0aW5ndWlzaCBiZXR3ZWVuIHRoZSBmbGFncyBwYXJhbWV0ZXIg
bm90IHNwZWNpZmllZA0KPj4gYW5kIGZsYWdzIHNldCB0byAwLg0KPiANCj4gSSdtIG5vdCBzdXBl
ciBjbGVhciBvbiB0aGlzLCBiZWNhdXNlIG9mIGJhY2t3YXJkIGNvbXBhdCB5b3UgaGF2ZSB0bw0K
PiB0cmVhdCBhdHRyIG5vdCBwcmVzZW50IGFzIHVuc2V0LiAgTGV0J3Mgc2VlOg0KPiANCj4gbmV3
IHFkaXNjOg0KPiAtIGZsYWdzIGF0dHIgPSAwIC0+IHR4dGltZSBub3QgdXNlZA0KPiAtIGZsYWdz
IGF0dHIgPSAxIC0+IHR4dGltZSB1c2VkDQo+IC0+IG5vIGZsYWdzIGF0dHIgLT4gdHh0aW1lIG5v
dCB1c2VkDQo+IGNoYW5nZSBxZGlzYzoNCj4gLSBmbGFncyBhdHRyID0gb2xkIGZsYWdzIGF0dHIg
LT4gbGVhdmUgdW5jaGFuZ2VkDQo+IC0gZmxhZ3MgYXR0ciAhPSBvbGQgZmxhZ3MgYXR0ciAtPiBl
cnJvcg0KPiAtIG5vIGZsYWdzIGF0dHIgLT4gbGVhdmUgdHh0aW1lIHVuY2hhbmdlZA0KPiANCj4g
RG9lc24ndCB0aGF0IGNvdmVyIHRoZSBjYXNlcz8gIFdlcmUgeW91IHBsYW5uaW5nIHRvIGhhdmUg
bm8gZmxhZyBhdHRyDQo+IG9uIGNoYW5nZSBtZWFuIGRpc2FibGVkIHJhdGhlciB0aGFuIG5vIGNo
YW5nZT8NCg0KWW91IGNvdmVyZWQgYWxsIHRoZSBjYXNlcyBhYm92ZS4NCg0KVGhpbmtpbmcgYSBi
aXQgbW9yZSBhYm91dCBpdCwgeWVzIHlvdSBhcmUgcmlnaHQuIEluaXRpaWFsaXppbmcgZmxhZ3Mg
dG8gMCB3aWxsIHdvcmsuICBJIHdpbGwgaW5jb3Jwb3JhdGUgdGhpcyBjaGFuZ2UgaW4gdGhlIG5l
eHQgdmVyc2lvbi4NCg0KVGhhbmtzLA0KVmVkYW5n
