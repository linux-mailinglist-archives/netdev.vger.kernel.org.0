Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E804C660C39
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 04:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbjAGDkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 22:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjAGDkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 22:40:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E47A392CF;
        Fri,  6 Jan 2023 19:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8E3161FD0;
        Sat,  7 Jan 2023 03:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED967C433EF;
        Sat,  7 Jan 2023 03:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673062816;
        bh=03/0uSF//ZjR3l96pCWsMFZupR/B/mAAKueX6kQfr3g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X85cQ30O65NJn09H+cWSO0vaTu0Dvrjr3AiisgxJwf693Ijd4sKEaeb0aGV6bn5zF
         CjcIFEwHLaxkwzkJPyu+ZW7DQ8UDXzmv3wlXRPxxVCVjrBuHYZ9h0TmmLziPpshQSe
         Jg+ngAZ9Sa32DmiN9pKLN6abNvy3tKOFQVwTdEeHv7b9gf2IzTO6w3Iu07AjlVy12U
         GLkyMhzJOI1/tGzAb5JfR+aSh59NGitNwkesb/QRQuHETHzP9UVsldU9z+tVYYsnb4
         tWEfUndbFg5nw2xIAHpAsvWN7kvHAfDRhi+UYCg5VRLIme88nMMk9qQh8ItwdQ0TbT
         DrkkvvWbvSJ4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3C0BE5724D;
        Sat,  7 Jan 2023 03:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCHV2] octeontx2-af: Fix LMAC config in cgx_lmac_rx_tx_enable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167306281586.4583.4461621412411548875.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Jan 2023 03:40:15 +0000
References: <20230105160107.17638-1-hkelam@marvell.com>
In-Reply-To: <20230105160107.17638-1-hkelam@marvell.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 5 Jan 2023 21:31:07 +0530 you wrote:
> From: Angela Czubak <aczubak@marvell.com>
> 
> PF netdev can request AF to enable or disable reception and transmission
> on assigned CGX::LMAC. The current code instead of disabling or enabling
> 'reception and transmission' also disables/enable the LMAC. This patch
> fixes this issue.
> 
> [...]

Here is the summary with links:
  - [net,PATCHV2] octeontx2-af: Fix LMAC config in cgx_lmac_rx_tx_enable
    https://git.kernel.org/netdev/net/c/b4e9b8763e41

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


