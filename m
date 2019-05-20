Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B1D2408A
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 20:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfETSjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 14:39:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56190 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbfETSjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 14:39:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 00FE214EB45D7;
        Mon, 20 May 2019 11:39:18 -0700 (PDT)
Date:   Mon, 20 May 2019 11:39:18 -0700 (PDT)
Message-Id: <20190520.113918.1763317826007760957.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     liuhangbin@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] vlan: Mark expected switch fall-through
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190520145105.GA6549@embeddedor>
References: <20190520145105.GA6549@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 May 2019 11:39:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogIkd1c3Rhdm8gQS4gUi4gU2lsdmEiIDxndXN0YXZvQGVtYmVkZGVkb3IuY29tPg0KRGF0
ZTogTW9uLCAyMCBNYXkgMjAxOSAwOTo1MTowNSAtMDUwMA0KDQo+IEluIHByZXBhcmF0aW9uIHRv
IGVuYWJsaW5nIC1XaW1wbGljaXQtZmFsbHRocm91Z2gsIG1hcmsgc3dpdGNoDQo+IGNhc2VzIHdo
ZXJlIHdlIGFyZSBleHBlY3RpbmcgdG8gZmFsbCB0aHJvdWdoLg0KPiANCj4gVGhpcyBwYXRjaCBm
aXhlcyB0aGUgZm9sbG93aW5nIHdhcm5pbmc6DQo+IA0KPiBuZXQvODAyMXEvdmxhbl9kZXYuYzog
SW4gZnVuY3Rpb24goXZsYW5fZGV2X2lvY3RsojoNCj4gbmV0LzgwMjFxL3ZsYW5fZGV2LmM6Mzc0
OjY6IHdhcm5pbmc6IHRoaXMgc3RhdGVtZW50IG1heSBmYWxsIHRocm91Z2ggWy1XaW1wbGljaXQt
ZmFsbHRocm91Z2g9XQ0KPiAgICBpZiAoIW5ldF9lcShkZXZfbmV0KGRldiksICZpbml0X25ldCkp
DQo+ICAgICAgIF4NCj4gbmV0LzgwMjFxL3ZsYW5fZGV2LmM6Mzc2OjI6IG5vdGU6IGhlcmUNCj4g
ICBjYXNlIFNJT0NHTUlJUEhZOg0KPiAgIF5+fn4NCj4gDQo+IFdhcm5pbmcgbGV2ZWwgMyB3YXMg
dXNlZDogLVdpbXBsaWNpdC1mYWxsdGhyb3VnaD0zDQo+IA0KPiBUaGlzIHBhdGNoIGlzIHBhcnQg
b2YgdGhlIG9uZ29pbmcgZWZmb3J0cyB0byBlbmFibGUNCj4gLVdpbXBsaWNpdC1mYWxsdGhyb3Vn
aC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEd1c3Rhdm8gQS4gUi4gU2lsdmEgPGd1c3Rhdm9AZW1i
ZWRkZWRvci5jb20+DQoNCkFsc28gYXBwbGllZCB0byAnbmV0JywgdGhhbmtzLg0K
