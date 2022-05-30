Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E315387B3
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 21:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243057AbiE3TUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 15:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243028AbiE3TUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 15:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F3B87237;
        Mon, 30 May 2022 12:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BF1960EAE;
        Mon, 30 May 2022 19:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C56CC34119;
        Mon, 30 May 2022 19:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653938412;
        bh=2lVaGIxVR4kXXdSgKh4r5LLuYR0AG9tw1iwnnfurZC4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f3OedaXy3uFSq+n2w8LVwbDnJYgO/JHLnsWPRdZPJ4arxFWnmszyjaf2cc4zO+TNA
         FPa57/D9XB6CYIBQmTHAcBBPOPqvxLHyUCu70x+e76EZagVCzLV8P0T/7jBCwy0SXP
         BOnWI1UTjTxqjB9oPl0gCQ9C1kSbajGYE9bvqKBZoy9Y5ACTAh4YsQM37H0xRH7BlR
         c0iJVladtiBXcso6REVXIBscrVn7tJ4S2PD2kV85MKrjL4W89tTJN2mrT8KLFQPlC+
         c/KbPJWU9nknm1bQv3Cj19pIuOeCcrt9PtGqufpHoER74g5vuMxysRUE5+gJfSr/cU
         1nXgrFmjoHs0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3BE15F0394C;
        Mon, 30 May 2022 19:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: xdp: Directly use ida_alloc()/free()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165393841223.30061.14830701198740912669.git-patchwork-notify@kernel.org>
Date:   Mon, 30 May 2022 19:20:12 +0000
References: <20220527064609.2358482-1-liuke94@huawei.com>
In-Reply-To: <20220527064609.2358482-1-liuke94@huawei.com>
To:     Ke Liu <liuke94@huawei.com>
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 27 May 2022 06:46:09 +0000 you wrote:
> Use ida_alloc()/ida_free() instead of deprecated
> ida_simple_get()/ida_simple_remove() .
> 
> Signed-off-by: keliu <liuke94@huawei.com>
> ---
>  net/xdp/xdp_umem.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - net: xdp: Directly use ida_alloc()/free()
    https://git.kernel.org/bpf/bpf-next/c/1626f57f061c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


