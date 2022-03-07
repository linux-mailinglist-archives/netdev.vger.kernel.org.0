Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DD24CFE81
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 13:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239831AbiCGMbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 07:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238332AbiCGMbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 07:31:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDAE85BF2;
        Mon,  7 Mar 2022 04:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7025BB811CF;
        Mon,  7 Mar 2022 12:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3F4DC340F6;
        Mon,  7 Mar 2022 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646656211;
        bh=llzyS48maLqysavM3QeAfL7dDT3TuzwEEssXQ8p4S+w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BnwfCr/Zw8rTCrAmyx90yVtHM07T4N7HTUhEzGNS50sUAKMOtF/ULO1D5yt2oBzBY
         Rqgv/XZblAq3wHNvD2OaG/T17Yd9v+dkX7VSc2SDY4w1UHg/CHU8Zj8fOdO73k1jZ0
         Y2gfQZuoGA+7pz/V80Xj9/qw2Ojq6TyDnGayM99py2UPNZz3BpPq0Noh+dd9kCHgUh
         99OGJRotPMNpsuYA1XJvt6RB9Gjg4993jQ3hjaI+ptYdv8SocKIlcH/25FnGlEROH9
         xnKgaW7jgKiZ2ueTMHu+k/G4NxvZRJHO6QRLeUB9/sC9mnxYRUFaIJ1GWhXVK1Wfel
         CJcZznFoX3FHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2D14F0383A;
        Mon,  7 Mar 2022 12:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: net: fix array_size.cocci warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164665621086.9112.14264718832966100905.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Mar 2022 12:30:10 +0000
References: <20220305161835.16277-1-guozhengkui@vivo.com>
In-Reply-To: <20220305161835.16277-1-guozhengkui@vivo.com>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun,  6 Mar 2022 00:18:35 +0800 you wrote:
> Fit the following coccicheck warning:
> tools/testing/selftests/net/reuseport_bpf_numa.c:89:28-29:
> WARNING: Use ARRAY_SIZE.
> 
> It has been tested with gcc (Debian 8.3.0-6) 8.3.0 on x86_64.
> 
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> 
> [...]

Here is the summary with links:
  - selftests: net: fix array_size.cocci warning
    https://git.kernel.org/netdev/net-next/c/0273d10182ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


