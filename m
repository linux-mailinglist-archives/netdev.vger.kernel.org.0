Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C4C27D611
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 20:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgI2Sr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 14:47:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34180 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728129AbgI2Sr0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 14:47:26 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNKep-00Gn8B-Pq; Tue, 29 Sep 2020 20:47:23 +0200
Date:   Tue, 29 Sep 2020 20:47:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Igor Russkikh <irusskikh@marvell.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/3] net: atlantic: phy tunables from mac driver
Message-ID: <20200929184723.GE3996795@lunn.ch>
References: <20200929161307.542-1-irusskikh@marvell.com>
 <20200929170413.GA3996795@lunn.ch>
 <20200929103320.6a5de6f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929103320.6a5de6f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Do you mean report supported range via extack?

Yes.

811ac400ea33 ("net: phy: dp83869: Add speed optimization feature")

was merged recently. It has:

+       default:
+               phydev_err(phydev,
+                          "Downshift count must be 1, 2, 4 or 8\n");
+               return -EINVAL;

and there are more examples in PHY drivers where it would be good to
tell the uses what the valid values are. I guess most won't see this
kernel message, but if netlink ethtool printed:

Invalid Argument: Downshift count must be 1, 2, 4 or 8

it would be a lot more user friendly.

   Andrew
