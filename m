Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9363629627
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237652AbiKOKnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiKOKnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:43:11 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD0F25C51;
        Tue, 15 Nov 2022 02:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=B85cuMRk7m/GxUw8KclvU5Eto26IVRvj2aMlFbVY1SU=; b=MS5yRjBVqNX8Cz7qZ346BZzJEO
        AFtoeic2FvsFskee3v2ZQRh3/japbhQiR5YrJ4/9KArJwNO5p0NU9rR3R+tr+z91ElT5UaRCAhApX
        sAFKZ2zfPaKEenDMRdaw48TZqmfO4OuYRNApSXCZB5hTQ1CLXomRywfBfV5a/NyF9Z8P3zKeaH2fq
        gGtqWJdPJ8NNDzxvtNaZv2KeLzuPciybCvHrLlsMmbS3xAL/ViJNW6kSrFMzL9fvhTJjeTW9LXX/a
        B/xPE0BtvgrPvWWvm5nn0vCGuoAGv7cQ674hyPc57SoaaQCxhMqRdqY/TiUDXjSmVDZ4knGYd/M9e
        XIGE2K5w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35282)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1outP4-0001vu-6Q; Tue, 15 Nov 2022 10:42:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1outP0-0004iD-2t; Tue, 15 Nov 2022 10:42:50 +0000
Date:   Tue, 15 Nov 2022 10:42:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Mark Brown <broonie@kernel.org>
Cc:     Corentin LABBE <clabbe@baylibre.com>, andrew@lunn.ch,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, pabeni@redhat.com,
        robh+dt@kernel.org, samuel@sholland.org, wens@csie.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        netdev@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v4 1/3] regulator: Add of_regulator_bulk_get_all
Message-ID: <Y3NtKgb0LpWs0RkB@shell.armlinux.org.uk>
References: <20221115073603.3425396-1-clabbe@baylibre.com>
 <20221115073603.3425396-2-clabbe@baylibre.com>
 <Y3Nj4pA2+WRFvSNd@sirena.org.uk>
 <Y3NnirK0bN71IgCo@Red>
 <Y3NrQffcdGIjS64a@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y3NrQffcdGIjS64a@sirena.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 10:34:41AM +0000, Mark Brown wrote:
> On Tue, Nov 15, 2022 at 11:18:50AM +0100, Corentin LABBE wrote:
> > Le Tue, Nov 15, 2022 at 10:03:14AM +0000, Mark Brown a écrit :
> 
> > > What's the use case - why would a device not know which supplies
> > > it requires?  This just looks like an invitation to badly written
> > > consumers TBH.
> 
> > The device know which supply it have, but I found only this way to made all maintainers happy.
> > See https://lore.kernel.org/netdev/0518eef1-75a6-fbfe-96d8-bb1fc4e5178a@linaro.org/t/#m7a2e012f4c7c7058478811929774ab2af9bfcbf6
> 
> Well, it's not making this maintainer happy :/  If we know what
> PHY is there why not just look up the set of supplies based on
> the compatible of the PHY?

It looks to me like this series fetches the regulators before the PHY
is bound to the driver, so what you're proposing would mean that the
core PHY code would need a table of all compatibles (which is pretty
hard to do, they encode the vendor/device ID, not some descriptive
name) and then a list of the regulator names. IMHO that doesn't scale.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
