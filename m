Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7A74F46A
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 10:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfFVIlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 04:41:50 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55234 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfFVIlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 04:41:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Z4WJJP5DXJ7hj7JoKOiyJJMScqHInpMDGDpMUQM5v0M=; b=CUlLr2tGCqd56vUpqT/WdZug4
        62dnN40+dbxJRgl4EHdbPabQp2/4HbfAf3r6nVcoejaYChcKJ/JKVxp5TChfef3aeSOidNAqHoQj7
        +cGKdTQh25O93haLSjfDGXapVDxZvjoyrfBJwlciC8QdLjUxXnK2HAEeB1mwY8mSGznrwiY1rWgVp
        /PuS2WgcsWAsifGBnQ2joHJ+rAz/GJZ753pELEjf8X8iAO+LpNDXBvFD1hkkTQTAAMiAas2cvxK8V
        FDQ/vY8pAaWQdQ4TBnx0PgNnWTrgDFR/ynDGjiyD5xGLi1RlRdEmNV/VK/NHyVjykFl/xHVxyCSn5
        UvcQzmc+Q==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:58974)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hebaf-0002PZ-L0; Sat, 22 Jun 2019 09:41:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hebab-00040E-GV; Sat, 22 Jun 2019 09:41:37 +0100
Date:   Sat, 22 Jun 2019 09:41:37 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Raju Thombare <pthombar@cadence.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: Re: [PATCH v3 0/5] net: macb: cover letter
Message-ID: <20190622084137.sdszvzzhs2wbav77@shell.armlinux.org.uk>
References: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
 <20190621131611.GB21188@lunn.ch>
 <CO2PR07MB2469E07AEBF64DFC8A3E3FAFC1E60@CO2PR07MB2469.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO2PR07MB2469E07AEBF64DFC8A3E3FAFC1E60@CO2PR07MB2469.namprd07.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 22, 2019 at 03:18:42AM +0000, Parshuram Raju Thombare wrote:
> Hi Andrew,
> 
> >On Fri, Jun 21, 2019 at 09:33:57AM +0100, Parshuram Thombare wrote:
> >> Hello !
> >>
> >> 2. 0002-net-macb-add-support-for-sgmii-MAC-PHY-interface.patch
> >>    This patch add support for SGMII mode.
> >
> >Hi Parshuram
> >
> >What PHYs are using to test this? You mention TI PHY DP83867, but that seems to
> >be a plain old 10/100/1000 RGMII PHY.
> It is DP83867ISRGZ on VCU118 board. This PHY supports SGMII but driver
> dp83867 doesn't seems to support it, that was the reason previous patch
> set has patch trying to configure PHY in SGMII mode from PCI wrapper driver.

There are several versions of the dp83867 phy supporting various
interface modes.  It seems the driver has been written for the
DP83867IR and DP83867CR family, presumably TI data sheet SNLS484E.
The DP83867E/IS/CS is covered by a separate data sheet, SNLS504B.

Please note that this PHY does not support 2.5G operation in any
mode.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
