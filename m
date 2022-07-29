Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CEE5856C5
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 00:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239475AbiG2WKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 18:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiG2WKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 18:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B1BA18A;
        Fri, 29 Jul 2022 15:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4C6662063;
        Fri, 29 Jul 2022 22:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B600C433D7;
        Fri, 29 Jul 2022 22:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659132613;
        bh=Hbeqk/hxvMh6HqG/C9jsRs1X9x8qdRRVDSRD4U2XCe0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eeEyWLjPI9Ito3hmG4kLnLMIFgdaSxhvdlnzPteofAut5JRWc7N2sdc7WGKdUUNTg
         MGWIvLTcFHHhaWzFcVHq95QabY2Qs/QKusvfdC51IasX8XpeRShm4EJ00iXAioCnNF
         UVdyEwYzj1Wzrt3kVcVlqKpoj/WO0K98f19+DPoprd0Orwx8uzt1f3JVGpNBw7alws
         /f2dXsJvM+dwZGum7jFdalUC14kOjo5Nz9LmJB69vrZCYwhF+K4WFBqwqtk4iS19Rg
         GYIYBqe1Xe4wuFdwjYrY+io5/nB7eJ/0oliFMUqua9QScaeYHXGiMfwbnIiAAWBDQu
         1P6LgI4jo1Mpg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 121F8C43142;
        Fri, 29 Jul 2022 22:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] netdevsim: avoid allocation warnings triggered from user
 space
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165913261307.14901.9944106861870751680.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 22:10:13 +0000
References: <20220726213605.154204-1-kuba@kernel.org>
In-Reply-To: <20220726213605.154204-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     daniel@iogearbox.net, bpf@vger.kernel.org, ast@kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com,
        syzbot+ad24705d3fd6463b18c6@syzkaller.appspotmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Tue, 26 Jul 2022 14:36:05 -0700 you wrote:
> We need to suppress warnings from sily map sizes. Also switch
> from GFP_USER to GFP_KERNEL_ACCOUNT, I'm pretty sure I misunderstood
> the flags when writing this code.
> 
> Fixes: 395cacb5f1a0 ("netdevsim: bpf: support fake map offload")
> Reported-by: syzbot+ad24705d3fd6463b18c6@syzkaller.appspotmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [bpf] netdevsim: avoid allocation warnings triggered from user space
    https://git.kernel.org/bpf/bpf-next/c/d0b80a9edb1a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


