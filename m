Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5EBC79C4D
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 00:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfG2WNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 18:13:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40290 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfG2WNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 18:13:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D3C3B14EB2D9F;
        Mon, 29 Jul 2019 15:13:32 -0700 (PDT)
Date:   Mon, 29 Jul 2019 15:13:28 -0700 (PDT)
Message-Id: <20190729.151328.1578011130589820578.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        keescook@chromium.org
Subject: Re: [PATCH] net: smc911x: Mark expected switch fall-through
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190729221016.GA17610@embeddedor>
References: <20190729221016.GA17610@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 15:13:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogIkd1c3Rhdm8gQS4gUi4gU2lsdmEiIDxndXN0YXZvQGVtYmVkZGVkb3IuY29tPg0KRGF0
ZTogTW9uLCAyOSBKdWwgMjAxOSAxNzoxMDoxNiAtMDUwMA0KDQo+IE1hcmsgc3dpdGNoIGNhc2Vz
IHdoZXJlIHdlIGFyZSBleHBlY3RpbmcgdG8gZmFsbCB0aHJvdWdoLg0KPiANCj4gVGhpcyBwYXRj
aCBmaXhlcyB0aGUgZm9sbG93aW5nIHdhcm5pbmcgKEJ1aWxkaW5nOiBhcm0pOg0KPiANCj4gZHJp
dmVycy9uZXQvZXRoZXJuZXQvc21zYy9zbWM5MTF4LmM6IEluIGZ1bmN0aW9uIKFzbWM5MTF4X3Bo
eV9kZXRlY3SiOg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zbXNjL3NtYzkxMXguYzo2Nzc6Nzog
d2FybmluZzogdGhpcyBzdGF0ZW1lbnQgbWF5IGZhbGwgdGhyb3VnaCBbLVdpbXBsaWNpdC1mYWxs
dGhyb3VnaD1dDQo+ICAgICBpZiAoY2ZnICYgSFdfQ0ZHX0VYVF9QSFlfREVUXykgew0KPiAgICAg
ICAgXg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zbXNjL3NtYzkxMXguYzo3MTU6Mzogbm90ZTog
aGVyZQ0KPiAgICBkZWZhdWx0Og0KPiAgICBefn5+fn5+DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBH
dXN0YXZvIEEuIFIuIFNpbHZhIDxndXN0YXZvQGVtYmVkZGVkb3IuY29tPg0KDQpBcHBsaWVkLg0K
