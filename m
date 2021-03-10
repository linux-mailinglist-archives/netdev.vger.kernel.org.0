Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE20C334955
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhCJVAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:32836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232011AbhCJVAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 16:00:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6944D6501A;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615410013;
        bh=h2A4dFY2IyTIaYnYCYgMwMARsBOk6+MG1paaIpI5SAc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D/rBcYTK7XxTH8SElahW6saVjwO5YKUsv/5fjbJTwkhdkn4vmenYL2Tu+3BbjzxRa
         pb54DePYQrYpsgY1skVr2acWkZrb/gwlwznHg4mFAB56TaW3wzReza5eL/j1++jShF
         IDaAM6uXB/Qypqcg912LY1PMRf07TieNTFr6psAYrGABQZrAW81FAAgiorW9WEGhpK
         2qG2rQFWQnXgZnFJKYRTrn268NuV823b2TSX9fnry8OPAEwpNS7MFqwiQlnph23W2Q
         jGP2rLyxR6/AW+BOZrOo4y2l0OsAMOJ6IXUMJBSPKH/TRMPT64psDrhjSk/Ors8rK4
         JzgvhcIUe7n/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 642F360970;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] skbuff: remove some unnecessary operation in
 skb_segment_list()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541001340.4631.1104873444053085723.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 21:00:13 +0000
References: <1615364938-52943-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1615364938-52943-1-git-send-email-linyunsheng@huawei.com>
To:     l00371289 <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, alobakin@pm.me,
        jonathan.lemon@gmail.com, willemb@google.com, linmiaohe@huawei.com,
        gnault@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Mar 2021 16:28:58 +0800 you wrote:
> From: Yunsheng Lin <linyunsheng@huawei.com>
> 
> gro list uses skb_shinfo(skb)->frag_list to link two skb together,
> and NAPI_GRO_CB(p)->last->next is used when there are more skb,
> see skb_gro_receive_list(). gso expects that each segmented skb is
> linked together using skb->next, so only the first skb->next need
> to set to skb_shinfo(skb)-> frag_list when doing gso list segment.
> 
> [...]

Here is the summary with links:
  - [net-next] skbuff: remove some unnecessary operation in skb_segment_list()
    https://git.kernel.org/netdev/net-next/c/1ddc3229ad3c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


