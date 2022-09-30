Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10535F15D5
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 00:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbiI3WKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 18:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiI3WKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 18:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C53B2F67E;
        Fri, 30 Sep 2022 15:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C726362541;
        Fri, 30 Sep 2022 22:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11D08C433D7;
        Fri, 30 Sep 2022 22:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664575816;
        bh=vBYAr+qp6HLWeZ/s3qb8cRpSPT0KXYAUNI1+6MxAIW4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sAfLJ+TAeJY+g4F81jBXCNSe6pgwDMNm0kt9y7Tj3Ni784deucGXKYVCzjpvgGJ4z
         SFtqE0838JX36yt1Ya4nzoksn2mEum/5WuV8N2jIJ8Z0vVui6PqkR/y/9H+fa3rhY2
         JpNmuwCi8XUr6K556lWbcPsQC/h1bdtOkRjHSSJTRfc5jOozlX0ntalTqEDJT5THCl
         x+itZNt94zw/qczePX1pSBiEdAzDKMKlvr6BF/rVJJcUl9JIG20x6bkTKtzt7CtK8v
         UVDITY55cdpvLYFW+HdE2EzQ+VCAI3XesO2Qe3v0kWHqxbyLyRm8dgxCkIdeiBkmr7
         t9OsR6PtEXgcg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EBCDFE49FA7;
        Fri, 30 Sep 2022 22:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] samples, bpf: fix the typo of sample
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166457581596.30660.4806069107190064986.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 22:10:15 +0000
References: <20220927192527.8722-1-wangdeming@inspur.com>
In-Reply-To: <20220927192527.8722-1-wangdeming@inspur.com>
To:     Deming Wang <wangdeming@inspur.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 27 Sep 2022 15:25:27 -0400 you wrote:
> fix the typo of the enty.
> 
> Signed-off-by: Deming Wang <wangdeming@inspur.com>
> ---
>  samples/bpf/xdp_router_ipv4_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - samples, bpf: fix the typo of sample
    https://git.kernel.org/bpf/bpf-next/c/b59cc7fcbaeb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


