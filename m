Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E53750DE83
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 13:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241650AbiDYLNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 07:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241760AbiDYLNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 07:13:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F2E12AC2
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 04:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6079061186
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 11:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C869EC385A7;
        Mon, 25 Apr 2022 11:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650885010;
        bh=0mkpB3RdYMYFnSUVBGhQbVKV5TGFnMUFQc5hcyLUX+U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pVMITtNIO2jH9FSl6AD2SWQIn50UjcwFW7fr3D1mStNibm3PDldwL8eVcl+74a+dR
         MjW76e/Kagxm34Cs4Jiff/yRggjBoerpKrbmr564bZ5J2XMdTFx6bZXXKaPfcDUzQi
         9gL7e+lJLhdtv+CPR10S+m2cq5mDJBMf0GceFygEW0VEIdR2YaDsTc1zgfPmT4B2up
         l7BCM6whyVyxZ848Sb4gNz4FVsg/4GZypDrVf/oOguHrAnrOCWecj5S/uwp5Yfv/2X
         pRexsDhma1jcBggveNxB5hXRWGrGafhPaqgUzq7awBBddeAgekbPcvvrBJJKfbacxs
         MdJQ9y6CaQS5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AE8BBEAC09C;
        Mon, 25 Apr 2022 11:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: fix potential xmit stalls caused by
 TCP_NOTSENT_LOWAT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088501071.19970.3977417216460899924.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 11:10:10 +0000
References: <20220425003407.3002429-1-eric.dumazet@gmail.com>
In-Reply-To: <20220425003407.3002429-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com, dsp@fb.com,
        soheil@google.com, ncardwell@google.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun, 24 Apr 2022 17:34:07 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> I had this bug sitting for too long in my pile, it is time to fix it.
> 
> Thanks to Doug Porter for reminding me of it!
> 
> We had various attempts in the past, including commit
> 0cbe6a8f089e ("tcp: remove SOCK_QUEUE_SHRUNK"),
> but the issue is that TCP stack currently only generates
> EPOLLOUT from input path, when tp->snd_una has advanced
> and skb(s) cleaned from rtx queue.
> 
> [...]

Here is the summary with links:
  - [net] tcp: fix potential xmit stalls caused by TCP_NOTSENT_LOWAT
    https://git.kernel.org/netdev/net/c/4bfe744ff164

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


