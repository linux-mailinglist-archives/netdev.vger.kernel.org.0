Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B8079AA4
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbfG2VJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:09:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39492 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729892AbfG2VJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:09:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B3C20146F6F00;
        Mon, 29 Jul 2019 14:09:18 -0700 (PDT)
Date:   Mon, 29 Jul 2019 14:09:18 -0700 (PDT)
Message-Id: <20190729.140918.1981689572132412297.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     t.sailer@alumni.ethz.ch, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        keescook@chromium.org
Subject: Re: [PATCH] net: hamradio: baycom_epp: Mark expected switch
 fall-through
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190729201231.GA7576@embeddedor>
References: <20190729201231.GA7576@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 14:09:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogIkd1c3Rhdm8gQS4gUi4gU2lsdmEiIDxndXN0YXZvQGVtYmVkZGVkb3IuY29tPg0KRGF0
ZTogTW9uLCAyOSBKdWwgMjAxOSAxNToxMjozMSAtMDUwMA0KDQo+IE1hcmsgc3dpdGNoIGNhc2Vz
IHdoZXJlIHdlIGFyZSBleHBlY3RpbmcgdG8gZmFsbCB0aHJvdWdoLg0KPiANCj4gVGhpcyBwYXRj
aCBmaXhlcyB0aGUgZm9sbG93aW5nIHdhcm5pbmcgKEJ1aWxkaW5nOiBpMzg2KToNCj4gDQo+IGRy
aXZlcnMvbmV0L2hhbXJhZGlvL2JheWNvbV9lcHAuYzogSW4gZnVuY3Rpb24goXRyYW5zbWl0ojoN
Cj4gZHJpdmVycy9uZXQvaGFtcmFkaW8vYmF5Y29tX2VwcC5jOjQ5MTo3OiB3YXJuaW5nOiB0aGlz
IHN0YXRlbWVudCBtYXkgZmFsbCB0aHJvdWdoIFstV2ltcGxpY2l0LWZhbGx0aHJvdWdoPV0NCj4g
ICAgIGlmIChpKSB7DQo+ICAgICAgICBeDQo+IGRyaXZlcnMvbmV0L2hhbXJhZGlvL2JheWNvbV9l
cHAuYzo1MDQ6Mzogbm90ZTogaGVyZQ0KPiAgICBkZWZhdWx0OiAgLyogZmFsbCB0aHJvdWdoICov
DQo+ICAgIF5+fn5+fn4NCj4gDQo+IE5vdGljZSB0aGF0LCBpbiB0aGlzIHBhcnRpY3VsYXIgY2Fz
ZSwgdGhlIGNvZGUgY29tbWVudCBpcw0KPiBtb2RpZmllZCBpbiBhY2NvcmRhbmNlIHdpdGggd2hh
dCBHQ0MgaXMgZXhwZWN0aW5nIHRvIGZpbmQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBHdXN0YXZv
IEEuIFIuIFNpbHZhIDxndXN0YXZvQGVtYmVkZGVkb3IuY29tPg0KDQpBcHBsaWVkLg0K
