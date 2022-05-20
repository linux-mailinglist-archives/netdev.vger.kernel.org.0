Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205F152F65F
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 01:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiETXuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 19:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiETXuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 19:50:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27799185C83
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 16:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B56CE61B01
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 23:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F5F5C34115;
        Fri, 20 May 2022 23:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653090612;
        bh=n/ZScEhjVrujQKJkREXz8aNHRNfvdG5YHM9htEydLqY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mVO4sBxyTg9jp+rFZtVMeuzPrF/I/3JxUmLKUpA5LUUug/2NuTX3HCVMmofF+pXYW
         Xk//VL88a3avvPdPgfvxn7+FN2ep96Vkwn07IjNF30zUYHj8G/hAk5aF0DqB+lkCzn
         87P9WIaC0hl3m16V5YBKC+sEFCdSIHL31LGE2McyuER2LtP4Fj/0dHABfH2QELhLDU
         I9rdWmvs0gYjosiiQ+BfhBg/cwEPfw0X6QROAkCdlh39CKoEi2m5A1DokmUg2vc8It
         WBfAU0bQqnjgWu/nHP6s20s304p6RJJlrAa8akScoVvsaUKvvfqJA2J3zIgdC3AMS7
         0VE9UuISg45Mw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 05149F0383D;
        Fri, 20 May 2022 23:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sfc/siena: Remove duplicate check on segments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165309061201.4562.9582582112254465006.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 23:50:12 +0000
References: <165294463549.23865.4557617334650441347.stgit@palantir17.mph.net>
In-Reply-To: <165294463549.23865.4557617334650441347.stgit@palantir17.mph.net>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, dan.carpenter@oracle.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 19 May 2022 08:17:15 +0100 you wrote:
> Siena only supports software TSO. This means more code can be deleted,
> as pointed out by the Smatch static checker warning:
> 	drivers/net/ethernet/sfc/siena/tx.c:184 __efx_siena_enqueue_skb()
> 	warn: duplicate check 'segments' (previous on line 158)
> 
> Fixes: 956f2d86cb37 ("sfc/siena: Remove build references to missing functionality")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Link: https://lore.kernel.org/kernel-janitors/YoH5tJMnwuGTrn1Z@kili/
> Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] sfc/siena: Remove duplicate check on segments
    https://git.kernel.org/netdev/net-next/c/cc398a34d16f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


