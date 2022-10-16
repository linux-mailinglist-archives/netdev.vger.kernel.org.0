Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C51600317
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 22:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiJPUAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 16:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiJPUAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 16:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE5A286EA
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 13:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF601B80D4C
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 20:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BBEAC433C1;
        Sun, 16 Oct 2022 20:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665950415;
        bh=GeRqvYO3MgvIbSzIrDURvv/4JcbDQPqffZA5ZDVMZQg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NKagffYT9+pVfKAEqUU4SDhjDzVfKpTXlaNqk+TVpHnHchqZmcpya8kdkLv+Vpjfp
         Vdm1LNTAeXxRkh97IGpMU7gDL0Ml7IHUyKAdplj0GLzY8h5DOeYaXkZSmARlH1Mmgo
         i987UKJzAPCoOqbvLNMF2xgSnTuZWSR/M3+GMfpVH7vqisNojHtAkV/Nb6RaqvKEpC
         iX5jQRXzIEqSSUMbImoFAmqOQp3yUSB0KXLSkgZ+Qyj0RJR+VkLg6/wxibO5uujMTe
         bDhVbGM+iUemK26sTH1B2qiJNmhbeIh2MnQZOgZjkTGwDs8050RNp2EocWG57gOsHY
         Xqes4nlM8McYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65776E270EE;
        Sun, 16 Oct 2022 20:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] skmsg: pass gfp argument to alloc_sk_msg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166595041541.15490.11581781982803033619.git-patchwork-notify@kernel.org>
Date:   Sun, 16 Oct 2022 20:00:15 +0000
References: <20221015212441.1824736-1-edumazet@google.com>
In-Reply-To: <20221015212441.1824736-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, cong.wang@bytedance.com,
        daniel@iogearbox.net, john.fastabend@gmail.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 15 Oct 2022 21:24:41 +0000 you wrote:
> syzbot found that alloc_sk_msg() could be called from a
> non sleepable context. sk_psock_verdict_recv() uses
> rcu_read_lock() protection.
> 
> We need the callers to pass a gfp_t argument to avoid issues.
> 
> syzbot report was:
> 
> [...]

Here is the summary with links:
  - [net] skmsg: pass gfp argument to alloc_sk_msg()
    https://git.kernel.org/netdev/net/c/2d1f274b95c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


