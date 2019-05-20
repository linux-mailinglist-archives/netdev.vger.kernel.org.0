Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 256B224084
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 20:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfETSiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 14:38:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56176 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfETSiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 14:38:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E584814EC8409;
        Mon, 20 May 2019 11:38:12 -0700 (PDT)
Date:   Mon, 20 May 2019 11:38:12 -0700 (PDT)
Message-Id: <20190520.113812.944855298869290023.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     liuhangbin@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] macvlan: Mark expected switch fall-through
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190520144449.GA4843@embeddedor>
References: <20190520144449.GA4843@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 May 2019 11:38:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogIkd1c3Rhdm8gQS4gUi4gU2lsdmEiIDxndXN0YXZvQGVtYmVkZGVkb3IuY29tPg0KRGF0
ZTogTW9uLCAyMCBNYXkgMjAxOSAwOTo0NDo0OSAtMDUwMA0KDQo+IEluIHByZXBhcmF0aW9uIHRv
IGVuYWJsaW5nIC1XaW1wbGljaXQtZmFsbHRocm91Z2gsIG1hcmsgc3dpdGNoDQo+IGNhc2VzIHdo
ZXJlIHdlIGFyZSBleHBlY3RpbmcgdG8gZmFsbCB0aHJvdWdoLg0KPiANCj4gVGhpcyBwYXRjaCBm
aXhlcyB0aGUgZm9sbG93aW5nIHdhcm5pbmc6DQo+IA0KPiBkcml2ZXJzL25ldC9tYWN2bGFuLmM6
IEluIGZ1bmN0aW9uIKFtYWN2bGFuX2RvX2lvY3RsojoNCj4gZHJpdmVycy9uZXQvbWFjdmxhbi5j
OjgzOTo2OiB3YXJuaW5nOiB0aGlzIHN0YXRlbWVudCBtYXkgZmFsbCB0aHJvdWdoIFstV2ltcGxp
Y2l0LWZhbGx0aHJvdWdoPV0NCj4gICAgaWYgKCFuZXRfZXEoZGV2X25ldChkZXYpLCAmaW5pdF9u
ZXQpKQ0KPiAgICAgICBeDQo+IGRyaXZlcnMvbmV0L21hY3ZsYW4uYzo4NDE6Mjogbm90ZTogaGVy
ZQ0KPiAgIGNhc2UgU0lPQ0dIV1RTVEFNUDoNCj4gICBefn5+DQo+IA0KPiBXYXJuaW5nIGxldmVs
IDMgd2FzIHVzZWQ6IC1XaW1wbGljaXQtZmFsbHRocm91Z2g9Mw0KPiANCj4gVGhpcyBwYXRjaCBp
cyBwYXJ0IG9mIHRoZSBvbmdvaW5nIGVmZm9ydHMgdG8gZW5hYmxlDQo+IC1XaW1wbGljaXQtZmFs
bHRocm91Z2guDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBHdXN0YXZvIEEuIFIuIFNpbHZhIDxndXN0
YXZvQGVtYmVkZGVkb3IuY29tPg0KDQpJJ2xsIGFwcGx5IHRoaXMgdG8gJ25ldCcgc2luY2UgaXQg
d2FzIGludHJvZHVjZWQgYWN0dWFsbHkgYnkgYXJlY2VudA0KY2hhbmdlLg0K
