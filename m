Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6184155A767
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 08:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiFYGAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 02:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbiFYGAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 02:00:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C3B3DA4B
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 23:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0F01FCE2FBF
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 06:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E21FC341CC;
        Sat, 25 Jun 2022 06:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656136814;
        bh=MPLzFX+ZXke7A0ErWqSLaST52MSFPc8HYlbr1Yi5JJg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YqVIuX2LVSzwr/XsSwr1obdxsM+goWMWUhz58Z5mDTs702lw/dDt3AXHzEWW+OlA4
         +KOjvjF4JvcSUux1CjDnp8V2oCxB8o+NfV71fspULcZj7viR+2HzTQHSzd2FP97urL
         RRMvjDpGnw2dYT6QNvUtBrdKV3HZqggf41ydbquTQleQHeQOPvCFJ4IMgo3fOATYqV
         7Sppe5Exhi9eydD0sL1MIRvf4kDpWPmm/ra2m4acK2KpCyhAvbAekNckdvj0m6RoDs
         xma6akv3en2L3BdVf2AOfR9cSPh990U64SKK7AtKFdwUeKc4nvmgJROp6/iB49Jv+E
         h6crAe9pvf0pg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 536CDE7386C;
        Sat, 25 Jun 2022 06:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: pcs: xpcs: depends on PHYLINK in Kconfig
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165613681433.10048.1576945052531169096.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Jun 2022 06:00:14 +0000
References: <20220623202933.2341938-1-kuba@kernel.org>
In-Reply-To: <20220623202933.2341938-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, lkp@intel.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        rmk+kernel@armlinux.org.uk, boon.leong.ong@intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Jun 2022 13:29:33 -0700 you wrote:
> This is yet another attempt at fixing:
> 
> >> ERROR: modpost: "phylink_mii_c22_pcs_encode_advertisement" [drivers/net/pcs/pcs_xpcs.ko] undefined!
> >> ERROR: modpost: "phylink_mii_c22_pcs_decode_state" [drivers/net/pcs/pcs_xpcs.ko] undefined!
> 
> Switch XPCS to be invisible, as Russell points out it's
> "selected" by its consumers. Drop the dependency on MDIO_BUS
> as "depends" is meaningless on "selected" symbols.
> 
> [...]

Here is the summary with links:
  - [net-next] net: pcs: xpcs: depends on PHYLINK in Kconfig
    https://git.kernel.org/netdev/net-next/c/ebeae54d3a77

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


