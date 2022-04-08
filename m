Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC514F9F96
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 00:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbiDHWcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 18:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbiDHWcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 18:32:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F91313F67;
        Fri,  8 Apr 2022 15:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8F13B82D94;
        Fri,  8 Apr 2022 22:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7DCF6C385A5;
        Fri,  8 Apr 2022 22:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649457012;
        bh=hfFonn4hIfWTdRv16zutUJYsEVtCCHlhyqiYCPSxS8o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VYI92s45LmNBzoeZFPK/IEEbH7k5z+pQdFxrai1WRDugLhLBoNscVvfBn6eZXl1vv
         nL2wMtfzwbynhfsQ/84+kQ1uk9RCQs1nEArZgQ1Wr9r27E5md9/KYPMRzS6qlIfbCi
         Vm9+tN4yCeAyd6KMNlpREJtWEg+9pqmx5mKQTFnkOqWm9h0dpRLJ63/YFK+d66dfFM
         fl+L2ybc2/8uxkVErBenXkyyFy+BXGLiAGN+RkJ7AcktPP1kPSxuRGtF+G0b6BoJTe
         6TH/VP07aDiTbhUJwGU0WC+Vn646AoOJSV/cGRsatNhhEmvNbE4x90/78OZlXtRbtp
         r0qNToLoJDqWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65B68E8DD5D;
        Fri,  8 Apr 2022 22:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Fix excessive memory allocation in
 stack_map_alloc()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164945701241.5102.1059987393564015684.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 22:30:12 +0000
References: <20220407130423.798386-1-ytcoode@gmail.com>
In-Reply-To: <20220407130423.798386-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        roman.gushchin@linux.dev, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu,  7 Apr 2022 21:04:23 +0800 you wrote:
> The 'n_buckets * (value_size + sizeof(struct stack_map_bucket))' part of
> the allocated memory for 'smap' is never used, get rid of it.
> 
> Fixes: b936ca643ade ("bpf: rework memlock-based memory accounting for maps")
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>  kernel/bpf/stackmap.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - [bpf-next] bpf: Fix excessive memory allocation in stack_map_alloc()
    https://git.kernel.org/bpf/bpf-next/c/b45043192b3e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


