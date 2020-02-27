Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFBDA172537
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgB0Rgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:36:49 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37356 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729232AbgB0Rgt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 12:36:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0F0tK5/ubcWROjWTPQxm6Y15x5cP/M3Yx4UdnWKYU5s=; b=vJqihBENKh82ptrEG8k2m+03Hs
        tf6ULdHn5bXGkWoqJFRY17MR3qEapLlh2RJZ/WBl4zKLI1YzCWGlF/Vjc6MVgFZuwE3OHYVQhdV2b
        C4EUwx9KiAfS6viubwFhiykxps8m0Jjt30ANmwcdE6FFwga6FOrVfXKrz4UvYwYXaA90=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j7N5Q-0006eR-NP; Thu, 27 Feb 2020 18:36:36 +0100
Date:   Thu, 27 Feb 2020 18:36:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        netdev <netdev@vger.kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: add dt bindings for
 marvell10g driver
Message-ID: <20200227173636.GE5245@lunn.ch>
References: <20200227095159.GJ25745@shell.armlinux.org.uk>
 <E1j7FqO-0003sv-Ho@rmk-PC.armlinux.org.uk>
 <CAL_JsqK9SLJKZfGjWu3RCk9Wiof+YdUaMziwOrCw5ZxjMZAq_Q@mail.gmail.com>
 <20200227172608.GO25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227172608.GO25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +    allOf:
> > > +      - $ref: /schemas/types.yaml#/definitions/uint16-array
> > > +      - minItems: 1
> > > +        maxItems: 4
> > > +
> > > +examples:
> > > +  - |
> > > +    ethernet-phy@0 {
> > > +        reg = <0>;
> > 
> > This needs to be under an 'mdio' node with #address-cells and
> > #size-cells set correctly.
> 
> I wish these things were documented somewhere... I'm pretty sure this
> passed validation when I wrote it.

Documentation/devicetree/bindings/net/mdio.yaml

Rob, is there a way to express the hierarchy between yaml files and
properties? Can we say that a phy, as defined by ethernet-phy.yaml
should always be inside an MDIO bus as defined in mdio.yaml?

Thanks
	Andrew
