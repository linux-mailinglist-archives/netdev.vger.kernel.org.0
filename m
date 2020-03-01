Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA9A174B62
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 06:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgCAF24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 00:28:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38726 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgCAF24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 00:28:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3296115BD84F8;
        Sat, 29 Feb 2020 21:28:56 -0800 (PST)
Date:   Sat, 29 Feb 2020 21:28:55 -0800 (PST)
Message-Id: <20200229.212855.1220166138877942601.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, 3chas3@gmail.com,
        linux-atm-general@lists.sourceforge.net
Subject: Re: [PATCH] atm: nicstar: fix if-statement empty body warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0ce2604d-191f-0af2-a2f4-9c70da21e907@infradead.org>
References: <0ce2604d-191f-0af2-a2f4-9c70da21e907@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Feb 2020 21:28:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUmFuZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+DQpEYXRlOiBUaHUsIDI3
IEZlYiAyMDIwIDE4OjA5OjQ0IC0wODAwDQoNCj4gRnJvbTogUmFuZHkgRHVubGFwIDxyZHVubGFw
QGluZnJhZGVhZC5vcmc+DQo+IA0KPiBXaGVuIGRlYnVnZ2luZyB2aWEgUFJJTlRLKCkgaXMgbm90
IGVuYWJsZWQsIG1ha2UgdGhlIFBSSU5USygpDQo+IG1hY3JvIGJlIGFuIGVtcHR5IGRvLXdoaWxl
IGJsb2NrLg0KPiANCj4gVGhpeCBmaXhlcyBhIGdjYyB3YXJuaW5nIHdoZW4gLVdleHRyYSBpcyBz
ZXQ6DQo+IC4uL2RyaXZlcnMvYXRtL25pY3N0YXIuYzoxODE5OjIzOiB3YXJuaW5nOiBzdWdnZXN0
IGJyYWNlcyBhcm91bmQgZW1wdHkgYm9keSBpbiBhbiChZWxzZaIgc3RhdGVtZW50IFstV2VtcHR5
LWJvZHldDQo+IA0KPiBJIGhhdmUgdmVyaWZpZWQgdGhhdCB0aGVyZSBpcyBubyBvYmplY3QgY29k
ZSBjaGFuZ2UgKHdpdGggZ2NjIDcuNS4wKS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFJhbmR5IER1
bmxhcCA8cmR1bmxhcEBpbmZyYWRlYWQub3JnPg0KDQpBcHBsaWVkLCB0aGFua3MgUmFuZHkuDQo=
