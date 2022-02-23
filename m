Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF74B4C12F8
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 13:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240537AbiBWMmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 07:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiBWMmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 07:42:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E423835DD8;
        Wed, 23 Feb 2022 04:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PhH4z0amrVzLHzPRh3MJiOYM1tdzQ0RpCDO/c4DMPjk=; b=pkZ6mQBPITRDkl5DVto72y8Qk3
        Frf2TMEDCwEOluMzypzpQl+YS/4IRQ3RfR3vILlc09rwaZexZ4Eo4ms3TG8zsTSRAax4GKBsaOr3K
        8QOWKnRUFEnt2fAZ/NUi54TWqkR+zf/sERYlvLaOqBfq9ikJRdzo3BUnJ76s9/evuVsDESKdNNAM/
        cgailj2ExUAd5U2omlbkW2Wu7AvOZPLY6UBssdITFRyrgL9fcB0iSdT8Ua7c8pxQ7GzDkqG+MXoIb
        liYOg77L8R1ckasb+jcht+9+yNbjq2LildYEaj940oPbNFW3gsLxm7pTi+3q86GRAfRR0YzUjw3qU
        kccOhonQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57438)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nMqxq-0002ph-BR; Wed, 23 Feb 2022 12:41:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nMqxn-000106-41; Wed, 23 Feb 2022 12:41:47 +0000
Date:   Wed, 23 Feb 2022 12:41:47 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 10/10] net: sfp: add support for fwnode
Message-ID: <YhYriwvHJKjrDQRf@shell.armlinux.org.uk>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-11-clement.leger@bootlin.com>
 <YhPSkz8+BIcdb72R@smile.fi.intel.com>
 <20220222142513.026ad98c@fixe.home>
 <YhYZAc5+Q1rN3vhk@smile.fi.intel.com>
 <888f9f1a-ca5a-1250-1423-6c012ec773e2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <888f9f1a-ca5a-1250-1423-6c012ec773e2@redhat.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 01:02:23PM +0100, Hans de Goede wrote:
> Hi,
> 
> On 2/23/22 12:22, Andy Shevchenko wrote:
> > On Tue, Feb 22, 2022 at 02:25:13PM +0100, Clément Léger wrote:
> >> Le Mon, 21 Feb 2022 19:57:39 +0200,
> >> Andy Shevchenko <andriy.shevchenko@linux.intel.com> a écrit :
> >>
> >>> On Mon, Feb 21, 2022 at 05:26:52PM +0100, Clément Léger wrote:
> >>>> Add support to retrieve a i2c bus in sfp with a fwnode. This support
> >>>> is using the fwnode API which also works with device-tree and ACPI.
> >>>> For this purpose, the device-tree and ACPI code handling the i2c
> >>>> adapter retrieval was factorized with the new code. This also allows
> >>>> i2c devices using a software_node description to be used by sfp code.  
> >>>
> >>> If I'm not mistaken this patch can even go separately right now, since all used
> >>> APIs are already available.
> >>
> >> This patches uses fwnode_find_i2c_adapter_by_node() which is introduced
> >> by "i2c: fwnode: add fwnode_find_i2c_adapter_by_node()" but they can
> >> probably be contributed both in a separate series.
> > 
> > I summon Hans into the discussion since I remember he recently refactored
> > a bit I2C (ACPI/fwnode) APIs. Also he might have an idea about entire big
> > picture approach with this series based on his ACPI experience.
> 
> If I understand this series correctly then this is about a PCI-E card
> which has an I2C controller on the card and behind that I2C-controller
> there are a couple if I2C muxes + I2C clients.

That is what I gathered as well.

> Assuming I did understand the above correctly. One alternative would be
> to simply manually instantiate the I2C muxes + clients using
> i2c_new_client_device(). But I'm not sure if i2c_new_client_device()
> will work for the muxes without adding some software_nodes which
> brings us back to something like this patch-set.

That assumes that an I2C device is always present, which is not always
the case - there are hot-pluggable devices on I2C buses.

Specifically, this series includes pluggable SFP modules, which fall
into this category of "hot-pluggable I2C devices" - spanning several
bus addresses (0x50, 0x51, 0x56). 0x50 is EEPROM like, but not quite
as the top 128 bytes is paged and sometimes buggy in terms of access
behaviour. 0x51 contains a bunch of monitoring and other controls
for the module which again can be paged. At 0x56, there may possibly
be some kind of device that translates I2C accesses to MDIO accesses
to access a PHY onboard.

Consequently, the SFP driver and MDIO translation layer wants access to
the I2C bus, rather than a device.

Now, before ARM was converted to DT, we had ways to cope with
non-firmware described setups like this by using platform devices and
platform data. Much of that ended up deprecated, because - hey - DT
is great and more modern and the old way is disgusting and we want to
get rid of it.

However, that approach locks us into describing stuff in firmware,
which is unsuitable when something like this comes along.

I think what we need is both approaches. We need a way for the SFP
driver (which is a platform_driver) to be used _without_ needing
descriptions in firmware. I think we have that for GPIOs, but for an
I2C bus, We have i2c_get_adapter() for I2C buses, but that needs the
bus number - we could either pass the i2c_adapter or the adapter
number through platform data to the SFP driver.

Or is there another solution to being able to reuse multi-driver
based infrastructure that we have developed based on DT descriptions
in situations such as an add-in PCI card?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
