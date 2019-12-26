Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2097412AF9C
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 00:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfLZXRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 18:17:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44498 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfLZXRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 18:17:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E71815394EE9;
        Thu, 26 Dec 2019 15:17:38 -0800 (PST)
Date:   Thu, 26 Dec 2019 15:17:38 -0800 (PST)
Message-Id: <20191226.151738.464389649649468443.davem@davemloft.net>
To:     geert@linux-m68k.org
Cc:     antoine.tenart@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, robh+dt@kernel.org, frowand.list@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: mdio: Add missing inline to
 of_mdiobus_child_is_phy() dummy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191223100321.7364-1-geert@linux-m68k.org>
References: <20191223100321.7364-1-geert@linux-m68k.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 15:17:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydEBsaW51eC1tNjhrLm9yZz4NCkRhdGU6IE1v
biwgMjMgRGVjIDIwMTkgMTE6MDM6MjEgKzAxMDANCg0KPiBJZiBDT05GSUdfT0ZfTURJTz1uOg0K
PiANCj4gICAgIGRyaXZlcnMvbmV0L3BoeS9tZGlvX2J1cy5jOjIzOg0KPiAgICAgaW5jbHVkZS9s
aW51eC9vZl9tZGlvLmg6NTg6MTM6IHdhcm5pbmc6IKFvZl9tZGlvYnVzX2NoaWxkX2lzX3BoeaIg
ZGVmaW5lZCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWZ1bmN0aW9uXQ0KPiAgICAgIHN0YXRpYyBi
b29sIG9mX21kaW9idXNfY2hpbGRfaXNfcGh5KHN0cnVjdCBkZXZpY2Vfbm9kZSAqY2hpbGQpDQo+
IAkJIF5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+DQo+IA0KPiBGaXggdGhpcyBieSBhZGRpbmcgdGhl
IG1pc3NpbmcgImlubGluZSIga2V5d29yZC4NCj4gDQo+IEZpeGVzOiAwYWE0ZDAxNmMwNDNkMTZh
ICgib2Y6IG1kaW86IGV4cG9ydCBvZl9tZGlvYnVzX2NoaWxkX2lzX3BoeSIpDQo+IFNpZ25lZC1v
ZmYtYnk6IEdlZXJ0IFV5dHRlcmhvZXZlbiA8Z2VlcnRAbGludXgtbTY4ay5vcmc+DQoNCkFwcGxp
ZWQsIHRoYW5rIHlvdS4NCg==
