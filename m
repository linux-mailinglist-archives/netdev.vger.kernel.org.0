Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F7C1D3EB8
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgENUJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726128AbgENUJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 16:09:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD261C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 13:09:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5DE9E128D497F;
        Thu, 14 May 2020 13:09:53 -0700 (PDT)
Date:   Thu, 14 May 2020 13:09:52 -0700 (PDT)
Message-Id: <20200514.130952.794606246311304590.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, mkalderon@marvell.com,
        dbolotin@marvell.com, kuba@kernel.org
Subject: Re: [PATCH v2 net-next 00/11] net: qed/qede: critical hw error
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514.130159.1188703412067742485.davem@davemloft.net>
References: <20200514095727.1361-1-irusskikh@marvell.com>
        <20200514.130159.1188703412067742485.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 13:09:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogVGh1LCAxNCBN
YXkgMjAyMCAxMzowMTo1OSAtMDcwMCAoUERUKQ0KDQo+IEZyb206IElnb3IgUnVzc2tpa2ggPGly
dXNza2lraEBtYXJ2ZWxsLmNvbT4NCj4gRGF0ZTogVGh1LCAxNCBNYXkgMjAyMCAxMjo1NzoxNiAr
MDMwMA0KPiANCj4+IEZhc3RMaW5RIGRldmljZXMgYXMgYSBjb21wbGV4IHN5c3RlbXMgbWF5IG9i
c2VydmUgdmFyaW91cyBoYXJkd2FyZQ0KPj4gbGV2ZWwgZXJyb3IgY29uZGl0aW9ucywgYm90aCBz
ZXZlcmUgYW5kIHJlY292ZXJhYmxlLg0KPj4gDQo+PiBEcml2ZXIgaXMgYWJsZSB0byBkZXRlY3Qg
YW5kIHJlcG9ydCB0aGlzLCBidXQgc28gZmFyIGl0IG9ubHkgZGlkDQo+PiB0cmFjZS9kbWVzZyBi
YXNlZCByZXBvcnRpbmcuDQo+PiANCj4+IEhlcmUgd2UgaW1wbGVtZW50IGFuIGV4dGVuZGVkIGh3
IGVycm9yIGRldGVjdGlvbiwgc2VydmljZSB0YXNrDQo+PiBoYW5kbGVyIGNhcHR1cmVzIGEgZHVt
cCBmb3IgdGhlIGxhdGVyIGFuYWx5c2lzLg0KPj4gDQo+PiBJIGFsc28gcmVzdWJtaXQgYSBwYXRj
aCBmcm9tIERlbmlzIEJvbG90aW4gb24gdHggdGltZW91dCBoYW5kbGVyLA0KPj4gYWRkcmVzc2lu
ZyBEYXZpZCdzIGNvbW1lbnQgcmVnYXJkaW5nIHJlY292ZXJ5IHByb2NlZHVyZSBhcyBhbiBleHRy
YQ0KPj4gcmVhY3Rpb24gb24gdGhpcyBldmVudC4NCj4+IA0KPj4gdjI6DQo+PiANCj4+IFJlbW92
aW5nIHRoZSBwYXRjaCB3aXRoIGV0aHRvb2wgZHVtcCBhbmQgdWRldiBtYWdpYy4gSXRzIHF1aXRl
IGlzb2xhdGVkLA0KPj4gSSdtIHdvcmtpbmcgb24gZGV2bGluayBiYXNlZCBsb2dpYyBmb3IgdGhp
cyBzZXBhcmF0ZWx5Lg0KPj4gDQo+PiB2MToNCj4+IA0KPj4gaHR0cHM6Ly9wYXRjaHdvcmsub3ps
YWJzLm9yZy9wcm9qZWN0L25ldGRldi9jb3Zlci9jb3Zlci4xNTg4NzU4NDYzLmdpdC5pcnVzc2tp
a2hAbWFydmVsbC5jb20vDQo+IA0KPiBJJ20gb25seSBhcHBseWluZyB0aGlzIHNlcmllcyBiZWNh
dXNlIEkgdHJ1c3QgdGhhdCB5b3Ugd2lsbCBhY3R1YWxseSBkbyB0aGUNCj4gZGV2bGluayB3b3Jr
LCBhbmQgeW91IHdpbGwgaGF2ZSBpdCBkb25lIGFuZCBzdWJtaXR0ZWQgaW4gYSByZWFzb25hYmxl
IGFtb3VudA0KPiBvZiB0aSBtZS4NCj4gDQo+IEFsc28sIHBhdGNoICM0IGhhZCB0cmFpbGluZyBl
bXB0eSBsaW5lcyBhZGRlZCB0byBhIGZpbGUsIHdoaWNoIGlzDQo+IHdhcm5lZCBhYm91dCBieSAn
Z2l0JyB3aGVuIEkgYXBwbHkgeW91ciBwYXRjaGVzLiAgSSBmaXhlZCBpdCB1cCwgYnV0DQo+IHRo
aXMgaXMgdGhlIGtpbmQgb2YgdGhpbmcgeW91IHNob3VsZCBoYXZlIHNvcnRlZCBvdXQgYmVmb3Jl
IHlvdSBzdWJtaXQNCj4gY2hhbmdlcyB0byB0aGUgbGlzdC4NCg0KQWN0dWFsbHksIEkgaGFkIHRv
IHJldmVydCwgcGxlYXNlIGZpeCB0aGVzZSB3YXJuaW5ncyAod2l0aCBnY2MtMTAuMS4xIG9uIEZl
ZG9yYSlfOg0KDQpkcml2ZXJzL25ldC9ldGhlcm5ldC9xbG9naWMvcWVkL3FlZF9kZXYuYzogSW4g
ZnVuY3Rpb24goXFlZF9sbGhfYWRkX21hY19maWx0ZXKiOg0KLi9pbmNsdWRlL2xpbnV4L3ByaW50
ay5oOjMwMzoyOiB3YXJuaW5nOiChYWJzX3BwZmlkoiBtYXkgYmUgdXNlZCB1bmluaXRpYWxpemVk
IGluIHRoaXMgZnVuY3Rpb24gWy1XbWF5YmUtdW5pbml0aWFsaXplZF0NCiAgMzAzIHwgIHByaW50
ayhLRVJOX05PVElDRSBwcl9mbXQoZm10KSwgIyNfX1ZBX0FSR1NfXykNCiAgICAgIHwgIF5+fn5+
fg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvcWxvZ2ljL3FlZC9xZWRfZGV2LmM6OTgzOjE3OiBub3Rl
OiChYWJzX3BwZmlkoiB3YXMgZGVjbGFyZWQgaGVyZQ0KICA5ODMgfCAgdTggZmlsdGVyX2lkeCwg
YWJzX3BwZmlkOw0KICAgICAgfCAgICAgICAgICAgICAgICAgXn5+fn5+fn5+DQo=
