Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F194296DEA
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 13:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463193AbgJWLpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 07:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S463142AbgJWLpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 07:45:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1ADCC0613CE;
        Fri, 23 Oct 2020 04:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6lSi9hSUneOKjKoOEI0EQ2kdi/7mfSkeNSqSK8XtkC4=; b=TAYvai1aLUZRqLMGogUsG9bxJ
        Bg3N5E37TNGkH8pn1Lgko3IhgYJ4Jyj7G621KOm4uV/NR7gSpBRwXlNf2S7pmJrkLh4+rO26e7JLn
        CELHyb4EyxC5D6TBYdU0ZnLcSkbUGOSt/iEzplsp+7rUeCTJlaeVZANF7KW5oKx5tuHbJYR9fO7by
        LpsWJrFO4MpjPjIF20JxEMTUX+Bc1wzcQO1KKYG//6mmZAY7ut0QTTHBT17WBiFRk8Jq3Bp4An5/g
        wB2R7dBtggbb7imRg/tC2rwuFbWIoSC8/BWuIUyPaug3eVkLUPmFYxCJlF882zHEFTINHaXmCH9KM
        kZVQ58AiA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49952)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kVvVI-0003Ni-Fu; Fri, 23 Oct 2020 12:45:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kVvVG-0008Q5-DT; Fri, 23 Oct 2020 12:45:02 +0100
Date:   Fri, 23 Oct 2020 12:45:02 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mkl@pengutronix.de, Marek Vasut <marex@denx.de>,
        linux-can@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/6] add initial CAN PHY support
Message-ID: <20201023114502.GC1551@shell.armlinux.org.uk>
References: <20201023105626.6534-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023105626.6534-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 12:56:20PM +0200, Oleksij Rempel wrote:
> - The upcoming CAN SIC and CAN SIC XL PHYs use a different interface to
>   the CAN controller. This means the controller needs to know which type
>   of PHY is attached to configure the interface in the correct mode. Use
>   PHY link for that, too.

Is this dynamic in some form?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
