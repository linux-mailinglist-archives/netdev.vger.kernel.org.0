Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F55519154
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 00:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243689AbiECWaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 18:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbiECWa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 18:30:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3007B26572;
        Tue,  3 May 2022 15:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wzSAcfRE40Fi3KiTayqJhNT8ONungVIvbk7S+WFZkxk=; b=WSESEmwdVKI3GBmN/zG5YlhX4U
        3VXqVJwH5k0JmjHEMwBVDPUAPvZUq1wyKXm6mBaTiqCXgiEmqcqEW1V0y4KWeWUKIqqDVO8WMIV5c
        e0qryhI9sRzNGLRrjG3+xgRJURBT2fDH+VxDQPKLRwlrNoM368hyEFeEO5drQYKfuzfs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nm0yn-00174K-TK; Wed, 04 May 2022 00:26:49 +0200
Date:   Wed, 4 May 2022 00:26:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>
Subject: Re: [PATCH net-next v2 7/7] net: phy: smsc: Cope with hot-removal in
 interrupt handler
Message-ID: <YnGsKQC1WxihasYs@lunn.ch>
References: <cover.1651574194.git.lukas@wunner.de>
 <95ff93fffa161a7a96604b4dfe2be933fe740785.1651574194.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95ff93fffa161a7a96604b4dfe2be933fe740785.1651574194.git.lukas@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 03, 2022 at 03:15:07PM +0200, Lukas Wunner wrote:
> If reading the Interrupt Source Flag register fails with -ENODEV, then
> the PHY has been hot-removed and the correct response is to bail out
> instead of throwing a WARN splat and attempting to suspend the PHY.
> The PHY should be stopped in due course anyway as the kernel
> asynchronously tears down the device.
> 
> Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
> Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
