Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094C64D35EC
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbiCIRCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236395AbiCIRBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:01:11 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7C115928B;
        Wed,  9 Mar 2022 08:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=+yVc4lT85o1cuu77koQCp0+qteak8KnIM+VNXd03Ekw=; b=IB
        K6LKavHA1a/ZLtGJyveZDDQdvIYXSmW3d6rWdbrcmbRrfJmJCvzBgeHeJFCe3QsV5UScw/bX3O7xy
        /yz4ypYcB1GZgDg7v6HrP7mKdd5d22XSMgP9WacziPDgTiDLCLr9eBXso5tGBPV2qvhMMPHnxBUz0
        OaGyY40d0FBslb0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nRzUB-00A03B-T5; Wed, 09 Mar 2022 17:48:27 +0100
Date:   Wed, 9 Mar 2022 17:48:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Andrew F . Davis" <afd@ti.com>, Dan Murphy <dmurphy@ti.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: Re: [PATCH] net: phy: DP83822: clear MISR2 register to disable
 interrupts
Message-ID: <YijaWxjDESZRrHXQ@lunn.ch>
References: <20220309142228.761153-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220309142228.761153-1-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 03:22:28PM +0100, Clément Léger wrote:
> MISR1 was cleared twice but the original author intention was probably
> to clear MISR1 & MISR2 to completely disable interrupts. Fix it to
> clear MISR2.
> 
> Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
