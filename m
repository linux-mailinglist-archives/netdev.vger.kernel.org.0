Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0260F69ADF5
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBQOXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBQOXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:23:06 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6402B12BFB;
        Fri, 17 Feb 2023 06:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=c3XB6deeo2L3our++N18t7FNDHHGtpZ317/qmPgF+rw=; b=qT/HvjOYlFZLbUApkz5ridfh27
        e8VVNVNORD7mpnwZpGKkRX/xj4kuN/cJV+fsBWLJq5giuR/V6u8kUWdlYZCVR5a9u2z0UJ+Jv19ma
        /pd9YObI806ufRqd07DUAfg726fgH9kcmYLeuoBF8hnBIhWVRQFNpkv4Mh9Hfl35HBxs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pT1dQ-005IBe-7W; Fri, 17 Feb 2023 15:22:48 +0100
Date:   Fri, 17 Feb 2023 15:22:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     enguerrand.de-ribaucourt@savoirfairelinux.com,
        woojung.huh@microchip.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        edumazet@google.com, linux-usb@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH v2 net] net:usb:lan78xx: fix accessing the LAN7800's
 internal phy specific registers from the MAC driver
Message-ID: <Y++NuMM6EKvtBzeq@lunn.ch>
References: <20230217130900.32757-1-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217130900.32757-1-yuiko.oshino@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 06:09:00AM -0700, Yuiko Oshino wrote:
> Move the LAN7800 internal phy (phy ID  0x0007c132) specific register accesses to the phy driver (microchip.c).
> 
> Fix the error reported by Enguerrand de Ribaucourt in December 2022,
> "Some operations during the cable switch workaround modify the register
> LAN88XX_INT_MASK of the PHY. However, this register is specific to the
> LAN8835 PHY. For instance, if a DP8322I PHY is connected to the LAN7801,
> that register (0x19), corresponds to the LED and MAC address
> configuration, resulting in inappropriate behavior."
> 
> I did not test with the DP8322I PHY, but I tested with an EVB-LAN7800 with the internal PHY.

Please keep you commit message lines less than 80 characters.

> Fixes: 14437e3fa284f465dbbc8611fd4331ca8d60e986 ("lan78xx: workaround of forced 100 Full/Half duplex mode error")

Please use the short hash, not the long.

The Fixes: tag is an exception to the 80 characters rule, it can be as
long as it needs to be.

Otherwise this patch looks good now.

	  Andrew
