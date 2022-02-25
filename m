Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9554C451D
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 14:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbiBYNAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 08:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbiBYNAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 08:00:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FF21DA001
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 05:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC41AB83031
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 13:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78BCEC340F1;
        Fri, 25 Feb 2022 13:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645794012;
        bh=1Z3/fDZCdHcNPCIV3rQPb2uEdzdjLCSfmrY2UL55I8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h3pEJ6mYxw9V2A6AUrNgJhcu/YAWuhmW+ckNdp8HdOVBMMD4zmjVrmNuDZhAM1i6r
         wPvmomMPgpNDMmdnlmE8833jr/Xbc4vGaI8TTe9sRcSiegohnVrjQxGPJvq8uR4mow
         2GfOPpjVyOY25rdkk1vzSH6Dsq6bojQL34yd/L3Oxbg+ReSj1R0PKENu8OV7KNT3Hw
         Ofmt7qHt1JNUrPG1GRHn/rjijrV7RoZlYknFjqbXcGpv02ZA3D8XMTV8XuFblBOERu
         dSIObTYDSArmxdSlfNqI3LfP6DFLhgGYVTIK5D5yvPcE7Re7Qv/2KE25lMq9IWuJUn
         U0PA4uw/hYfRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63AC7E6D4BB;
        Fri, 25 Feb 2022 13:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/6] net: dsa: sja1105: phylink updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164579401240.25347.9088329574692705148.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 13:00:12 +0000
References: <YhjEm/Vu+w1XQpGT@shell.armlinux.org.uk>
In-Reply-To: <YhjEm/Vu+w1XQpGT@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     olteanv@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        f.fainelli@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        kabel@kernel.org, vivien.didelot@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 25 Feb 2022 11:59:23 +0000 you wrote:
> Hi,
> 
> This series updates the phylink implementation in sja1105 to use the
> supported_interfaces bitmap, convert to the mac_select_pcs() interface,
> mark as non-legacy, and get rid of the validation method.
> 
> As a final step, enable switching between SGMII and 2500BASE-X as it
> is a feature that Vladimir desires.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: dsa: sja1105: populate supported_interfaces
    https://git.kernel.org/netdev/net-next/c/a420b757acc4
  - [net-next,2/6] net: dsa: sja1105: remove interface checks
    https://git.kernel.org/netdev/net-next/c/c2b8e1e3d81e
  - [net-next,3/6] net: dsa: sja1105: use .mac_select_pcs() interface
    https://git.kernel.org/netdev/net-next/c/827b4ef2772f
  - [net-next,4/6] net: dsa: sja1105: mark as non-legacy
    https://git.kernel.org/netdev/net-next/c/2d1d548ec144
  - [net-next,5/6] net: dsa: sja1105: convert to phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/9c318be13ca0
  - [net-next,6/6] net: dsa: sja1105: support switching between SGMII and 2500BASE-X
    https://git.kernel.org/netdev/net-next/c/83dc4c2af682

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


