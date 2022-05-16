Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4EB8528125
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbiEPKAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbiEPKAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:00:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F408126E5;
        Mon, 16 May 2022 03:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE06EB80EF1;
        Mon, 16 May 2022 10:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67207C385B8;
        Mon, 16 May 2022 10:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652695214;
        bh=II7oaEEwaORua7xmrC/2E36QFPFnHGu/pS4u5njCMhE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gWrADPzlMv5atAbvMVyY8ier7Kp7YNzfyMgVzZ34SuXM2xlzCIxMVfCeIODdhJHWp
         RW7aPzuwQDMaA5sor8k2ewhWUuBgHYIZEicaT2e3xBr871erUi7OB2hb80TKPlshC2
         zEILg5+H+Okg7kRxoZE7o3qe6RqBjMnm8kqnUISkneLrah3bDBH3ojFDOFIReB1NnV
         2bY8Ckoq9sJH7GXw2mpWSXqfixN/xak9O9LvNd6LLkQdJhM3VfSDlFYWQ6fiOr3T/4
         a37fn67Ou7J7OCFHbPkckJSD/5ikjq5e/Lh1rBmBNy1HNhBrsa8dcq/APcdkFWufGp
         jUB3IcbotFPcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 40BCAE8DBDA;
        Mon, 16 May 2022 10:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/4] net: skb: check the boundrary of skb drop
 reason
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165269521425.20448.5881663412164475656.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 10:00:14 +0000
References: <20220513030339.336580-1-imagedong@tencent.com>
In-Reply-To: <20220513030339.336580-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     kuba@kernel.org, nhorman@tuxdriver.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        asml.silence@gmail.com, willemb@google.com,
        vasily.averin@linux.dev, ilias.apalodimas@linaro.org,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 13 May 2022 11:03:35 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In the commit 1330b6ef3313 ("skb: make drop reason booleanable"),
> SKB_NOT_DROPPED_YET is added to the enum skb_drop_reason, which makes
> the invalid drop reason SKB_NOT_DROPPED_YET can leak to the kfree_skb
> tracepoint. Once this happen (it happened, as 4th patch says), it can
> cause NULL pointer in drop monitor and result in kernel panic.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/4] net: dm: check the boundary of skb drop reasons
    https://git.kernel.org/netdev/net-next/c/a3af33abd921
  - [net-next,v3,2/4] net: skb: check the boundrary of drop reason in kfree_skb_reason()
    https://git.kernel.org/netdev/net-next/c/20bbcd0a94c6
  - [net-next,v3,3/4] net: skb: change the definition SKB_DR_SET()
    https://git.kernel.org/netdev/net-next/c/7ebd3f3ee51a
  - [net-next,v3,4/4] net: tcp: reset 'drop_reason' to NOT_SPCIFIED in tcp_v{4,6}_rcv()
    https://git.kernel.org/netdev/net-next/c/f8319dfd1b3b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


