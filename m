Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACF850BB05
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449122AbiDVPDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449188AbiDVPDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:03:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEFA1EADD
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=eqPmiPUKWMwCVShjXPYp4+CGZAFOhveuCqk+2i/0fds=; b=Bp
        3XZrVixAu9x2rirP0uw+ZuglXim7601HMrH74XCStrEHJmNkRHe3uL2nfXrtUMPQDwL6KdXNOYW/D
        84RZ0dHo7M+UbwKw+1WJg3+xIjUWBy5lHHdOHqCCOi4sscQt/+3r7y9lAz3omwqojHNVwxkad1Lzl
        OeOs1Z4YvvO9XNk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nhulT-00Gzdq-W4; Fri, 22 Apr 2022 17:00:08 +0200
Date:   Fri, 22 Apr 2022 17:00:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lasse Johnsen <lasse@timebeat.app>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        Gordon Hollingworth <gordon@raspberrypi.com>,
        Ahmad Byagowi <clk@fb.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next] 1588 support on bcm54210pe
Message-ID: <YmLC98NMfHUxwPF6@lunn.ch>
References: <928593CA-9CE9-4A54-B84A-9973126E026D@timebeat.app>
 <YmBc2E2eCPHMA7lR@lunn.ch>
 <C6DCE6EC-926D-4EDF-AFE9-F949C0F55B7F@timebeat.app>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C6DCE6EC-926D-4EDF-AFE9-F949C0F55B7F@timebeat.app>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 03:21:16PM +0100, Lasse Johnsen wrote:
> Hi Andrew,
> 
> > On 20 Apr 2022, at 20:19, Andrew Lunn <andrew@lunn.ch> wrote:
> > 
> > On Wed, Apr 20, 2022 at 03:03:26PM +0100, Lasse Johnsen wrote:
> >> Hello,
> >> 
> >> 
> >> The attached set of patches adds support for the IEEE1588 functionality on the BCM54210PE PHY using the Linux Kernel mii_timestamper interface. The BCM54210PE PHY can be found in the Raspberry PI Compute Module 4 and the work has been undertaken by Timebeat.app on behalf of Raspberry PI with help and support from the nice engineers at Broadcom.
> > 
> > Hi Lasse
> > 
> > There are a few process issues you should address.
> > 
> > Please wrap your email at about 80 characters.

Still not wrapped. Kernel developers tend to be old school, still
believe a terminal is 80 characters wide, and has 25 lines, just like
the VT100 they grew up with. It can be hard to get some email clients
to do this correctly, which is why most use mutt.

> > Please take a read of
> > 
> > https://www.kernel.org/doc/html/latest/process/submitting-patches.html
> > 
> > and
> > 
> > https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#netdev-faq
> > 
> > It is a bit of a learning curve getting patches accepted, and you have
> > to follow the processes defined in these documents.
> 
> I have read the documents, I understand about 10% of them and I am considering jumping off a tall building :-)

As i said, it is a learning curve, but we are here to help.

> I’ve changed the subject of the email. How did I do?

I step in the right direction.

git log --oneline drivers/net/phy/broadcom.c
bf8bfc4336f7 net: phy: broadcom: Fix brcm_fet_config_init()
d15c7e875d44 net: phy: broadcom: hook up soft_reset for BCM54616S
72e78d22e152 net: phy: broadcom: Utilize appropriate suspend for BCM54810/11
38b6a9073007 net: phy: broadcom: Wire suspend/resume for BCM50610 and BCM50610M
d6da08ed1425 net: phy: broadcom: Add IDDQ-SR mode
8dc84dcd7f74 net: phy: broadcom: Enable 10BaseT DAC early wake
ad4e1e48a629 net: phy: broadcom: re-add check for PHY_BRCM_DIS_TXCRXC_NOENRGY on the BCM54811 PHY
5a32fcdb1e68 net: phy: broadcom: Add statistics for all Gigabit PHYs
b1dd9bf688b0 net: phy: broadcom: Fix RGMII delays for BCM50160 and BCM50610M

The prefix "net: phy: broadcom" helps get the right people to review
your patch. Florian will be looking for anything "broadcom". I look
for anything "phy".

> Ok. I was asked by Florian to put the Broadcom maintainers in Cc so I will do this to begin with.

