Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7BA6133F0
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiJaKuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiJaKuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D74264A
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8F2061161
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 10:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F81CC433B5;
        Mon, 31 Oct 2022 10:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667213416;
        bh=cfN39IzsYneD6YKxCccGVw63y7dbu+G9xMCK6msPygc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oNNFyhRx/WWFASgmBRE/VS3sthtf2qjUIbiDeoEXAchkjmh9R8hNQGU7foEDWp4+V
         /jBvC+34CgUyUYPSQJKVSSdj5ZpNkoqfIcNWYwO8It8tqOh71sW2mRhk1KD6CU5Pwj
         JuxiddfNLlvfGmf2AuWEiHw4B3tJ2eo3kHIyf1aGzzmw178mLHqH4XUnHRh1z6m5rF
         DDOLiUqYZh2RL5SJXQBF5biqQezHjWs/S0V2b1bcRV/yxiUWqRydbj8c2Rzo7zqdso
         94pK/t/wemUDBMMg9ZTOD9g2mJsQmD6ZLToXfhbPoCcnX6KY4SWh+3UfMmdAkvGFWE
         xoS/fOc8Myzbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 04C97E50D71;
        Mon, 31 Oct 2022 10:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: geneve: fix array of flexible structures
 warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166721341601.30467.2135203073317781874.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 10:50:16 +0000
References: <20221028035259.2728736-1-kuba@kernel.org>
In-Reply-To: <20221028035259.2728736-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 27 Oct 2022 20:52:59 -0700 you wrote:
> New compilers don't like flexible array of flexible structs:
> 
>   include/net/geneve.h:62:34: warning: array of flexible structures
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/net/geneve.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: geneve: fix array of flexible structures warnings
    https://git.kernel.org/netdev/net-next/c/8c2a535e089b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


