Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA5D644D9F
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 22:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiLFVAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 16:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiLFVAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 16:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6094509A;
        Tue,  6 Dec 2022 13:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FC85B81B55;
        Tue,  6 Dec 2022 21:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9DFB2C433D7;
        Tue,  6 Dec 2022 21:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670360415;
        bh=oV+o4VDUwO9ki3r4H2TbVxbKKiSddhCM13yZyTZaaog=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CFAeTPcOY6XMFjrAUooJoI5ddRabUNoDeyGwUDWyaGuf0QvA2Of7tQF8PEWhTI0u5
         lEmyP9zEJqXxueqXjclLi43nK6eoCb4yMa7aLCZ06X36zO9rgaX87KCO+yK+nqO3vN
         ZEjXet8rayi7FtrIs6Ik4TRjDW7YxkbNUweTeWtkaY8fO6q0Lh7ZdkLgY9rCjM9jhu
         PfPRhXsy5sE3uPs7pvzxTsaIqJlKOlPRM/wMVXfzIh3EKVDrOoUO4oJQRRlix86xg6
         Ez7de1/EYDdkFrPmr2x6yWcUYlhREav/BtfKadMJVxbawomeL1H5GM9pLMj5b3lAGn
         dn8txbXJ9EZFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7FF9FE56AA0;
        Tue,  6 Dec 2022 21:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: Allow building bpf tests with
 CONFIG_XFRM_INTERFACE=[m|n]
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167036041551.30610.2678929954116630234.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 21:00:15 +0000
References: <20221206193554.1059757-1-martin.lau@linux.dev>
In-Reply-To: <20221206193554.1059757-1-martin.lau@linux.dev>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, kernel-team@meta.com,
        eyal.birger@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Tue,  6 Dec 2022 11:35:54 -0800 you wrote:
> From: Martin KaFai Lau <martin.lau@kernel.org>
> 
> It is useful to use vmlinux.h in the xfrm_info test like other kfunc
> tests do.  In particular, it is common for kfunc bpf prog that requires
> to use other core kernel structures in vmlinux.h
> 
> Although vmlinux.h is preferred, it needs a ___local flavor of
> struct bpf_xfrm_info in order to build the bpf selftests
> when CONFIG_XFRM_INTERFACE=[m|n].
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/bpf: Allow building bpf tests with CONFIG_XFRM_INTERFACE=[m|n]
    https://git.kernel.org/bpf/bpf-next/c/aa67961f3243

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