There is a tool to help you get the correct people to send patches to:

./scripts/get_maintainer.pl <FILENAME>.patch

and it will give you something like:

Florian Fainelli <f.fainelli@gmail.com> (supporter:BROADCOM ETHERNET PHY DRIVERS)
Andrew Lunn <andrew@lunn.ch> (maintainer:ETHERNET PHY LIBRARY)
Heiner Kallweit <hkallweit1@gmail.com> (maintainer:ETHERNET PHY LIBRARY)
Russell King <linux@armlinux.org.uk> (reviewer:ETHERNET PHY LIBRARY)
"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING DRIVERS)
Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS)
Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING DRIVERS)
bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY DRIVERS)
netdev@vger.kernel.org (open list:BROADCOM ETHERNET PHY DRIVERS)
linux-kernel@vger.kernel.org (open list)

> >> +obj-$(CONFIG_BCM54120PE_PHY)	+= bcm54210pe_ptp.o
> > 
> > How specific is this code to the bcm54210pe? Should it work for any
> > bcm54xxx PHY? You might want to name this file broadcom_ptp.c if it
> > will work with any PHY supported by broadcom.c.
> 

> I am confident that this code is relevant exclusively to the
> BCM54210PE. It will not even work with the BCM54210, BCM54210S and
> BCM54210SE PHYs.

Florian can probably tell us more, but often hardware like this is
shared by multiple devices. If it is, you might want to use a more
generic prefix.

> >> +static bool bcm54210pe_fetch_timestamp(u8 txrx, u8 message_type, u16 seq_id, struct bcm54210pe_private *private, u64 *timestamp)
> >> +{
> >> +	struct bcm54210pe_circular_buffer_item *item; 
> >> +	struct list_head *this, *next;
> >> +
> >> +	u8 index = (txrx * 4) + message_type;
> >> +
> >> +	if(index >= CIRCULAR_BUFFER_COUNT)
> >> +	{
> >> +		return false;
> >> +	}
> > 
> > Please run your code through ./scripts/checkpatch.pl. You will find
> > the code has a number of code style issues which need cleaning up.
 
> I am about to respond to Richard's mail with an amended set of
> patches which is much cleaner. checkpatch now complains only about a
> Signed-off line and asks if Maintainers needs updating because I’ve
> added a file (I guess it probably does).

Signed-off-by is important. Without it, your patch will not get
accepted. Did a number of people write the code? You might need
Signed-off-by: from each of them, or you need to use
Co-Developed-by.

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by

Please try to use

git format-patch

and

git send-email

when sending your updated patches. It is a good idea to pass
--cover-letter to git format-patch, and give a 'big picture'
explanation in patch 0/X, along with a list of what you have changed
since the last version. Please also remember to put "v2: in the
subject, "patch net-next v2", so we can keep track of the different
versions.

> >> +#if IS_ENABLED (CONFIG_BCM54120PE_PHY)
> >> +{
> >> +	.phy_id		= PHY_ID_BCM54213PE,
> >> +	.phy_id_mask	= 0xffffffff,
> >> +        .name           = "Broadcom BCM54210PE",
> >> +        /* PHY_GBIT_FEATURES */
> >> +        .config_init    = bcm54xx_config_init,
> >> +        .ack_interrupt  = bcm_phy_ack_intr,
> >> +        .config_intr    = bcm_phy_config_intr,
> >> +	.probe		= bcm54210pe_probe,
> >> +#elif
> >> +{ 
> >> 	.phy_id		= PHY_ID_BCM54213PE,
> >> 	.phy_id_mask	= 0xffffffff,
> >> 	.name		= "Broadcom BCM54213PE",
> >> @@ -786,6 +804,7 @@ static struct phy_driver broadcom_drivers[] = {
> >> 	.config_init	= bcm54xx_config_init,
> >> 	.ack_interrupt	= bcm_phy_ack_intr,
> >> 	.config_intr	= bcm_phy_config_intr,
> >> +#endif
> > 
> > Don't replace the existing entry, extend it with your new
> > functionality.
 

> Is what you propose possible? Isn’t the issue here that the two PHYs
> (54213PE and 54210PE) present themselves with the same phy ID?

Ah, they should not do that. There are solutions to this, but lets
leave this as is for the moment. Lets get other issues solved first.

      Andrew
