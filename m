Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD95D7D18F
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbfGaWxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:53:45 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54532 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfGaWxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:53:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ATvYdNztPV3VRoATCZ+XXKdGjFdgKnY+Oq7E+6cYRLw=; b=aLWTKr5D4Rlk7ktmm3LE29Dbo
        /taejBAF/fXWYBc+QVYYMIDzXl057wk3SyDWKz4hs+4iwydnV48UnmAg/XzlUTXhwOUIdnYrHWh0/
        TWYVtv1avZ0FLXQm3YUQU2tYjr44orLV+M/V+ZhoQV3bDFScKO/OTTOMFAIaPnogFjiuG8ThozLND
        tdsnZMyYD3CGn1c5rBlIGRDrN4R282d8kjN05QVoIfOD2Inz1RIm/eToT6V6qRWJPSqewWytQAGLm
        OzOBhKPMd4feDMZu+M5tm5g0jqYDFq2FqDS8oZmuSAXX+PkFIlzTyr+EM50T1csY0ZV1uPbDrJsnc
        F5zemaCyA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:46960)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hsxT5-0005ur-J6; Wed, 31 Jul 2019 23:53:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hsxSy-0003Z5-38; Wed, 31 Jul 2019 23:53:04 +0100
Date:   Wed, 31 Jul 2019 23:53:04 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     soc@kernel.org, linux-arm-kernel@lists.infradead.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 00/14] ARM: move lpc32xx and dove to multiplatform
Message-ID: <20190731225303.GC1330@shell.armlinux.org.uk>
References: <20190731195713.3150463-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731195713.3150463-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 09:56:42PM +0200, Arnd Bergmann wrote:
> For dove, the patches are basically what I had proposed back in
> 2015 when all other ARMv6/ARMv7 machines became part of a single
> kernel build. I don't know what the state is mach-dove support is,
> compared to the DT based support in mach-mvebu for the same
> hardware. If they are functionally the same, we could also just
> remove mach-dove rather than applying my patches.

Well, the good news is that I'm down to a small board support file
for the Dove Cubox now - but the bad news is, that there's still a
board support file necessary to support everything the Dove SoC has
to offer.

Even for a DT based Dove Cubox, I'm still using mach-dove, but it
may be possible to drop most of mach-dove now.  Without spending a
lot of time digging through it, it's impossible to really know.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
