Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E120B18C307
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 23:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgCSWfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 18:35:51 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42109 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbgCSWfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 18:35:51 -0400
Received: by mail-lf1-f67.google.com with SMTP id t21so3001333lfe.9
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 15:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lzI8/7nA+s6X3dOFA/8/KMKAbtd9jvxTx8zVp7VE0k8=;
        b=M03EUWFV+gYg8qS44Glzupp/ne9pA4NosNadaj8UTN9PehWnkFy8XO3yKFsKTtHp0V
         KSldZvoDZyBIOfbzKHt6P3UNNSBTdSckVn1eC5WjXfmW+8B25tCxfOcM/oc6miTZrV9y
         lsan+PFT7eKhN5G3/6mqPz+I/HjHOAKfIuQqGza+uQ48jBICRqi+oiOFCSfg/jSjtXWt
         E5PE4TgyZVTBp3JI37hju9jnD7lNYv1Y5WMvs0sal3tZNW+Td+tKqve4mIA7qqUOnsHl
         KwKed+dQaZDTgO2uUDhEwWD2UbUHJRVSqQEKx7X14ncR3PaJs7C52QpgUZmS8Xa370D9
         to5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lzI8/7nA+s6X3dOFA/8/KMKAbtd9jvxTx8zVp7VE0k8=;
        b=D2+7oDqZ5yS78Fqwmh6Flb443xT7j+yshHJ0Nvh66lpwhgUD5gBZPVz+YxU/1wgM1s
         oNNAb1bFXphGVuDKtm+0GzYLD526eDMFBBQx/MfARLxr2fb0NtRTTwwP51wJZUqZW9hy
         glw0o0SW+DpFuXDBA0kF5/GCL2xLd1PhzstBVPeJEsx54ce64D70W/gDrBBWBszgq76Y
         6gKcalp7ObZj5AsXnPh9lnDZseID/hYKSwXjHOA8uwhK/uL7kdBb4LJuMdrKJClvkHJl
         VGLCY/KP5anU83WRvYkoqwoSEuyRbbw6/XmmoBmjT8Y1DBDjew34zOnkqXgBCfqXHH3c
         sJnA==
X-Gm-Message-State: ANhLgQ2yJJv+qs30tPUhAHBNUaRgBC07e3T6So51ZY67xYsXdjI3vpsV
        gobcF2VPRi6IT2rCkW1A+emy5g==
X-Google-Smtp-Source: ADFU+vui9nOHJY55V1GL7Mqr2QrqNZ/JcehTyPMarunr0z82kdkqGFPkhEunjrfLaoRSXQUJ43MW2Q==
X-Received: by 2002:ac2:41d3:: with SMTP id d19mr3497869lfi.57.1584657346840;
        Thu, 19 Mar 2020 15:35:46 -0700 (PDT)
Received: from wkz-x280 (h-50-180.A259.priv.bahnhof.se. [155.4.50.180])
        by smtp.gmail.com with ESMTPSA id d12sm2203433lfi.86.2020.03.19.15.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 15:35:46 -0700 (PDT)
Date:   Thu, 19 Mar 2020 23:35:44 +0100
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH v2 2/2] net: phy: marvell smi2usb mdio controller
Message-ID: <20200319223544.GA14699@wkz-x280>
References: <20200319135952.16258-1-tobias@waldekranz.com>
 <20200319135952.16258-2-tobias@waldekranz.com>
 <20200319154937.GB27807@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319154937.GB27807@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 04:49:37PM +0100, Andrew Lunn wrote:
> On Thu, Mar 19, 2020 at 02:59:52PM +0100, Tobias Waldekranz wrote:
> > An MDIO controller present on development boards for Marvell switches
> > from the Link Street (88E6xxx) family.
> > 
> > Using this module, you can use the following setup as a development
> > platform for switchdev and DSA related work.
> > 
> >    .-------.      .-----------------.
> >    |      USB----USB                |
> >    |  SoC  |      |  88E6390X-DB  ETH1-10
> >    |      ETH----ETH0               |
> >    '-------'      '-----------------'
> > 
> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> > ---
> > 
> > v1->v2:
> > - Reverse christmas tree ordering of local variables.
> > 
> > ---
> >  MAINTAINERS                    |   1 +
> >  drivers/net/phy/Kconfig        |   7 ++
> >  drivers/net/phy/Makefile       |   1 +
> >  drivers/net/phy/mdio-smi2usb.c | 137 +++++++++++++++++++++++++++++++++
> >  4 files changed, 146 insertions(+)
> >  create mode 100644 drivers/net/phy/mdio-smi2usb.c
> 
> Hi Tobias
> 
> Where does the name mii2usb come from? To me, it seems to be the wrong
> way around, it is USB to MII. I suppose the Marvell Switch team could
> of given it this name, for them the switch is the centre of their
> world, and things connect to it?

