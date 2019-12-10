Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7938311822B
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 09:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfLJIYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:24:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41132 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbfLJIYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 03:24:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B68A8153A9D44;
        Tue, 10 Dec 2019 00:24:10 -0800 (PST)
Date:   Tue, 10 Dec 2019 00:24:08 -0800 (PST)
Message-Id: <20191210.002408.743399545997526376.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: linux-next: Tree for Dec 10 (ethernet/8390/8390p.c)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ce89aa80-558c-1ccb-afbe-0af6bc4f3e19@infradead.org>
References: <20191210140225.1aa0c90e@canb.auug.org.au>
        <ce89aa80-558c-1ccb-afbe-0af6bc4f3e19@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Dec 2019 00:24:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUmFuZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+DQpEYXRlOiBNb24sIDkg
RGVjIDIwMTkgMjM6MTM6MzQgLTA4MDANCg0KPiBPbiAxMi85LzE5IDc6MDIgUE0sIFN0ZXBoZW4g
Um90aHdlbGwgd3JvdGU6DQo+PiBIaSBhbGwsDQo+PiANCj4+IENoYW5nZXMgc2luY2UgMjAxOTEy
MDk6DQo+PiANCj4gDQo+IG9uIGkzODY6DQo+IA0KPiAuLi9kcml2ZXJzL25ldC9ldGhlcm5ldC84
MzkwLzgzOTBwLmM6NDQ6NjogZXJyb3I6IGNvbmZsaWN0aW5nIHR5cGVzIGZvciChZWlwX3R4X3Rp
bWVvdXSiDQo+ICB2b2lkIGVpcF90eF90aW1lb3V0KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIHVu
c2lnbmVkIGludCB0eHF1ZXVlKQ0KPiAgICAgICBefn5+fn5+fn5+fn5+fg0KPiBJbiBmaWxlIGlu
Y2x1ZGVkIGZyb20gLi4vZHJpdmVycy9uZXQvZXRoZXJuZXQvODM5MC9saWI4MzkwLmM6NzU6MCwN
Cj4gICAgICAgICAgICAgICAgICBmcm9tIC4uL2RyaXZlcnMvbmV0L2V0aGVybmV0LzgzOTAvODM5
MHAuYzoxMjoNCj4gLi4vZHJpdmVycy9uZXQvZXRoZXJuZXQvODM5MC84MzkwLmg6NTM6Njogbm90
ZTogcHJldmlvdXMgZGVjbGFyYXRpb24gb2YgoWVpcF90eF90aW1lb3V0oiB3YXMgaGVyZQ0KPiAg
dm9pZCBlaXBfdHhfdGltZW91dChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KTsNCj4gICAgICAgXn5+
fn5+fn5+fn5+fn4NCg0KRG9lc24ndCBzZWVtIHRvIGJlIGR1ZSB0byBhIGNoYW5nZSBpbiBhbnkg
b2YgbXkgbmV0d29ya2luZyB0cmVlcy4gOi0pDQo=
