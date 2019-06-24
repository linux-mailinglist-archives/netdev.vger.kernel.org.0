Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC3BA505FD
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 11:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfFXJmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 05:42:44 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59630 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727914AbfFXJmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 05:42:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=H/a7o7NM+nO05o9bp/X9ThGKJR186yctXKFyGZl+Eww=; b=kYwBf7aNgA1Sz6MvtRAIwRL8O
        be5F2f5R9WaFQplWvUQAKXRY/b1HOge8zYJBOzov18O55uNA3M9I3SvHAbeUEu6ZAfA9Ju7bsRQ6z
        8/80AT51DOVBewEKYTu8/pGj+A8ax3tlInljVtlTJ4dp416d5997yhmuRJEbsKaS9bErWV643h+pp
        PqsjSZA+0rOWTpZYvHkNkh6ty8FKQmUq6M2DxVPcexdVRCEpy4s+zAmBGSdE2x0iK+QI2dfERTTQB
        DFt5Q1sGmzG278IlbPJSu1ae3Nfip0X2h0sP2FBRZEjGH6hA+qLgjdYL9E9KH1Sym0idMGqJdfB1S
        a59GJ/h6A==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:59022)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hfLUh-00078P-Sd; Mon, 24 Jun 2019 10:42:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hfLUf-0005y1-Fd; Mon, 24 Jun 2019 10:42:33 +0100
Date:   Mon, 24 Jun 2019 10:42:33 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Raju Thombare <pthombar@cadence.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: Re: [PATCH v4 3/5] net: macb: add support for c45 PHY
Message-ID: <20190624094233.3xick3snqbcm55gu@shell.armlinux.org.uk>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281797-13796-1-git-send-email-pthombar@cadence.com>
 <20190623101252.olfxbls3phgxttcb@shell.armlinux.org.uk>
 <CO2PR07MB24695E11E3931BE2E5664054C1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO2PR07MB24695E11E3931BE2E5664054C1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 06:47:48AM +0000, Parshuram Raju Thombare wrote:
> >Which Clause 45 PHY are you using?
> 
> I am using emulated PHY in our CSP environment.

Concentrated Solar Power?  Chartered Society of Physiotherapy?  Center
for Space Physics?

Sorry, I don't know what a "CSP environment" is in this context, neither
it seems does google.  TLAs in general tend to be bad when it comes to
communication.

However, it seems from that comment that you're not talking about real
hardware.  Is there no real hardware out there supporting 10G mode with
these proposed driver changes yet?

> This is using 10G generic PHY driver, with PHY having compatible = "ethernet-phy-ieee802.3-c45"

The generic 10G PHY driver is really dumb and basic - it only supports
a very basic 10G mode.

> 
> Hi Andrew,
> Can I add your "Reviewed-by" tag for this patch. You added it to this patch in last series.
> 
> Regards,
> Parshuram Thombare
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
