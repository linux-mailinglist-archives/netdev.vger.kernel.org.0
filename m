Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A315FD7B
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 21:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfGDTiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 15:38:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52646 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfGDTiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 15:38:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CDF31144B3812;
        Thu,  4 Jul 2019 12:38:00 -0700 (PDT)
Date:   Thu, 04 Jul 2019 12:38:00 -0700 (PDT)
Message-Id: <20190704.123800.788232773059713763.davem@davemloft.net>
To:     opensource@vdorst.com
Cc:     sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, matthias.bgg@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, frank-w@public-files.de,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: ethernet: mediatek: Fix overlapping
 capability bits.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190703184203.20137-1-opensource@vdorst.com>
References: <20190703184203.20137-1-opensource@vdorst.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jul 2019 12:38:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUmVuw6kgdmFuIERvcnN0IDxvcGVuc291cmNlQHZkb3JzdC5jb20+DQpEYXRlOiBXZWQs
ICAzIEp1bCAyMDE5IDIwOjQyOjA0ICswMjAwDQoNCj4gQm90aCBNVEtfVFJHTUlJX01UNzYyMV9D
TEsgYW5kIE1US19QQVRIX0JJVCBhcmUgZGVmaW5lZCBhcyBiaXQgMTAuDQo+IA0KPiBUaGlzIGNh
biBjYXVzZXMgaXNzdWVzIG9uIG5vbi1NVDc2MjEgZGV2aWNlcyB3aGljaCBoYXMgdGhlDQo+IE1U
S19QQVRIX0JJVChNVEtfRVRIX1BBVEhfR01BQzFfUkdNSUkpIGFuZCBNVEtfVFJHTUlJIGNhcGFi
aWxpdHkgc2V0Lg0KPiBUaGUgd3JvbmcgVFJHTUlJIHNldHVwIGNvZGUgY2FuIGJlIGV4ZWN1dGVk
LiBUaGUgY3VycmVudCB3cm9uZ2x5IGV4ZWN1dGVkDQo+IGNvZGUgZG9lc27igJl0IGRvIGFueSBo
YXJtIG9uIE1UNzYyMyBhbmQgdGhlIFRSR01JSSBzZXR1cCBmb3IgdGhlIE1UNzYyMw0KPiBTT0Mg
c2lkZSBpcyBkb25lIGluIE1UNzUzMCBkcml2ZXIgU28gaXQgd2FzbuKAmXQgbm90aWNlZCBpbiB0
aGUgdGVzdC4NCj4gDQo+IE1vdmUgYWxsIGNhcGFiaWxpdHkgYml0cyBpbiBvbmUgZW51bSBzbyB0
aGF0IHRoZXkgYXJlIGFsbCB1bmlxdWUgYW5kIGVhc3kNCj4gdG8gZXhwYW5kIGluIHRoZSBmdXR1
cmUuDQo+IA0KPiBCZWNhdXNlIG10a19ldGhfcGF0aCBlbnVtIGlzIG1lcmdlZCBpbiB0byBta3Rf
ZXRoX2NhcGFiaWxpdGllcywgdGhlDQo+IHZhcmlhYmxlIHBhdGggdmFsdWUgaXMgbm8gbG9uZ2Vy
IGJldHdlZW4gMCB0byBudW1iZXIgb2YgcGF0aHMsDQo+IG10a19ldGhfcGF0aF9uYW1lIGNhbuKA
mXQgYmUgdXNlZCBhbnltb3JlIGluIHRoaXMgZm9ybS4gQ29udmVydCB0aGUNCj4gbXRrX2V0aF9w
YXRoX25hbWUgYXJyYXkgdG8gYSBmdW5jdGlvbiB0byBsb29rdXAgdGhlIHBhdGhuYW1lLg0KPiAN
Cj4gVGhlIG9sZCBjb2RlIHdhbGtlZCB0aHJ1IHRoZSBtdGtfZXRoX3BhdGggZW51bSwgd2hpY2gg
aXMgYWxzbyBtZXJnZWQNCj4gd2l0aCBta3RfZXRoX2NhcGFiaWxpdGllcy4gRXhwYW5kIGFycmF5
IG10a19ldGhfbXV4YyBzbyBpdCBjYW4gc3RvcmUgdGhlDQo+IG5hbWUgYW5kIGNhcGFiaWxpdHkg
Yml0IG9mIHRoZSBtdXguIENvbnZlcnQgdGhlIGNvZGUgc28gaXQgY2FuIHdhbGsgdGhydQ0KPiB0
aGUgbXRrX2V0aF9tdXhjIGFycmF5Lg0KPiANCj4gRml4ZXM6IDhlZmFhNjUzYThhNSAoIm5ldDog
ZXRoZXJuZXQ6IG1lZGlhdGVrOiBBZGQgTVQ3NjIxIFRSR01JSSBtb2RlDQo+IHN1cHBvcnQiKQ0K
DQpQbGVhc2UgaW4gdGhlIGZ1dHVyZSBkbyBub3Qgc3BsaXQgRml4ZXM6IHRhZ3Mgb250byBtdXRs
aXBsZSBsaW5lcywgaXQNCm11c3QgYmUgb25lIGNvbnRpZ3VvdXMgbGluZSBubyBtYXR0ZXIgaG93
IGxvbmcuICBJIGZpeGVkIGl0IHVwIHRoaXMNCnRpbWUuDQoNCj4gU2lnbmVkLW9mZi1ieTogUmVu
w6kgdmFuIERvcnN0IDxvcGVuc291cmNlQHZkb3JzdC5jb20+DQoNCkFwcGxpZWQsIHRoYW5rIHlv
dS4NCg==
