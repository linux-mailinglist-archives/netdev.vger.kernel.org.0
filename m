Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0598534A26
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 07:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345784AbiEZFKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 01:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244693AbiEZFKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 01:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC9CBC6DA
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 22:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2FD961A25
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 05:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3A54C34116;
        Thu, 26 May 2022 05:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653541812;
        bh=gsKNEdafC+sY+C+4SGrMpGo5A5iw82g/oCxq8+md5zw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hjl74IY2tHDOX3kIf+9Sh7HxGh3lWNhTMbO54pVKsYL7YrS+TRPuWFy3xLZr59YGF
         9e5jWm1u1iMjtYVNgDi4bI/eAFpHzQS86tFUcwyHDK4H5RKDOuDzOPCiXPSZOkx/2u
         f1wMHr9SdP4Om3PuoJm2YzWxAWtenGk5IPO/cNEoLJ3058eLrh033yGG8lPUYENNRP
         3SigPfzIeJGllyteBT8Yn/gT40flNLCKmYyqtxmKrN0hVPDWq6CaePlS/IzGGki2hD
         dN0LdAcpXkuTT0Vi7dr2zL3clMJ/uBsywe+mcadYIdvl0UYeN7HwEhMEyxkH6RKZ9L
         nPU0lQSUIHMRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BB299F03947;
        Thu, 26 May 2022 05:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net, neigh: Set lower cap for neigh_managed_work rearming
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165354181276.23912.16447373310059489.git-patchwork-notify@kernel.org>
Date:   Thu, 26 May 2022 05:10:12 +0000
References: <3b8c5aa906c52c3a8c995d1b2e8ccf650ea7c716.1653432794.git.daniel@iogearbox.net>
In-Reply-To: <3b8c5aa906c52c3a8c995d1b2e8ccf650ea7c716.1653432794.git.daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     kuba@kernel.org, wangyuweihx@gmail.com, pabeni@redhat.com,
        netdev@vger.kernel.org, razor@blackwall.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 25 May 2022 00:56:18 +0200 you wrote:
> Yuwei reported that plain reuse of DELAY_PROBE_TIME to rearm work queue
> in neigh_managed_work is problematic if user explicitly configures the
> DELAY_PROBE_TIME to 0 for a neighbor table. Such misconfig can then hog
> CPU to 100% processing the system work queue. Instead, set lower interval
> bound to HZ which is totally sufficient. Yuwei is additionally looking
> into making the interval separately configurable from DELAY_PROBE_TIME.
> 
> [...]

Here is the summary with links:
  - [net] net, neigh: Set lower cap for neigh_managed_work rearming
    https://git.kernel.org/netdev/net/c/ed6cd6a17896

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


