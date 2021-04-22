Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194EB368443
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236527AbhDVP5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:57:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36046 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236333AbhDVP5H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 11:57:07 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZbgh-000W0f-VR; Thu, 22 Apr 2021 17:56:19 +0200
Date:   Thu, 22 Apr 2021 17:56:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/3] net: ethernet: ixp4xx: Add DT bindings
Message-ID: <YIGco30TpBiyZLgD@lunn.ch>
References: <20210419225133.2005360-1-linus.walleij@linaro.org>
 <YH4tsFtGJUMf2BFS@lunn.ch>
 <CACRpkdbppvaNUXE9GD_UXDrB8SJA5qv7wrQ1dj5E4ySU_6bG7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbppvaNUXE9GD_UXDrB8SJA5qv7wrQ1dj5E4ySU_6bG7w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 05:39:07PM +0200, Linus Walleij wrote:
> On Tue, Apr 20, 2021 at 3:26 AM Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > > +      mdio {
> > > +        #address-cells = <1>;
> > > +        #size-cells = <0>;
> > > +        phy1: phy@1 {
> > > +          #phy-cells = <0>;
> >
> > Hi Linus
> >
> > phy-cells is not part of the Ethernet PHY binding.
> 
> Nevertheless:
> 
>   CHECK   Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.example.dt.yaml
> /var/linus/linux-nomadik/build-ixp4/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.example.dt.yaml:
> phy@1: '#phy-cells' is a required property
>     From schema:
> /home/linus/.local/lib/python3.9/site-packages/dtschema/schemas/phy/phy-provider.yaml
> 
> It has been hardcoded as required into the dtschema python package.
> Looks like this:
> 
> properties:
>   $nodename:
>     pattern: "^(|usb-|usb2-|usb3-|pci-|pcie-|sata-)phy(@[0-9a-f,]+)*$"
> 
>   "#phy-cells": true
> 
>   phy-supply: true
> 
> required:
>   - "#phy-cells"
> 
> additionalProperties: true
> 
> If this is wrong I bet Rob needs to hear about it.

That is the wrong sort of PHY. That is a generic PHY, not a PHY, aka
Ethernet PHY. Maybe you need to change the label to ethernet-phy ?

	 Andrew
