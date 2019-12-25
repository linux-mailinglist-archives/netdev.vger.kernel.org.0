Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32D312A532
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 01:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfLYAPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 19:15:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57994 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbfLYAPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 19:15:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E2D07154CCC3F;
        Tue, 24 Dec 2019 16:15:28 -0800 (PST)
Date:   Tue, 24 Dec 2019 16:15:28 -0800 (PST)
Message-Id: <20191224.161528.379031720244201153.davem@davemloft.net>
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        jacob.e.keller@intel.com, jakub.kicinski@netronome.com,
        mark.rutland@arm.com, mlichvar@redhat.com, m-karicheri2@ti.com,
        robh+dt@kernel.org, willemb@google.com, w-kwok2@ti.com
Subject: Re: [PATCH V8 net-next 00/12] Peer to Peer One-Step time stamping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191224.154713.990847792889689914.davem@davemloft.net>
References: <cover.1576956342.git.richardcochran@gmail.com>
        <20191224.154713.990847792889689914.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Dec 2019 16:15:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogVHVlLCAyNCBE
ZWMgMjAxOSAxNTo0NzoxMyAtMDgwMCAoUFNUKQ0KDQo+IEZyb206IFJpY2hhcmQgQ29jaHJhbiA8
cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPg0KPiBEYXRlOiBTYXQsIDIxIERlYyAyMDE5IDExOjM2
OjI2IC0wODAwDQo+IA0KPj4gVGhpcyBzZXJpZXMgYWRkcyBzdXBwb3J0IGZvciBQVFAgKElFRUUg
MTU4OCkgUDJQIG9uZS1zdGVwIHRpbWUNCj4+IHN0YW1waW5nIGFsb25nIHdpdGggYSBkcml2ZXIg
Zm9yIGEgaGFyZHdhcmUgZGV2aWNlIHRoYXQgc3VwcG9ydHMgdGhpcy4NCj4gIC4uLg0KPiANCj4g
U2VyaWVzIGFwcGxpZWQsIHRoYW5rcyBSaWNoYXJkLg0KDQpBY3R1YWxseSwgSSBoYWQgdG8gcmV2
ZXJ0LiAgUmljaGFyZCwgcGxlYXNlIGZpeCB0aGlzIHdhcm5pbmcgYW5kIHJlc3VibWl0Og0KDQpk
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHhzdy9zcGVjdHJ1bV9wdHAuYzogSW4gZnVu
Y3Rpb24goW1seHN3X3NwX3B0cF9nZXRfbWVzc2FnZV90eXBlc6I6DQpkcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHhzdy9zcGVjdHJ1bV9wdHAuYzo5MTU6Mjogd2FybmluZzogZW51bWVy
YXRpb24gdmFsdWUgoUhXVFNUQU1QX1RYX09ORVNURVBfUDJQoiBub3QgaGFuZGxlZCBpbiBzd2l0
Y2ggWy1Xc3dpdGNoXQ0KICBzd2l0Y2ggKHR4X3R5cGUpIHsNCiAgXn5+fn5+DQo=
