Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB7B1724C5
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgB0RPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:15:15 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40862 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729334AbgB0RPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 12:15:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=noUPQ8VF9BgHXXRmi4Zafg9lbKawS8P8sb9LIKLRyWA=; b=XtHKNl5/arohmn+d0Hb12YLZq
        K/INo0Fy8/F9JtT3GwQgnRdJLjVb5JzuPwQixo5mN73/TWTfHRc+bnlDYGKIu/65eaHA7K6wXI25a
        Qx78mmjK/fVtU1rp2IaWWCatHW7bMoBYHLjDFRQREBbUWZa7mI0hRJp1mKa9vqMK4gFmcAuudJ2ic
        Y8ApC5gPR8rDAqHLxVxldeBGHLwf/HoPtUH+Fgo9mNJRdaotiso1zZUevWpCSWjCiodfrbP7iPFgX
        Rrl4bNQpNoD/OosY50F0MYHCtju28ZYot9n0/A+wEOfpaRVLECUHHQTtlxSOzH4FdxHeEi776rxnO
        hV78Yzq5Q==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:46042)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j7MkY-0006tm-7R; Thu, 27 Feb 2020 17:15:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j7MkU-00018x-Se; Thu, 27 Feb 2020 17:14:58 +0000
Date:   Thu, 27 Feb 2020 17:14:58 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: add dt bindings for
 marvell10g  driver
Message-ID: <20200227171458.GN25745@shell.armlinux.org.uk>
References: <20200227095159.GJ25745@shell.armlinux.org.uk>
 <E1j7FqO-0003sv-Ho@rmk-PC.armlinux.org.uk>
 <20200227170858.GA2831@bogus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227170858.GA2831@bogus>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 11:08:58AM -0600, Rob Herring wrote:
> On Thu, 27 Feb 2020 09:52:36 +0000, Russell King wrote:
> > Add a DT bindings document for the Marvell 10G driver, which will
> > augment the generic ethernet PHY binding by having LED mode
> > configuration.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  .../devicetree/bindings/net/marvell,10g.yaml  | 31 +++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/marvell,10g.yaml
> > 
> 
> My bot found errors running 'make dt_binding_check' on your patch:
> 
> Documentation/devicetree/bindings/display/simple-framebuffer.example.dts:21.16-37.11: Warning (chosen_node_is_root): /example-0/chosen: chosen node must be at root node
> Documentation/devicetree/bindings/net/marvell,10g.example.dts:18.13-23: Warning (reg_format): /example-0/ethernet-phy@0:reg: property has invalid length (4 bytes) (#address-cells == 1, #size-cells == 1)
> Documentation/devicetree/bindings/net/marvell,10g.example.dt.yaml: Warning (pci_device_bus_num): Failed prerequisite 'reg_format'
> Documentation/devicetree/bindings/net/marvell,10g.example.dt.yaml: Warning (i2c_bus_reg): Failed prerequisite 'reg_format'
> Documentation/devicetree/bindings/net/marvell,10g.example.dt.yaml: Warning (spi_bus_reg): Failed prerequisite 'reg_format'

It looks like your bot has made a mistake, or I don't understand the
error messages. It seems to be trying to treat the example as a PCI
device, but it isn't, it is a PHY device.

I don't think that's something I can fix, sorry.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
