Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 827E5172540
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730360AbgB0Rkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:40:49 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41248 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbgB0Rks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 12:40:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=c7nuCpvRTHEsRAsK81Bo4xzkbH8UaLVAL6CWDVJlwJk=; b=Wcg8bY9hlXrY8sFmw3yNN5ngh
        02MLBZo3jc45P42khAwka/XNAcxcMqs9cMnwlMF2IBopxsQ/jrbmZ/HGrBRibckYox/+hUPjCFFBk
        ClVn4DbvRC6ZsIJWi+B4MadEODtRC3dypHwRdlgr8b3qRgWprSXFoC8R0Ci8HKXUvpX0uEaFzaf+Z
        BeBAcZ46C/JWNiPO5FUTph2M2iEMoh0w2P3KwR7q9bGtdIgBk75V+LClOx0s0v1RoNOv4s4lA7gBh
        3M8B9dErkFjxtqKDpKMl9OwyP9ZXMYbhFnfu2urqfTujCSpmMCtBvWWeQk+NcTyE9C46sXUk2WjJM
        ScWuXi2dw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57700)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j7N9O-00071z-1L; Thu, 27 Feb 2020 17:40:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j7N9M-0001A9-Hn; Thu, 27 Feb 2020 17:40:40 +0000
Date:   Thu, 27 Feb 2020 17:40:40 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
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
Message-ID: <20200227174040.GP25745@shell.armlinux.org.uk>
References: <20200227095159.GJ25745@shell.armlinux.org.uk>
 <E1j7FqO-0003sv-Ho@rmk-PC.armlinux.org.uk>
 <CAL_JsqK9SLJKZfGjWu3RCk9Wiof+YdUaMziwOrCw5ZxjMZAq_Q@mail.gmail.com>
 <20200227172608.GO25745@shell.armlinux.org.uk>
 <20200227173636.GE5245@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227173636.GE5245@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 06:36:36PM +0100, Andrew Lunn wrote:
> > > > +    allOf:
> > > > +      - $ref: /schemas/types.yaml#/definitions/uint16-array
> > > > +      - minItems: 1
> > > > +        maxItems: 4
> > > > +
> > > > +examples:
> > > > +  - |
> > > > +    ethernet-phy@0 {
> > > > +        reg = <0>;
> > > 
> > > This needs to be under an 'mdio' node with #address-cells and
> > > #size-cells set correctly.
> > 
> > I wish these things were documented somewhere... I'm pretty sure this
> > passed validation when I wrote it.
> 
> Documentation/devicetree/bindings/net/mdio.yaml

I'm not sure that makes it any more obvious.  Maybe it's obvious to
those who understand yaml, but for the rest of us, it isn't.

> Rob, is there a way to express the hierarchy between yaml files and
> properties? Can we say that a phy, as defined by ethernet-phy.yaml
> should always be inside an MDIO bus as defined in mdio.yaml?

and yes, it isn't even referenced from ethernet-phy.yaml, so how one
would know to even look there.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
