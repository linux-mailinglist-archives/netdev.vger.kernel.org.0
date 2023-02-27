Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1023B6A4B4F
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjB0Tk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjB0Tkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:40:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBBB25BAB
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 11:40:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F272060F0E
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 19:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD418C433D2;
        Mon, 27 Feb 2023 19:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677526829;
        bh=004NsjyU5kRZtgv4DZxHJq2RdvZ8toDnAoXxMGkAmNM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EflcTRE6nX+qYmYYBOvDwMZ92+z8eD+e/O1zbn5CHjoTc5z9Fb6wHt7uF7mbZEU/k
         gb255MT9t2C2Yub2D3+U0ManzI4gW7tcwZCJ4hg7wsEr4gIayNkKLpfH/npm0IHumP
         u/70cW66+PaxAbfedYvSVL8ELb0UoujBzAlhBNFJSL9BJcY9OD2hRkBKk2YZ64Mx7h
         D8Ympscldv6HSm5RIVSzzD5hPC5bOgCD5f4CIiYg/QfxJJw8VRikBTCS0nL0qd8uHw
         I9YxQZHjm2+ekFEwHR7plR51wdXR1Bmknwb2SfbndZUNOWpeuUv3BnrmdEmIbMQlIo
         L00gfbCPD/7Uw==
Date:   Mon, 27 Feb 2023 11:40:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>,
        Maksim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net 0/3] Regressions in Ocelot switch drivers
Message-ID: <20230227114027.65629ee2@kernel.org>
In-Reply-To: <20230224155235.512695-1-vladimir.oltean@nxp.com>
References: <20230224155235.512695-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023 17:52:32 +0200 Vladimir Oltean wrote:
> These are 3 patches which resolve a regression in the Seville driver,
> one in the Felix driver and a generic one which affects any kernel
> compiled with 2 Kconfig options enabled. All of them have in common my
> lack of attention during review/testing. The patches touch the DSA, MFD
> and MDIO drivers for Ocelot. I think it would be preferable if all
> patches went through netdev (with Lee's Ack).

Applied, thanks!
