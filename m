Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C26629796
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 12:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiKOLjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 06:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiKOLjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 06:39:01 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0DB17064;
        Tue, 15 Nov 2022 03:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ctm4PwBv1snqtyqAMApkebcCB0sHmfgq7yaIIzkxXW8=; b=jBpVzVt7mfICokNfDgmScV1L+L
        mqZPmFBdS1+qvD31UunFJUW8CV88m26rBFMchO2QEdd6YFmtMIWxvHK7I3ArirvB9eH/+VOCKqIE8
        iudr6RE+k8n6cOjUzolMeVyig6AE7jROb28nEuS/gFsx1Dpi1KlpXx58eXWR9LxIMfcn6sBePsihU
        d1EOCP980y/hvi26UmvhnEWNhbS4KHymACCtOrOgQ3dKpIXsxkVFWuyg1CYvDVEwAOgnPltYZ5JBi
        OK/IwmZpnvtjZ503VpzqK4mXvFWY8df6XWLUaZXzszQAMgCK2Zws1hhKOcMYGRXKuJUbjxWyezFvM
        iLIjHlnw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35284)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ouuH8-00021j-6Y; Tue, 15 Nov 2022 11:38:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ouuH4-0004jd-5D; Tue, 15 Nov 2022 11:38:42 +0000
Date:   Tue, 15 Nov 2022 11:38:42 +0000
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
Message-ID: <Y3N6Qhf+RLNrr/nW@shell.armlinux.org.uk>
References: <20221115073603.3425396-1-clabbe@baylibre.com>
 <20221115073603.3425396-2-clabbe@baylibre.com>
 <Y3Nj4pA2+WRFvSNd@sirena.org.uk>
 <Y3NnirK0bN71IgCo@Red>
 <Y3NrQffcdGIjS64a@sirena.org.uk>
 <Y3NtKgb0LpWs0RkB@shell.armlinux.org.uk>
 <Y3N1JYVx9tB9pisR@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3N1JYVx9tB9pisR@sirena.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 11:16:53AM +0000, Mark Brown wrote:
> On Tue, Nov 15, 2022 at 10:42:50AM +0000, Russell King (Oracle) wrote:
> > On Tue, Nov 15, 2022 at 10:34:41AM +0000, Mark Brown wrote:
> 
> > > Well, it's not making this maintainer happy :/  If we know what
> > > PHY is there why not just look up the set of supplies based on
> > > the compatible of the PHY?
> 
> > It looks to me like this series fetches the regulators before the PHY
> > is bound to the driver, so what you're proposing would mean that the
> > core PHY code would need a table of all compatibles (which is pretty
> > hard to do, they encode the vendor/device ID, not some descriptive
> > name) and then a list of the regulator names. IMHO that doesn't scale.
> 
> Oh, PHYs have interesting enough drivers to dynamically load
> here? The last time I was looking at MDIO stuff it was all
> running from generic class devices but that was quite a while
> ago.

There's a couple of generic drivers which are used if there isn't a
specific driver available for the vendor/device ID that has either
been probed from the hardware, or discovered encoded in the firmware's
compatible property.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
