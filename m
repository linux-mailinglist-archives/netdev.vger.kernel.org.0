Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7BA526F76
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiENBW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 21:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiENBW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 21:22:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B06E508F10
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 17:52:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5AD061CF2
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 00:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08165C34100;
        Sat, 14 May 2022 00:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652487013;
        bh=ExS2cKjpX0Z5n1tFUXLTxAYzDPSA88dJ007YpWXaOJc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H4tXAoL3KRaoVsluZP/putTPVxcwJEgdGbegzGmT+6sPt7qaBRGvpWOCJ8YzNGahH
         xLoOTlKQn5XWZIauFqkSCBObfmzi91u2yUMCqiXICvcHFcoDV05J4oAXQy8qQGW5xc
         JESO3H+H/sW48q5G3YafBXoSQY1xGzX1BotOKAhJrxyBuq4nrm++tBT1b2cFE4l0JQ
         GzSS1OS1R8Wfm1d6gZOgfqy+8EWZXJaMAWdFNGB+Jvae6YVsKIdtiiVNrz9a/rrC/s
         2MlTjJacUfYKYvQZ9iN4b444Swi9FY050/VpwXmeORmn7bjFu6eRK3B8Au+frglLNE
         INir7Vq711xeQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DDBCCF03934;
        Sat, 14 May 2022 00:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] mptcp: Subflow accounting fix
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165248701290.14999.16227834214314125903.git-patchwork-notify@kernel.org>
Date:   Sat, 14 May 2022 00:10:12 +0000
References: <20220512232642.541301-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220512232642.541301-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 May 2022 16:26:40 -0700 you wrote:
> This series contains a bug fix affecting the in-kernel path manager
> (patch 1), where closing subflows would sometimes not adjust the PM's
> count of active subflows. Patch 2 updates the selftests to exercise the
> new code.
> 
> Paolo Abeni (2):
>   mptcp: fix subflow accounting on close
>   selftests: mptcp: add subflow limits test-cases
> 
> [...]

Here is the summary with links:
  - [net,1/2] mptcp: fix subflow accounting on close
    https://git.kernel.org/netdev/net/c/95d686517884
  - [net,2/2] selftests: mptcp: add subflow limits test-cases
    https://git.kernel.org/netdev/net/c/e274f7154008

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


