Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3707281722
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388023AbgJBPuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgJBPux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:50:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22864C0613D0;
        Fri,  2 Oct 2020 08:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UDJ9ZnphREbFp8lsT7TG//XHyzzzNtLf4BzsnN3c9BY=; b=Dm1/hFMwhGWjG4E1yyJFVPwdg
        pQoENUNGWivGykN6Gi8lbiXNrXFE+JD9vf4TEeuarCGelU3bX4b59fzBh+VJDVbkM7aYRcqzfbcbf
        U9zIuEAl702PSpAkuzm1bKrOlvquwUGlSo4A9U+nkr0BjYOEdoTAUaiSrB4T37YAKDFnT5Ru8o/HS
        p5B8o/zg6COn93bXxh2XgQEiyMmGXRTAas6PL5SyYHbT3KVnBRz+ZFhR2HrET+6ArS2n5dpNCgjGf
        6OoEw+XLW8agE2QllPVy6hAasuLecGAmMX+0TnuvHbKobej1UB1x29bz4WIHxJBYfCjOEGff/ScyL
        xK2OCg1PQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41056)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kONKJ-0006G2-UD; Fri, 02 Oct 2020 16:50:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kONKE-0004Fi-HE; Fri, 02 Oct 2020 16:50:26 +0100
Date:   Fri, 2 Oct 2020 16:50:26 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, nd <nd@arm.com>
Subject: Re: [net-next PATCH v1 3/7] net: phy: Introduce fwnode_get_phy_id()
Message-ID: <20201002155026.GG1551@shell.armlinux.org.uk>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-4-calvin.johnson@oss.nxp.com>
 <11e6b553-675f-8f3d-f9d5-316dae381457@arm.com>
 <679fab8f-d33a-9ce8-1982-788d5f90185e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <679fab8f-d33a-9ce8-1982-788d5f90185e@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 08:14:07AM -0700, Florian Fainelli wrote:
> On 10/2/2020 4:05 AM, Grant Likely wrote:
> > On 30/09/2020 17:04, Calvin Johnson wrote:
> > > Extract phy_id from compatible string. This will be used by
> > > fwnode_mdiobus_register_phy() to create phy device using the
> > > phy_id.
> > > 
> > > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > > ---
> > > 
> > >   drivers/net/phy/phy_device.c | 32 +++++++++++++++++++++++++++++++-
> > >   include/linux/phy.h          |  5 +++++
> > >   2 files changed, 36 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > > index c4aec56d0a95..162abde6223d 100644
> > > --- a/drivers/net/phy/phy_device.c
> > > +++ b/drivers/net/phy/phy_device.c
> > > @@ -9,6 +9,7 @@
> > >   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > +#include <linux/acpi.h>
> > >   #include <linux/bitmap.h>
> > >   #include <linux/delay.h>
> > >   #include <linux/errno.h>
> > > @@ -845,6 +846,27 @@ static int get_phy_c22_id(struct mii_bus *bus,
> > > int addr, u32 *phy_id)
> > >       return 0;
> > >   }
> > > +/* Extract the phy ID from the compatible string of the form
> > > + * ethernet-phy-idAAAA.BBBB.
> > > + */
> > > +int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
> > > +{
> > > +    unsigned int upper, lower;
> > > +    const char *cp;
> > > +    int ret;
> > > +
> > > +    ret = fwnode_property_read_string(fwnode, "compatible", &cp);
> > > +    if (ret)
> > > +        return ret;
> > > +
> > > +    if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
> > > +        *phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
> > > +        return 0;
> > > +    }
> > > +    return -EINVAL;
> > > +}
> > > +EXPORT_SYMBOL(fwnode_get_phy_id);
> > 
> > This block, and the changes in patch 4 duplicate functions from
> > drivers/of/of_mdio.c, but it doesn't refactor anything in
> > drivers/of/of_mdio.c to use the new path. Is your intent to bring all of
> > the parsing in these functions of "compatible" into the ACPI code path?
> > 
> > If so, then the existing code path needs to be refactored to work with
> > fwnode_handle instead of device_node.
> > 
> > If not, then the DT path in these functions should call out to of_mdio,
> > while the ACPI path only does what is necessary.
> 
> Rob has been asking before to have drivers/of/of_mdio.c be merged or at
> least relocated within drivers/net/phy where it would naturally belong. As a
> preliminary step towards ACPI support that would seem reasonable to do.

I think even I have commented on specific functions while reviewing
patches from NXP that the DT/ACPI code should use common bases...

I have been planning that if that doesn't get done, then I'd do it,
but really NXP should do it being the ones adding this infrastructure;
they should do the job properly and not take advantage of volunteers
in the community cleaning up their resulting submissions.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