The name is indeed coming from Marvell. They use the term SMI over
MDIO in most of their software and documentation. I had the same
reaction to the name regarding the ordering of the terms, but felt it
was best to go with the vendor's choice.

> I'm just wondering if we should actually ignore Marvell and call it
> usb2mii?
> 
> I also think there should be a marvell prefix in the name, since were
> could be other implementations of USB/MII. mvusb2mii?

You're absolutely right that there should be an mv prefix in
there. Calling it usb2mii seems like a misnomer though. At least for
me, MII relates more to the data interface between a MAC and a PHY,
whereas MDIO or SMI refers to the control interface (MDC/MDIO).

How about just mdio-mvusb?

> Do you know how this is implemented? Is it a product you can purchase?
> Or a microcontroller on the board which implements this? It would be
> an interesting product, especially on x86 machines which generally end
> up doing bit-banging because of the lack of drivers using kernel MDIO.

On the 88E6390X-DB, I know that there is a chip by the USB port that
is probably either an MCU or a small FPGA. I can have a closer look at
it when I'm at the office tomorrow if you'd like. I also remember
seeing some docs from Marvell which seemed to indicate that they have
a standalone product providing only the USB-to-MDIO functionality.

The x86 use-case is interesting. It would be even more so if there was
some way of loading a DSA DT fragment so that you could hook it up to
your machine's Ethernet port.

> > +static int smi2usb_probe(struct usb_interface *interface,
> > +			 const struct usb_device_id *id)
> > +{
> > +	struct device *dev = &interface->dev;
> > +	struct mii_bus *mdio;
> > +	struct smi2usb *smi;
> > +	int err = -ENOMEM;
> > +
> > +	mdio = devm_mdiobus_alloc_size(dev, sizeof(*smi));
> > +	if (!mdio)
> > +		goto err;
> > +
> 
> ...
> 
> 
> > +static void smi2usb_disconnect(struct usb_interface *interface)
> > +{
> > +	struct smi2usb *smi;
> > +
> > +	smi = usb_get_intfdata(interface);
> > +	mdiobus_unregister(smi->mdio);
> > +	usb_set_intfdata(interface, NULL);
> > +
> > +	usb_put_intf(interface);
> > +	usb_put_dev(interface_to_usbdev(interface));
> > +}
> 
> I don't know enough about USB. Does disconnect have the same semantics
> remove()? You used devm_mdiobus_alloc_size() to allocate the bus
> structure. Will it get freed after disconnect? I've had USB devices
> connected via flaky USB hubs and they have repeatedly disappeared and
> reappeared. I wonder if in that case you are leaking memory if
> disconnect does not release the memory?

Disclaimer: This is my first ever USB driver.

I assumed that since we're removing 'interface', 'interface->dev' will
be removed as well and thus calling all devm hooks.

> > +	usb_put_intf(interface);
> > +	usb_put_dev(interface_to_usbdev(interface));
> > +}
> 
> Another USB novice question. Is this safe? Could the put of interface
> cause it to be destroyed? Then interface_to_usbdev() is called on
> invalid memory?

That does indeed look scary. I inverted the order of the calls to the
_get_ functions, which I got from the USB skeleton driver. I'll try to
review some other drivers to see if I can figure this out.

> Maybe this should be cross posted to a USB mailing list, so we can get
> the USB aspects reviewed. The MDIO bits seem good to me.

Good idea. Any chance you can help an LKML rookie out? How does one go
about that? Do I simply reply to this thread and add the USB list, or
do I post the patches again as a new series? Any special tags? Is
there any documentation available?

> 	   Andrew

