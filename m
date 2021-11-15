Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593E8450513
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhKONNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:13:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231660AbhKONNF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 08:13:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EA91161B72;
        Mon, 15 Nov 2021 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636981809;
        bh=7bzqYW1fYd0+dEM/JNBuoEhXpfoviHOCahF47QxdD0I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qfnVGo11ZBqrmqU3Eqjb9qCxZ9zj/rWE1oPdBkGjK+Ye/i58tOLowf9auNGQbG3rC
         1M0RPp1dzT68a2/7trlFZuV5CnKse6oI2xlkgxyQbg0425Kbep2AjlLnLhf1YlAt9T
         6Gvzzm1wo92R/wIF33qkCG0F/enqFsnW8iaFbmpCAls2YW7qeFIsjeheCxB+XdNTYL
         32fS7wYvbVuIiD+5mt/HLWlGebvx5EN/7Km5li6ct4AU7L86nuw6LmlsZMBSMy8l5V
         WT2qSbxuAsW7hUMjPasDf+rWVjKf7lAz3SWPtaj/XLk30sFtodPwKFUxwnBPO6ZdKV
         AZLHxYSGrz9BA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DD9E260A0E;
        Mon, 15 Nov 2021 13:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: Clean up some inconsistent indenting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698180890.15087.11327140593364999160.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 13:10:08 +0000
References: <1636712194-67361-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1636712194-67361-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 12 Nov 2021 18:16:34 +0800 you wrote:
> Eliminate the follow smatch warning:
> 
> ./include/linux/skbuff.h:4229 skb_remcsum_process() warn: inconsistent
> indenting.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - net: Clean up some inconsistent indenting
    https://git.kernel.org/netdev/net/c/10a2308ffb8c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


