Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB64469CF0F
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 15:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbjBTOKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 09:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbjBTOKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 09:10:48 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658A01E9D0;
        Mon, 20 Feb 2023 06:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QeqMr1RQzKKjaHrxebtdg67NYW9R1AESv+cr2SYkryY=; b=UIDjnVvax3wfqyLEXYODpU6Ucn
        sihlcwAfF+3uXO6M1FBqSbRvvUuogzN98VzybfOjGEZDx4OE2NByVI5Qcn30nUelG+DzV2DAEakUA
        eLCO1BP9bxm5l3z0OWcgbryASjfp4IYTgsf0F93WrfNZIoHw7M7jR3NpdKz88P3oHjsVIrybtGT+J
        wzNes7OAbrx70Oh5ogbk7uPks9jwAtz+OdE4M4TkNfUKGYlK6UHCULQ6nB73PBun2oV7qMA6+J7/j
        PgUnXjP/mW5j0ELgacIAbS1VU0HNCHOE9GUfInbKiP4TN5/G/NLjx0nvC5HIVBLoB+jilH40vkwDd
        DrXzpvAg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35298)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pU6ry-0004aC-Vy; Mon, 20 Feb 2023 14:10:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pU6ry-0001HB-BC; Mon, 20 Feb 2023 14:10:18 +0000
Date:   Mon, 20 Feb 2023 14:10:18 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/4] net: phy: c45: add
 genphy_c45_an_config_eee_aneg() function
Message-ID: <Y/N/SnrVZvpdRm1D@shell.armlinux.org.uk>
References: <20230220135605.1136137-1-o.rempel@pengutronix.de>
 <20230220135605.1136137-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220135605.1136137-3-o.rempel@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 02:56:03PM +0100, Oleksij Rempel wrote:
> Add new genphy_c45_an_config_eee_aneg() function and replace some of
> genphy_c45_write_eee_adv() calls. This will be needed by the next patch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
