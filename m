Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F84D23145E
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgG1U7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728728AbgG1U7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:59:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C417C061794;
        Tue, 28 Jul 2020 13:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=e9AmtPTjwOPTOJLBk+VlABZCW3pIcY2QyYl1oRYA5H0=; b=hy49PRS5KBVJ5nV77HmfQ+KBB
        MAP0sm0auMkgfs//TN7EHrkbSNEu9lVNbDtZuVDZ/FztvQmeIphh5ylOb0YuFVEFnZGcUqgVTVnTd
        Ot90cDpd3PBVZAj14fDpOVKblKoNvhCnBaqyZVO858kfktCBAfxur29cEMtiNjJUGTsI1WOefrOwq
        okvWgkj6TPdtyfLYDSjqHcUmLaTLdXBqBeNev7baKy8mc/ypbqUN0/+G8jDs7ik1WkjyKHtZ1G4/y
        ZYFkvda7qx/9N6cmdcNDKyvcWGyCusn5+AhX9KIs02169P7sAuItwWm6f/5/a+7Scwgi+AQ9KvRpt
        3ouyhCtRg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45384)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k0Wgt-0004f7-W9; Tue, 28 Jul 2020 21:59:16 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k0Wgs-0004z5-RG; Tue, 28 Jul 2020 21:59:14 +0100
Date:   Tue, 28 Jul 2020 21:59:14 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org,
        Vikas Singh <vikas.singh@puresoftware.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200728205914.GV1551@shell.armlinux.org.uk>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch>
 <20200727172136.GC8003@bogus>
 <20200728203437.GB1748118@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728203437.GB1748118@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 10:34:37PM +0200, Andrew Lunn wrote:
> Hi Everybody
> 
> So i think it is time to try to bring this discussion to some sort of
> conclusion.
> 
> No ACPI maintainer is willing to ACK any of these patches. Nor are
> they willing to NACK them. ACPI maintainers simply don't want to get
> involved in making use of ACPI in networking.
> 
> I personally don't have the knowledge to do ACPI correctly, review
> patches, point people in the right direction. I suspect the same can
> be said for the other PHY maintainers.
> 
> Having said that, there is clearly a wish from vendors to make use of
> ACPI in the networking subsystem to describe hardware.
> 
> How do we go forward?
> 
> For the moment, we will need to NACK all patches adding ACPI support
> to the PHY subsystem.
> 
> Vendors who really do want to use ACPI, not device tree, probably
> need to get involved in standardisation. Vendors need to submit a
> proposal to UEFI and get it accepted.
> 
> Developers should try to engage with the ACPI maintainers and see
> if they can get them involved in networking. Patches with an
> Acked-by from an ACPI maintainer will be accepted, assuming they
> fulfil all the other usual requirements. But please don't submit
> patches until you do have an ACPI maintainer on board. We don't
> want to spamming the lists with NACKs all the time.

For the record, this statement reflects my position as well (as one
of the named phylib maintainers).  Thanks Andrew.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
