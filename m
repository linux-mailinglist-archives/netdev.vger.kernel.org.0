Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0417F6478CF
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 23:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiLHWaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 17:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiLHWaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 17:30:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D757580A3C
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 14:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EC8EB82444
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 22:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 353C4C433F0;
        Thu,  8 Dec 2022 22:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670538617;
        bh=F8mPrqeUNtPh5urpnNtDSdRX4hGtIEtvwm1eNI3lp0A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KW1wfG9CscweXWPbTOwmSRslHiNtLTclD4pbS5yjG7UhHcNboHzXVZ7/vexgxGxUA
         1OTCv6g3ibWWeZe2Pzm9l13fklE/YPvKNbGNh5QbCCSJGUWSP7k+PxuP7N62VN0+K/
         qXjBZ7VoURTed9D7fIpKvuirTCIrxkUyCHqqmfHQ2wQ2relhgdSGpbZRNB5a2evPaC
         ALCI1LjHRvSh4fCgz57XxKCNWQ10rd2ne/BrfCyyXOvx65SpLsyQY2k4V2ZWn39QMO
         WwKbBGghe8HFjCwbJmHtMVENyyfE8GAyjwUFLeIamVl0WJWmBkUfX99IxMZTz0sPWB
         HJb8Jv1WdA4Ww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16F71C433D7;
        Thu,  8 Dec 2022 22:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/3] mlx4: better BIG-TCP support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167053861709.9652.7408196603446406861.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 22:30:17 +0000
References: <20221207141237.2575012-1-edumazet@google.com>
In-Reply-To: <20221207141237.2575012-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        tariqt@nvidia.com, leonro@nvidia.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 Dec 2022 14:12:34 +0000 you wrote:
> mlx4 uses a bounce buffer in TX whenever the tx descriptors
> wrap around the right edge of the ring.
> 
> Size of this bounce buffer was hard coded and can be
> increased if/when needed.
> 
> v2: roundup MLX4_TX_BOUNCE_BUFFER_SIZE (Tariq)
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/3] net/mlx4: rename two constants
    https://git.kernel.org/netdev/net-next/c/35f31ff0c0b6
  - [v2,net-next,2/3] net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends on MAX_SKB_FRAGS
    https://git.kernel.org/netdev/net-next/c/26782aad00cc
  - [v2,net-next,3/3] net/mlx4: small optimization in mlx4_en_xmit()
    https://git.kernel.org/netdev/net-next/c/0e706f7961a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


