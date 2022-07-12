Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB235711FC
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 07:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiGLFuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 01:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiGLFuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 01:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED003134B
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 22:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C92D60A5A
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 05:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98978C341CB;
        Tue, 12 Jul 2022 05:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657605015;
        bh=M16y8NWnITICajEy1d89Hoa6XyHn1HDgK3/Ag7zOb5k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=POxyQRaNDSW5ejDqQFChhGPOx9mYEN3cW15I9xZ0XhNEGh2606PH1rd3RRlRrTgdu
         Sw97wqCJEqOwnusHK9XXbrmZcGD4n5XBTMFmv8QiRGtSvZZfDZAsBFbe6XSIqUJ6kW
         kDO0pJufN3dlfI+UK7jZG9HKa7KWYY5YOg8GzCljDxGY512xAwa80S96U1mp4isxj7
         +TuwaTyDJqqGhlhh7yB95jVCmJA9cXsln1MxD4xEJfguXZ94FQ7yI59KQ/K/QnVLtq
         bRAi3t195AKSB0zdC4eHRR/ZJGEhgRp7CuPP+sTCr5mZtK+yWRuHyCtxhoo3PKyPqI
         poCN8u558bq4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6B851E45225;
        Tue, 12 Jul 2022 05:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] tls: rx: follow-ups to NoPad
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165760501543.3229.12511494639223542473.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jul 2022 05:50:15 +0000
References: <20220709025255.323864-1-kuba@kernel.org>
In-Reply-To: <20220709025255.323864-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
        maximmi@nvidia.com, tariqt@nvidia.com
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  8 Jul 2022 19:52:51 -0700 you wrote:
> A few fixes for issues spotted by Maxim.
> 
> Jakub Kicinski (4):
>   tls: fix spelling of MIB
>   tls: rx: add counter for NoPad violations
>   tls: rx: fix the NoPad getsockopt
>   selftests: tls: add test for NoPad getsockopt
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] tls: fix spelling of MIB
    https://git.kernel.org/netdev/net-next/c/1090c1ea2208
  - [net-next,2/4] tls: rx: add counter for NoPad violations
    https://git.kernel.org/netdev/net-next/c/bb56cea9abd8
  - [net-next,3/4] tls: rx: fix the NoPad getsockopt
    https://git.kernel.org/netdev/net-next/c/57128e98c33d
  - [net-next,4/4] selftests: tls: add test for NoPad getsockopt
    https://git.kernel.org/netdev/net-next/c/1d55f2031385

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


