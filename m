Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515773E2D7A
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 17:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244241AbhHFPUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 11:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232021AbhHFPUV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 11:20:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9494A61158;
        Fri,  6 Aug 2021 15:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628263205;
        bh=IPKWHVxV4eUP5gcHwLrCCBj608XC+BTjwspjjQ+mcLE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ekJZh7RWhlOZuZUUQ4w6/J3DiHxUa7iPMRHtSZ/dhY2CH1zBa5HdUgg1H0FT3T9Ik
         RJGys5ik7M/xZKkmUVm1leE+yNA6ngkIBf3mO/7oGNDi+7NDbn46oglf/x0Knx1Gw/
         YYtqqrT8377Gyjv6LAO0U7JkrUcDvgdddLUBWGEQ8MzwFyuDDGqdKuStVMjjmcw9j/
         cFpDQCfUKvyxJ3gNNnedC46PbRMd2Vu1wjuRLasNRuWDKizn+4Wvct+t9W2qzfJnq9
         wPpS2KJKvm5x2yfONPMW2b6NNT38zAmIyb0yj69xf3o9yoCf3w7MERySzdLtT9p80C
         uLsBlFs3cx9Dw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 85683609F1;
        Fri,  6 Aug 2021 15:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests/bpf: Fix bpf-iter-tcp4 test to print correctly the
 dest IP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162826320554.23389.17105281898176827643.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Aug 2021 15:20:05 +0000
References: <20210805164044.527903-1-josebl@microsoft.com>
In-Reply-To: <20210805164044.527903-1-josebl@microsoft.com>
To:     Jose Blanquicet <blanquicet@gmail.com>
Cc:     josebl@microsoft.com, shuah@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, revest@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Thu,  5 Aug 2021 18:40:36 +0200 you wrote:
> Currently, this test is incorrectly printing the destination port
> in place of the destination IP.
> 
> Signed-off-by: Jose Blanquicet <josebl@microsoft.com>
> ---
>  tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - selftests/bpf: Fix bpf-iter-tcp4 test to print correctly the dest IP
    https://git.kernel.org/bpf/bpf-next/c/277b13405703

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


