Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABB94E2C47
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 16:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350252AbiCUPbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 11:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238427AbiCUPbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 11:31:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3333814092;
        Mon, 21 Mar 2022 08:30:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB6CC6106E;
        Mon, 21 Mar 2022 15:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C1CDC340F2;
        Mon, 21 Mar 2022 15:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647876610;
        bh=AveAZ/3hKAGUAES+HC0hqCGqhlq9GGIJEnRyUj9KmHM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CwQLVBeQ4XDqtA6sZedyeIVTYA62GKzs2G4bjxZfLuLpAqv7VXRBjbJZWSnmbYTVN
         /TztKdkoaKJBhKol0Bo2t8rbyl+mcz7SKUMLHcyVbfKbqCFIbBTQV9PiIOpHMh1UGZ
         6frvva4mnxxJrhgjFo4/9k0vguCUIBFJrNgmQxsxW5h8stuTPojtYBTMwt/AXjCmR4
         WyuhC1axRxV2jEhPOISD7rIShVsIBgPbHtODRiP7Y+Q6uPBYT6k0SMamk6dNCStRvE
         LHYnVASlfdj/6JM5p3HeYSx+qkqfchqTcyPaQ63tvlHigcTq7b/9Cid6su487k4+8I
         66vKtSNSUqF6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F16D3E7BB0B;
        Mon, 21 Mar 2022 15:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ARM: net: bpf: fix typos in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164787660998.26943.16234173622571786402.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 15:30:09 +0000
References: <20220318103729.157574-9-Julia.Lawall@inria.fr>
In-Reply-To: <20220318103729.157574-9-Julia.Lawall@inria.fr>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     illusionist.neo@gmail.com, kernel-janitors@vger.kernel.org,
        linux@armlinux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 18 Mar 2022 11:37:04 +0100 you wrote:
> Various spelling mistakes in comments.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  arch/arm/net/bpf_jit_32.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - ARM: net: bpf: fix typos in comments
    https://git.kernel.org/bpf/bpf-next/c/d8dc09a4db45

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


