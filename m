Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D86E63175C
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 00:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiKTXgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 18:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiKTXgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 18:36:09 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA8C2B613;
        Sun, 20 Nov 2022 15:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aI2jnEgK19wCHQqoMeLWDiWUB6RdVgk21HiT4Yh9Fak=; b=cYz+hH9JTM6DDVFwQJJxm1/mW+
        4U7d5VyO+Na0o05Z9b75x0D4Kq1odfCa5rESy/6fgNMC7pA2w+B0Ja3R44WyaJy0cVsIE8AALcU0T
        /t9evWN/T6aj49iIwdKgvun2RCqmF8a1H5zlG/f6i0HBY6YRgZ04wfp2BiQhj/kZBN1s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1owtqJ-002x8q-Qr; Mon, 21 Nov 2022 00:35:19 +0100
Date:   Mon, 21 Nov 2022 00:35:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH 0/3] add dt configuration for dp83867 led modes
Message-ID: <Y3q5t+1M5A0+FQ0M@lunn.ch>
References: <20221118001548.635752-1-tharvey@gateworks.com>
 <Y3bRX1N0Rp7EDJkS@lunn.ch>
 <CAJ+vNU3P-t3Q1XZrNG=czvFBU7UsCOA_Ap47k9Ein_3VQy_tGw@mail.gmail.com>
 <Y3eEiyUn6DDeUZmg@lunn.ch>
 <CAJ+vNU2pAQh6KKiX5x7hFuVpN68NZjhnzwFLRAzS9YZ8bWm1KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU2pAQh6KKiX5x7hFuVpN68NZjhnzwFLRAzS9YZ8bWm1KA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,T_SPF_HELO_TEMPERROR,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 11:57:00AM -0800, Tim Harvey wrote:
> On Fri, Nov 18, 2022 at 5:11 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > Andrew,
> > >
> > > I completely agree with you but I haven't seen how that can be done
> > > yet. What support exists for a PHY driver to expose their LED
> > > configuration to be used that way? Can you point me to an example?
> >
> > Nobody has actually worked on this long enough to get code merged. e.g.
> > https://lore.kernel.org/netdev/20201004095852.GB1104@bug/T/
> > https://lists.archive.carbon60.com/linux/kernel/3396223
> >
> > This is probably the last attempt, which was not too far away from getting merged:
> > https://patches.linaro.org/project/linux-leds/cover/20220503151633.18760-1-ansuelsmth@gmail.com/
> >
> > I seem to NACK a patch like yours every couple of months. If all that
> > wasted time was actually spent on a common framework, this would of
> > been solved years ago.
> >
> > How important is it to you to control these LEDs? Enough to finish
> > this code and get it merged?
> >
> 
> Andrew,
> 
> Thanks for the links - the most recent attempt does look promising.
> For whatever reason I don't have that series in my mail history so
> it's not clear how I can respond to it.

apt-get install b4

> Ansuel, are you planning on posting a v7 of 'Adds support for PHY LEDs
> with offload triggers' [1]?
> 
> I'm not all that familiar with netdev led triggers. Is there a way to
> configure the default offload blink mode via dt with your series? I
> didn't quite follow how the offload function/blink-mode gets set.

The idea is that the PHY LEDs are just LEDs in the Linux LED
framework. So read Documentation/devicetree/bindings/leds/common.yaml.
The PHY should make use of these standard DT properties, including
linux,default-trigger.

	Andrew
