Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98B162F5A0
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 14:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241716AbiKRNMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 08:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241299AbiKRNMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 08:12:16 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890338B13C;
        Fri, 18 Nov 2022 05:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4Aeu8UwIWgXvC6uSW82BD1GlVbqZxuA9k7NKVXlvkIc=; b=fi6O3mFvI7PWujd16InhbX4q0g
        OqJCOxeSjTFaJdYdanioee16QbVe7lOlfsyEwIMZg7bqsHhyAuwcHyt0WK7T5I37CekR1LYmgit3E
        ZXWanr36/Z8VVHi9m2KvzZRLdytQabOIRqzu3bZEQZh4h9CyUkmy4oi/sfFBGsQt6KNo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ow19f-002nPj-PO; Fri, 18 Nov 2022 14:11:39 +0100
Date:   Fri, 18 Nov 2022 14:11:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH 0/3] add dt configuration for dp83867 led modes
Message-ID: <Y3eEiyUn6DDeUZmg@lunn.ch>
References: <20221118001548.635752-1-tharvey@gateworks.com>
 <Y3bRX1N0Rp7EDJkS@lunn.ch>
 <CAJ+vNU3P-t3Q1XZrNG=czvFBU7UsCOA_Ap47k9Ein_3VQy_tGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU3P-t3Q1XZrNG=czvFBU7UsCOA_Ap47k9Ein_3VQy_tGw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Andrew,
> 
> I completely agree with you but I haven't seen how that can be done
> yet. What support exists for a PHY driver to expose their LED
> configuration to be used that way? Can you point me to an example?

Nobody has actually worked on this long enough to get code merged. e.g.
https://lore.kernel.org/netdev/20201004095852.GB1104@bug/T/
https://lists.archive.carbon60.com/linux/kernel/3396223

This is probably the last attempt, which was not too far away from getting merged:
https://patches.linaro.org/project/linux-leds/cover/20220503151633.18760-1-ansuelsmth@gmail.com/

I seem to NACK a patch like yours every couple of months. If all that
wasted time was actually spent on a common framework, this would of
been solved years ago.

How important is it to you to control these LEDs? Enough to finish
this code and get it merged?

     Andrew
