Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDBD79AA1
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbfG2VJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:09:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39482 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729892AbfG2VJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:09:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 830B0146F6F00;
        Mon, 29 Jul 2019 14:09:06 -0700 (PDT)
Date:   Mon, 29 Jul 2019 14:09:05 -0700 (PDT)
Message-Id: <20190729.140905.1605231050316978110.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        keescook@chromium.org
Subject: Re: [PATCH] net: wan: sdla: Mark expected switch fall-through
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190729200139.GA6102@embeddedor>
References: <20190729200139.GA6102@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 14:09:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogIkd1c3Rhdm8gQS4gUi4gU2lsdmEiIDxndXN0YXZvQGVtYmVkZGVkb3IuY29tPg0KRGF0
ZTogTW9uLCAyOSBKdWwgMjAxOSAxNTowMTozOSAtMDUwMA0KDQo+IE1hcmsgc3dpdGNoIGNhc2Vz
IHdoZXJlIHdlIGFyZSBleHBlY3RpbmcgdG8gZmFsbCB0aHJvdWdoLg0KPiANCj4gVGhpcyBwYXRj
aCBmaXhlcyB0aGUgZm9sbG93aW5nIHdhcm5pbmcgKEJ1aWxkaW5nOiBpMzg2KToNCj4gDQo+IGRy
aXZlcnMvbmV0L3dhbi9zZGxhLmM6IEluIGZ1bmN0aW9uIKFzZGxhX2Vycm9yc6I6DQo+IGRyaXZl
cnMvbmV0L3dhbi9zZGxhLmM6NDE0Ojc6IHdhcm5pbmc6IHRoaXMgc3RhdGVtZW50IG1heSBmYWxs
IHRocm91Z2ggWy1XaW1wbGljaXQtZmFsbHRocm91Z2g9XQ0KPiAgICAgaWYgKGNtZCA9PSBTRExB
X0lORk9STUFUSU9OX1dSSVRFKQ0KPiAgICAgICAgXg0KPiBkcml2ZXJzL25ldC93YW4vc2RsYS5j
OjQxNzozOiBub3RlOiBoZXJlDQo+ICAgIGRlZmF1bHQ6DQo+ICAgIF5+fn5+fn4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IEd1c3Rhdm8gQS4gUi4gU2lsdmEgPGd1c3Rhdm9AZW1iZWRkZWRvci5jb20+
DQoNCkFwcGxpZWQuDQo=
