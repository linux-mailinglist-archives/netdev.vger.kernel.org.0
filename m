Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93C65123B9
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 22:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236816AbiD0UQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 16:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236665AbiD0UQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 16:16:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493F984ECC
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 13:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBB3061CEC
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 20:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3AC9EC385A7;
        Wed, 27 Apr 2022 20:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651090213;
        bh=GsJcmyNWphNQdJQhdVsNmpqrjwnIsmNdPG5OGstiJxU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dbX15jtWrsZxbMnL+e9nv1J/1N0sd7RHJv9nTrMAhVDyQSDaG6k20nLmFqcAkLHfH
         Uggnyq2GrUJM8qqI+dEvLMxDNxCZp+Qq2DClvoWNF96fbrq/ocwLHs4t54nqLyASWi
         NEmsLeu33fROO8Kpul/b/pFSUol1R1O1Fq0e4bPmIU7ivhq4kijKgqTRfCIyVq1nU3
         c7jJBkjitSBfoB0XPsQNSsQdN10WzF/LYUCApzk+jfW72JYjXuVMhVutMrm6Q8rrHY
         e5xhNg4+aqjZQqEhj9dZ4hPLS8yT4wMMVG3/nUgkvUmMmZl21Drk8THAWp/aSmcPcI
         Ae5Dhy2C4fZCA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20124EAC09C;
        Wed, 27 Apr 2022 20:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Add Eric Dumazet to networking maintainers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165109021312.16212.476147456464994672.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Apr 2022 20:10:13 +0000
References: <20220426175723.417614-1-kuba@kernel.org>
In-Reply-To: <20220426175723.417614-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        edumazet@google.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Apr 2022 10:57:23 -0700 you wrote:
> Welcome Eric!
> 
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net] Add Eric Dumazet to networking maintainers
    https://git.kernel.org/netdev/net/c/7b5148be4a6e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


