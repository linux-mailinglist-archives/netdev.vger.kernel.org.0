Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0086076EC
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiJUMa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiJUMaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DB6E52D1
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C010E61E89
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24856C433B5;
        Fri, 21 Oct 2022 12:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666355417;
        bh=0+GqVZRmSGbIIARAIxIiIOCMPgwixsUE4+Z6SkPmfjo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DhV2JhK5mNzglR+XhZuLyQtpWJe6QNnFPqFRzQvYeB4949s0zQX09N+4yj3ZpI5rK
         pMnqoCbncfI69GB6uot7glpAwAyTLq3LSQFnWEJWeiLBsNBjPNgCn6FRaxXzfUXbyI
         JjTWFvP3+8BERoGDVCjKwENAOCnxHnRoq8sHCVQw6TfIOtC5sA83xGzYj3sok3fHhq
         rrAKMzz/B+hMRCxXDVL+0i+dxyYObptpRs0stL8YRYFooVjIz0tvL1ZQDfR1HXQqL0
         WZ1bWaxqUpkCLQejRqMxS3BEh6LRjH6M5JIeY3AcDnfGOE0UxtAxlrih4TBLSUVSX+
         tT4OJ2366JdXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09D19E270E2;
        Fri, 21 Oct 2022 12:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: add keyword match on PTP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166635541703.28002.9259691531914780785.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Oct 2022 12:30:17 +0000
References: <20221020021913.1203867-1-kuba@kernel.org>
In-Reply-To: <20221020021913.1203867-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 19 Oct 2022 19:19:13 -0700 you wrote:
> Most of PTP drivers live under ethernet and we have to keep
> telling people to CC the PTP maintainers. Let's try a keyword
> match, we can refine as we go if it causes false positives.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] MAINTAINERS: add keyword match on PTP
    https://git.kernel.org/netdev/net/c/4d814b329a4d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


