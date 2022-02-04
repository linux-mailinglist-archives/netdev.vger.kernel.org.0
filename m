Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D740F4A9C1A
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359777AbiBDPkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348391AbiBDPkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:40:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EC7C061714;
        Fri,  4 Feb 2022 07:40:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD6AA61771;
        Fri,  4 Feb 2022 15:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B8B4C340E9;
        Fri,  4 Feb 2022 15:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643989208;
        bh=OU0HVfB3n9g9TVoxrG8gnkygMHAqjpU/8KYw+4lhjRc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UixqG+ogfg2HX3N3M5RPAXIYawuOLXvbytfFq2WbKG6na36Q7XqbbNrx2jYuarbU4
         eiy5IlCnfd6PThgK6UHhJz10886kVYF12Y+88yPCYMyFR9oTqR0rJ5YWDHgS9Sel2p
         7Lf108VyUZ1VfgnA0MPc0rSDGxRaxxOrAquuN22e+61Z8TQRBfEG6hLgarNFji85JL
         tXIh9MAWNNER/2aNNvhaU1F7J/rxzrbfPcM3sfB2Mg5GFBRxglnIZc2hCFCFl5KqQm
         oKCKL6fTu0xSazSpb/rUk6IOsAuGc6jwnOmXTw5mdM+aqCAujJx1vchXnCoj7y4Z3J
         NyJcJ3aODm5Cg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2729CE5D08C;
        Fri,  4 Feb 2022 15:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3 0/3] bpf, arm64: enable kfunc call
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164398920815.15398.4235704313850562330.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Feb 2022 15:40:08 +0000
References: <20220130092917.14544-1-hotforest@gmail.com>
In-Reply-To: <20220130092917.14544-1-hotforest@gmail.com>
To:     Hou Tao <hotforest@gmail.com>
Cc:     daniel@iogearbox.net, ast@kernel.org, kafai@fb.com, yhs@fb.com,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, houtao1@huawei.com, zlim.lnx@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, ard.biesheuvel@arm.com,
        linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Sun, 30 Jan 2022 17:29:14 +0800 you wrote:
> Hi,
> 
> The simple patchset tries to enable kfunc call for arm64. Patch #1 just
> overrides bpf_jit_supports_kfunc_call() to enable kfunc call, patch #2
> unexports the subtests in ksyms_module.c to fix the confusion in test
> output and patch #3 add a test in ksyms_module.c to ensure s32 is
> sufficient for kfunc offset.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,1/3] bpf, arm64: enable kfunc call
    https://git.kernel.org/bpf/bpf-next/c/b5e975d256db
  - [bpf-next,v3,2/3] selftests/bpf: do not export subtest as standalone test
    (no matching commit)
  - [bpf-next,v3,3/3] selftests/bpf: check whether s32 is sufficient for kfunc offset
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


