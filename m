Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5731B4D26
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 21:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgDVTP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 15:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726021AbgDVTP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 15:15:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0014FC03C1A9;
        Wed, 22 Apr 2020 12:15:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 63B70120ED56D;
        Wed, 22 Apr 2020 12:15:28 -0700 (PDT)
Date:   Wed, 22 Apr 2020 12:15:27 -0700 (PDT)
Message-Id: <20200422.121527.1094957328830405366.davem@davemloft.net>
To:     michael@walle.cc
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jdelvare@suse.com, linux@roeck-us.net,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v3 2/3] net: phy: add Broadcom BCM54140 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200420182113.22577-2-michael@walle.cc>
References: <20200420182113.22577-1-michael@walle.cc>
        <20200420182113.22577-2-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 12:15:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Mon, 20 Apr 2020 20:21:12 +0200

> The Broadcom BCM54140 is a Quad SGMII/QSGMII Copper/Fiber Gigabit
> Ethernet transceiver.
> 
> This also adds support for tunables to set and get downshift and
> energy detect auto power-down.
> 
> The PHY has four ports and each port has its own PHY address.
> There are per-port registers as well as global registers.
> Unfortunately, the global registers can only be accessed by reading
> and writing from/to the PHY address of the first port. Further,
> there is no way to find out what port you actually are by just
> reading the per-port registers. We therefore, have to scan the
> bus on the PHY probe to determine the port and thus what address
> we need to access the global registers.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Applied.
