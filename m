Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2051614446
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 06:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiKAFaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 01:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiKAFaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 01:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1347F655C
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 22:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2C4E6146F
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 05:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0597EC433D7;
        Tue,  1 Nov 2022 05:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667280618;
        bh=zlOkRRXkOlJ4CYSuuFnuiD2AbONFJKOoyU38u4eQEqs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IVaNtfmEB1Kq8RXMYbn17y/2zBueLG6u/u1xtcPpmGbXQnooN1zWHE66byCzZydJj
         jUQE7jxZ2/z1m603Bn3IpGdh3P5h2gN3zs+wu021y1JkfaFvZpyAilS8uSgztWV6hg
         o9a4qafc6a3RfT+7uz0D1/JwdKliNcG9cuaOV1rAryeUXSodx+FXYr+637ZnLgMVFu
         fzIfBWN7WrRbjGyQAzNLVgtRUcusqHlbnGoWVo1I09IOL1bfF+KVbWGVOuJzzm3xnZ
         SanT4DJVwGwI4uVIBrsH1e3Dbmqt9fFQiILrBHdOkYeq18BjFrMOQymI0XmXOiSc2r
         PKorLqHud0LyA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DAF9DE50D71;
        Tue,  1 Nov 2022 05:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/5] inet: add drop monitor support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166728061789.32736.18262365783917725837.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Nov 2022 05:30:17 +0000
References: <20221029154520.2747444-1-edumazet@google.com>
In-Reply-To: <20221029154520.2747444-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 29 Oct 2022 15:45:15 +0000 you wrote:
> I recently tried to analyse flakes in ip_defrag selftest.
> This failed miserably.
> 
> IPv4 and IPv6 reassembly units are causing false kfree_skb()
> notifications. It is time to deal with this issue.
> 
> First two patches are changing core networking to better
> deal with eventual skb frag_list chains, in respect
> of kfree_skb/consume_skb status.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/5] net: dropreason: add SKB_CONSUMED reason
    https://git.kernel.org/netdev/net-next/c/0e84afe8ebfb
  - [v2,net-next,2/5] net: dropreason: propagate drop_reason to skb_release_data()
    https://git.kernel.org/netdev/net-next/c/511a3eda2f8d
  - [v2,net-next,3/5] net: dropreason: add SKB_DROP_REASON_DUP_FRAG
    https://git.kernel.org/netdev/net-next/c/4ecbb1c27c36
  - [v2,net-next,4/5] net: dropreason: add SKB_DROP_REASON_FRAG_REASM_TIMEOUT
    https://git.kernel.org/netdev/net-next/c/77adfd3a1d44
  - [v2,net-next,5/5] net: dropreason: add SKB_DROP_REASON_FRAG_TOO_FAR
    https://git.kernel.org/netdev/net-next/c/3bdfb04f13eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


