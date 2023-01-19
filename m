Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6246E674A8F
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjATE2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjATE21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:28:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D08A95B8;
        Thu, 19 Jan 2023 20:28:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C759AB8258A;
        Thu, 19 Jan 2023 15:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62A2EC433EF;
        Thu, 19 Jan 2023 15:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674142218;
        bh=FP4ru6E8Oo1JNr9DNk54UNNPsvn5fuH6fMcjfdBl9lY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bFB7tr99GI5Hq9EBVHmPrjqEzs9dqNrQDOhNaSTZhid/ub9KtLtAbp6OrBy+XmNZd
         Ys9K9qWgQGZpyCFNH5lCqncShoKEdtrNFA266NAB6zpE/qD6ZzYuobsVgof6W0XFC3
         smDWAszIxvhLusZnZm+S1wiJcv/xWWC4lmGNyooLA6sEPZtCMcTIueGF/qexVHMRL0
         GSqDqp59ittarba+p35/hEqdy+bVRKTY6oyU5blSnT90PMfmI5yNaNsMw1XGzUl31k
         gDr0yNHZtLCad1rWNA2lx7AZFozMamdVIkRPdHcdbqG9lVoP8sQvqoLVo+ySOAT4NR
         Eh/O2sbpfBD4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2E094E54D27;
        Thu, 19 Jan 2023 15:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/6] net: phy: Remove probe_capabilities
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167414221817.31934.14400606803161415762.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Jan 2023 15:30:18 +0000
References: <20230116-net-next-remove-probe-capabilities-v2-0-15513b05e1f4@walle.cc>
In-Reply-To: <20230116-net-next-remove-probe-capabilities-v2-0-15513b05e1f4@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, lorenzo@kernel.org,
        matthias.bgg@gmail.com, bryan.whitehead@microchip.com,
        UNGLinuxDriver@microchip.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, joel@jms.id.au, andrew@aj.id.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-aspeed@lists.ozlabs.org, andrew@lunn.ch,
        jesse.brandeburg@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 18 Jan 2023 11:01:35 +0100 you wrote:
> With all the drivers which used .probe_capabilities converted to the
> new c45 MDIO access methods, we can now decide based upon these whether
> a bus driver supports c45 and we can get rid of the not widely used
> probe_capabilites.
> 
> Unfortunately, due to a now broader support of c45 scans, this will
> trigger a bug on some boards with a (c22-only) Micrel PHY. These PHYs
> don't ignore c45 accesses correctly, thinking they are addressed
> themselves and distrupt the MDIO access. To avoid this, a blacklist
> for c45 scans is introduced.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/6] net: mdio: Move mdiobus_scan() within file
    https://git.kernel.org/netdev/net-next/c/81d874e7c84e
  - [net-next,v2,2/6] net: mdio: Rework scanning of bus ready for quirks
    https://git.kernel.org/netdev/net-next/c/d41e127757f3
  - [net-next,v2,3/6] net: mdio: Add workaround for Micrel PHYs which are not C45 compatible
    https://git.kernel.org/netdev/net-next/c/348659337485
  - [net-next,v2,4/6] net: mdio: scan bus based on bus capabilities for C22 and C45
    https://git.kernel.org/netdev/net-next/c/1a136ca2e089
  - [net-next,v2,5/6] net: phy: Decide on C45 capabilities based on presence of method
    https://git.kernel.org/netdev/net-next/c/fbfe97597c77
  - [net-next,v2,6/6] net: phy: Remove probe_capabilities
    https://git.kernel.org/netdev/net-next/c/da099a7fb13d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


