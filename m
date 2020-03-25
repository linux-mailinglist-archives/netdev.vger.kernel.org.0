Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB2A193124
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgCYT3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:29:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46696 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbgCYT3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 15:29:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E26EC15A0A9FA;
        Wed, 25 Mar 2020 12:29:30 -0700 (PDT)
Date:   Wed, 25 Mar 2020 12:29:30 -0700 (PDT)
Message-Id: <20200325.122930.448274240867191914.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        geert@linux-m68k.org
Subject: Re: [PATCH net] net: Fix CONFIG_NET_CLS_ACT=n and
 CONFIG_NFT_FWD_NETDEV={y,m} build
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200325124718.77151-1-pablo@netfilter.org>
References: <20200325124718.77151-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Mar 2020 12:29:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGFibG8gTmVpcmEgQXl1c28gPHBhYmxvQG5ldGZpbHRlci5vcmc+DQpEYXRlOiBXZWQs
IDI1IE1hciAyMDIwIDEzOjQ3OjE4ICswMTAwDQoNCj4gbmV0L25ldGZpbHRlci9uZnRfZndkX25l
dGRldi5jOiBJbiBmdW5jdGlvbiChbmZ0X2Z3ZF9uZXRkZXZfZXZhbKI6DQo+ICAgICBuZXQvbmV0
ZmlsdGVyL25mdF9md2RfbmV0ZGV2LmM6MzI6MTA6IGVycm9yOiChc3RydWN0IHNrX2J1ZmaiIGhh
cyBubyBtZW1iZXIgbmFtZWQgoXRjX3JlZGlyZWN0ZWSiDQo+ICAgICAgIHBrdC0+c2tiLT50Y19y
ZWRpcmVjdGVkID0gMTsNCj4gICAgICAgICAgICAgICBefg0KPiAgICAgbmV0L25ldGZpbHRlci9u
ZnRfZndkX25ldGRldi5jOjMzOjEwOiBlcnJvcjogoXN0cnVjdCBza19idWZmoiBoYXMgbm8gbWVt
YmVyIG5hbWVkIKF0Y19mcm9tX2luZ3Jlc3OiDQo+ICAgICAgIHBrdC0+c2tiLT50Y19mcm9tX2lu
Z3Jlc3MgPSAxOw0KPiAgICAgICAgICAgICAgIF5+DQo+IA0KPiBUbyBhdm9pZCBhIGRpcmVjdCBk
ZXBlbmRlbmN5IHdpdGggdGMgYWN0aW9ucyBmcm9tIG5ldGZpbHRlciwgd3JhcCB0aGUNCj4gcmVk
aXJlY3QgYml0cyBhcm91bmQgQ09ORklHX05FVF9SRURJUkVDVCBhbmQgbW92ZSBoZWxwZXJzIHRv
DQo+IGluY2x1ZGUvbGludXgvc2tidWZmLmguIFR1cm4gb24gdGhpcyB0b2dnbGUgZnJvbSB0aGUg
aWZiIGRyaXZlciwgdGhlDQo+IG9ubHkgZXhpc3RpbmcgY2xpZW50IG9mIHRoZXNlIGJpdHMgaW4g
dGhlIHRyZWUuDQo+IA0KPiBUaGlzIHBhdGNoIGFkZHMgc2tiX3NldF9yZWRpcmVjdGVkKCkgdGhh
dCBzZXRzIG9uIHRoZSByZWRpcmVjdGVkIGJpdA0KPiBvbiB0aGUgc2tidWZmLCBpdCBzcGVjaWZp
ZXMgaWYgdGhlIHBhY2tldCB3YXMgcmVkaXJlY3QgZnJvbSBpbmdyZXNzDQo+IGFuZCByZXNldHMg
dGhlIHRpbWVzdGFtcCAodGltZXN0YW1wIHJlc2V0IHdhcyBvcmlnaW5hbGx5IG1pc3NpbmcgaW4g
dGhlDQo+IG5ldGZpbHRlciBidWdmaXgpLg0KPiANCj4gRml4ZXM6IGJjZmFiZWUxYWZkOTk0ODQg
KCJuZXRmaWx0ZXI6IG5mdF9md2RfbmV0ZGV2OiBhbGxvdyB0byByZWRpcmVjdCB0byBpZmIgdmlh
IGluZ3Jlc3MiKQ0KPiBSZXBvcnRlZC1ieTogbm9yZXBseUBlbGxlcm1hbi5pZC5hdQ0KPiBSZXBv
cnRlZC1ieTogR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydEBsaW51eC1tNjhrLm9yZz4NCj4gU2ln
bmVkLW9mZi1ieTogUGFibG8gTmVpcmEgQXl1c28gPHBhYmxvQG5ldGZpbHRlci5vcmc+DQoNCkFw
cGxpZWQsIHRoYW5rcy4NCg==
