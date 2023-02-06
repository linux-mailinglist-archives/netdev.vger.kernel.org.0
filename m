Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699BF68B845
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjBFJKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjBFJKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6D110DA
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 01:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E7C160DBB
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C87EAC4339B;
        Mon,  6 Feb 2023 09:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675674616;
        bh=+1gVAlSY5cDulQ369pBn/voOZsxp6HeudUP06eBfako=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M7GcpOjNKl5tKoNikK5YWxTH024qFF7OsOjnm28Xzk2+VKaHtGPp2QepTdShHKJXa
         NuT8yW5wLq9IAwMMisfEtjiUn5eQ/vBJFIJiZVBqNUrIvIpUkO6pBnxCSBQsbg+D70
         RuZfz8jOKbWogqQ+SFx97/vwgOn8W/ASmftE09eSOzNrrp/mxd/vpf6aJ9LmxWsb63
         jdV5C8K7Ka4xwFwxsT/DfQXsG5Yt91DJ3d4/cX9yBsyyEcQepGKKSV8G20PCO3x3VE
         SWejZyhfSR0aiFktlTkhU0HmGG7Ehih3rvgTzdYLp/lzvzgJGGqVU1vBPVSFVO73fD
         zC23DPOg48BWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ADD87E55EFD;
        Mon,  6 Feb 2023 09:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] neigh: make sure used and confirmed times are valid
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167567461670.31707.15386680207320907002.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Feb 2023 09:10:16 +0000
References: <20230202152551.56390-1-ja@ssi.bg>
In-Reply-To: <20230202152551.56390-1-ja@ssi.bg>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        zhangchangzhong@huawei.com, yuehaibing@huawei.com
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
by David S. Miller <davem@davemloft.net>:

On Thu,  2 Feb 2023 17:25:51 +0200 you wrote:
> Entries can linger in cache without timer for days, thanks to
> the gc_thresh1 limit. As result, without traffic, the confirmed
> time can be outdated and to appear to be in the future. Later,
> on traffic, NUD_STALE entries can switch to NUD_DELAY and start
> the timer which can see the invalid confirmed time and wrongly
> switch to NUD_REACHABLE state instead of NUD_PROBE. As result,
> timer is set many days in the future. This is more visible on
> 32-bit platforms, with higher HZ value.
> 
> [...]

Here is the summary with links:
  - [net] neigh: make sure used and confirmed times are valid
    https://git.kernel.org/netdev/net/c/c1d2ecdf5e38

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


