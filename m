Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D232277C0F
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 23:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfG0V2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 17:28:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40450 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfG0V2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 17:28:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B614D1534E492;
        Sat, 27 Jul 2019 14:28:36 -0700 (PDT)
Date:   Sat, 27 Jul 2019 14:28:36 -0700 (PDT)
Message-Id: <20190727.142836.359766029975927221.davem@davemloft.net>
To:     opensource@vdorst.com
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: Fix flow control for fixed-link
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190727094011.14024-1-opensource@vdorst.com>
References: <20190727094011.14024-1-opensource@vdorst.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 14:28:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUmVuw6kgdmFuIERvcnN0IDxvcGVuc291cmNlQHZkb3JzdC5jb20+DQpEYXRlOiBTYXQs
IDI3IEp1bCAyMDE5IDExOjQwOjExICswMjAwDQoNCj4gSW4gcGh5bGlua19wYXJzZV9maXhlZGxp
bmsoKSB0aGUgcGwtPmxpbmtfY29uZmlnLmFkdmVydGlzaW5nIGJpdHMgYXJlIEFORA0KPiB3aXRo
IHBsLT5zdXBwb3J0ZWQsIHBsLT5zdXBwb3J0ZWQgaXMgemVyb2VkIGFuZCBvbmx5IHRoZSBzcGVl
ZC9kdXBsZXgNCj4gbW9kZXMgYW5kIE1JSSBiaXRzIGFyZSBzZXQuDQo+IFNvIHBsLT5saW5rX2Nv
bmZpZy5hZHZlcnRpc2luZyBhbHdheXMgbG9zZXMgdGhlIGZsb3cgY29udHJvbC9wYXVzZSBiaXRz
Lg0KPiANCj4gQnkgc2V0dGluZyBQYXVzZSBhbmQgQXN5bV9QYXVzZSBiaXRzIGluIHBsLT5zdXBw
b3J0ZWQsIHRoZSBmbG93IGNvbnRyb2wNCj4gd29yayBhZ2FpbiB3aGVuIGRldmljZXRyZWUgInBh
dXNlIiBpcyBzZXQgaW4gZml4ZXMtbGluayBub2RlIGFuZCB0aGUgTUFDDQo+IGFkdmVydGlzZSB0
aGF0IGlzIHN1cHBvcnRzIHBhdXNlLg0KPiANCj4gUmVzdWx0cyB3aXRoIHRoaXMgcGF0Y2guDQo+
IA0KPiBMZWdlbmQ6DQo+IC0gRFQgPSAnUGF1c2UnIGlzIHNldCBpbiB0aGUgZml4ZWQtbGluayBp
biBkZXZpY2V0cmVlLg0KPiAtIHZhbGlkYXRlKCkgPSDigJhZZXPigJkgbWVhbnMgcGh5bGlua19z
ZXQobWFzaywgUGF1c2UpIGlzIHNldCBpbiB0aGUNCj4gICB2YWxpZGF0ZSgpLg0KPiAtIGZsb3cg
PSByZXN1bHRzIHJlcG9ydGVkIG15IGxpbmsgaXMgVXAgbGluZS4NCj4gDQo+ICstLS0tLSstLS0t
LS0tLS0tLS0rLS0tLS0tLSsNCj4gfCBEVCAgfCB2YWxpZGF0ZSgpIHwgZmxvdyAgfA0KPiArLS0t
LS0rLS0tLS0tLS0tLS0tKy0tLS0tLS0rDQo+IHwgWWVzIHwgWWVzICAgICAgICB8IHJ4L3R4IHwN
Cj4gfCBObyAgfCBZZXMgICAgICAgIHwgb2ZmICAgfA0KPiB8IFllcyB8IE5vICAgICAgICAgfCBv
ZmYgICB8DQo+ICstLS0tLSstLS0tLS0tLS0tLS0rLS0tLS0tLSsNCj4gDQo+IEZpeGVzOiA5NTI1
YWU4Mzk1OWIgKCJwaHlsaW5rOiBhZGQgcGh5bGluayBpbmZyYXN0cnVjdHVyZSIpDQo+IFNpZ25l
ZC1vZmYtYnk6IFJlbsOpIHZhbiBEb3JzdCA8b3BlbnNvdXJjZUB2ZG9yc3QuY29tPg0KDQpBcHBs
aWVkIGFuZCBxdWV1ZWQgdXAgZm9yIC1zdGFibGUsIHRoYW5rcy4NCg==
