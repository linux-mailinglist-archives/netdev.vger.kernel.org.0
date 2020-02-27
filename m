Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01C6C170FB1
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgB0EiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:38:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37048 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728221AbgB0EiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:38:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2D8CA15B478BE;
        Wed, 26 Feb 2020 20:38:24 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:38:23 -0800 (PST)
Message-Id: <20200226.203823.2125720278270075902.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] af_llc: fix if-statement empty body warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4c9fed49-50a7-2877-e9bc-e650a20c0379@infradead.org>
References: <4c9fed49-50a7-2877-e9bc-e650a20c0379@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:38:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUmFuZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+DQpEYXRlOiBUdWUsIDI1
IEZlYiAyMDIwIDIxOjA4OjUyIC0wODAwDQoNCj4gRnJvbTogUmFuZHkgRHVubGFwIDxyZHVubGFw
QGluZnJhZGVhZC5vcmc+DQo+IA0KPiBXaGVuIGRlYnVnZ2luZyB2aWEgZHByaW50aygpIGlzIG5v
dCBlbmFibGVkLCBtYWtlIHRoZSBkcHJpbnRrKCkNCj4gbWFjcm8gYmUgYW4gZW1wdHkgZG8td2hp
bGUgbG9vcCwgYXMgaXMgZG9uZSBpbg0KPiA8bGludXgvc3VucnBjL2RlYnVnLmg+Lg0KPiANCj4g
VGhpcyBmaXhlcyBhIGdjYyB3YXJuaW5nIHdoZW4gLVdleHRyYSBpcyBzZXQ6DQo+IC4uL25ldC9s
bGMvYWZfbGxjLmM6OTc0OjUxOiB3YXJuaW5nOiBzdWdnZXN0IGJyYWNlcyBhcm91bmQgZW1wdHkg
Ym9keSBpbiBhbiChaWaiIHN0YXRlbWVudCBbLVdlbXB0eS1ib2R5XQ0KPiANCj4gSSBoYXZlIHZl
cmlmaWVkIHRoYXQgdGhlcmUgaXMgbm90IG9iamVjdCBjb2RlIGNoYW5nZSAod2l0aCBnY2MgNy41
LjApLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogUmFuZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVh
ZC5vcmc+DQoNCkFwcGxpZWQuDQo=
