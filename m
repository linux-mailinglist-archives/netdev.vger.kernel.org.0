Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E27A6172838
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 19:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgB0S7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 13:59:18 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42478 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729564AbgB0S7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 13:59:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ipj4drtt9yzUNbt5mpWG89wO/mNsc6SsP6BNeTVfgy0=; b=fMUfXa742omMNQws8oySsIIDI
        TjQapdNKe/wrMtclzDd8CINdU8envubSiWuwUVaxKFuOpgutYuHbp1G8sk3GCjTsmuzu0ncPNdjda
        Pn3/869OO+QVgf8n2RFi8wntpl58LiAOVirHAOaHfctxfF9FVR6joa3CSERy49L7egSYODsLuk/Im
        ka3EmaB0hWddqvGSfESDfOMNjLdyyidtiNU8HN3lDD9OrVYFxni8OzDP+bxj4wYjwoYWTf5CNCkRI
        MqqHwnW0qRx2Ynp7G0CL09nXb/ophZZkoGvGYIiED7Xbz5JJUB/xFinqHMEHGcOZKKquCkiD/Ls2s
        verluUx3g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57726)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j7ONI-0007U7-FA; Thu, 27 Feb 2020 18:59:08 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j7ONE-0001CS-MC; Thu, 27 Feb 2020 18:59:04 +0000
Date:   Thu, 27 Feb 2020 18:59:04 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: add dt bindings for
 marvell10g driver
Message-ID: <20200227185904.GQ25745@shell.armlinux.org.uk>
References: <20200227095159.GJ25745@shell.armlinux.org.uk>
 <E1j7FqO-0003sv-Ho@rmk-PC.armlinux.org.uk>
 <1bcb9a92-d739-6406-6414-783b19bfb66e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bcb9a92-d739-6406-6414-783b19bfb66e@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 09:44:35AM -0800, Florian Fainelli wrote:
> On 2/27/20 1:52 AM, Russell King wrote:
> > Add a DT bindings document for the Marvell 10G driver, which will
> > augment the generic ethernet PHY binding by having LED mode
> > configuration.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> We have been kicking the ball for way too long but there really ought to
> be a standardized binding to configure LED modes for a PHY. Something
> that we previously discussed here without making much progress because
> the LED maintainer was not involved:
> 
> http://patchwork.ozlabs.org/patch/1146609/
> http://patchwork.ozlabs.org/patch/1146610/
> http://patchwork.ozlabs.org/patch/1146611/
> http://patchwork.ozlabs.org/patch/1146612/
> 
> What you are proposing here is just a plain configuration interface via
> Device Tree, which is really borderline. It gets the job done, and it is
> extremely easy to maintain and use because people just stick in their
> register value in there, but boy, what a poor abstraction that is.
> 
> Maybe you can resume where Matthias left and improve upon his patch
> series, if nothing else for the binding and PHY layer integration?

That series is way too simplistic, and would not allow for a
usable configuration for a four-speed PHY such as this one.

The proposed binding in those patches makes the assumption that
the only time that a LED shall blink is when there is traffic.

LED configuration is highly PHY specific.

For the 88x3310, we have around 31 different conditions that the LED
can blink for, or be solid for, the blink rate, and the polarity -
each LED is controlled by 13 bits in total, and then there's the "dual"
modes for bi-color LEDs which cause other of the LED configuration
registers to be ignored.  In other words, it's rather complex.

We could choose to limit the complexity, but then that risks making
it useless for certain boards - such as the Macchiatobin board, where
the dual modes can't be used due to the way the LEDs are wired - see
the last patch, where I describe how the LEDs are configured to
behave, which is the sanest organisation I could come up with which
doesn't result in mixing up various modes.


In any case, I do not wish to add to my patch backlog right now.  Maybe
when the backlog is smaller, I'll consider it, but not before.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
