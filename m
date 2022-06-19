Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB47755098C
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 11:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiFSJuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 05:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiFSJuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 05:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4387AE7C
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 02:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B61660FEA
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 09:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA085C3411D;
        Sun, 19 Jun 2022 09:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655632212;
        bh=mllP//nT0b61QFUV8wbCt30UH7A5VkFkgRsntOckt/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RMElr7kvEiWI/Y2TL2Rk7XPF5oQd5OVWlF1hBrSb1ww1lCFoGMt61WI78Vzl9QZLd
         5Yfll2nWKCuWAGKluSK7yauvLG2Sf0Gc59toD5kHnzonbJWBfowXxqd/o9eCdrN1BH
         hjy6Te8Kt0r/v+MbceJWwjcG0/laUkzvSQnvsOTNiAK2QfLJq93uEeyCtGk9CgVFNw
         AKmoDkkn5F6x7wTetE/5KIltlngI4k0RWsbezQgCtNtUDpkaAW/a4WUdoXNGgu8nCW
         dJp293qPk3J3jsP0HFi7L/lV2gBggfdnjaqqDU/UgOM6rtuFNF3ZOAQvPxJmtwD7Vr
         TxV/hvZbaeeKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AE9D7E7387E;
        Sun, 19 Jun 2022 09:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] introduce mii_bmcr_encode_fixed()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165563221271.22167.15993792118484102358.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Jun 2022 09:50:12 +0000
References: <Yq2iMpbsux5wEM54@shell.armlinux.org.uk>
In-Reply-To: <Yq2iMpbsux5wEM54@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, Jose.Abreu@synopsys.com,
        netdev@vger.kernel.org, pabeni@redhat.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 18 Jun 2022 11:00:18 +0100 you wrote:
> Hi,
> 
> While converting the mv88e6xxx driver to phylink pcs, it has been
> noticed that we've started to have repeated cases where we convert a
> speed and duplex to a BMCR value.
> 
> Rather than open coding this in multiple locations, let's provide a
> helper for this - in linux/mii.h. This helper not only takes care of
> the standard 10, 100 and 1000Mbps encodings, but also includes
> 2500Mbps (which is the same as 1000Mbps) for those users who require
> that encoding as well. Unknown speeds will be encoded to 10Mbps, and
> non-full duplexes will be encoded as half duplex.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: mii: add mii_bmcr_encode_fixed()
    https://git.kernel.org/netdev/net-next/c/bdb6cfe7512f
  - [net-next,2/4] net: phy: use mii_bmcr_encode_fixed()
    https://git.kernel.org/netdev/net-next/c/f28a602b285e
  - [net-next,3/4] net: phy: marvell: use mii_bmcr_encode_fixed()
    https://git.kernel.org/netdev/net-next/c/e62dbaff4bc2
  - [net-next,4/4] net: pcs: pcs-xpcs: use mii_bmcr_encode_fixed()
    https://git.kernel.org/netdev/net-next/c/449b7a15200a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


