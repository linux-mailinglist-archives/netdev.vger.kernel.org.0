Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EC039ACA2
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 23:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhFCVVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 17:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229640AbhFCVVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 17:21:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 13BE3613F6;
        Thu,  3 Jun 2021 21:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622755203;
        bh=cSbx5b55MaJOUg9EvsEss0JQJOuAQdD3T7xzvy+pPe0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t6a/HnLA+xNkiNwRCRn5p2Gho9Ke6rD41+IRIMGLw44FtuCFXlY18zE66KYsw4Ydw
         uvFKiMCt2PVkrYSUn+pVTaGbvC+vyOPm86ekRRoFKwQQhOK8A2s/UX9iZ8vuLjJTbU
         5ihsfJ6TEkx8HDcThXzL3ySDUdXdO6Qyk05JBqKsckYO0+S/dfbk3XupYyq+pt2p1B
         9rQX20a91I5SwZ8d76gJJtz0UXmkIzec5Nht475l6jjI21kxJEbicLhIF1Mw2G8vwk
         dgqf6MYrF6/ZB49zOn8T08y/CSWgiR36mRBB9b/RR3Pm7f7RgG/XqpEouQPLvM+HAi
         hnCvNFMmkAhlQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 07D7A60ACA;
        Thu,  3 Jun 2021 21:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: kcm: fix memory leak in kcm_sendmsg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275520302.10237.552144078259642267.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 21:20:03 +0000
References: <20210602192640.13597-1-paskripkin@gmail.com>
In-Reply-To: <20210602192640.13597-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, tom@herbertland.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+b039f5699bd82e1fb011@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  2 Jun 2021 22:26:40 +0300 you wrote:
> Syzbot reported memory leak in kcm_sendmsg()[1].
> The problem was in non-freed frag_list in case of error.
> 
> In the while loop:
> 
> 	if (head == skb)
> 		skb_shinfo(head)->frag_list = tskb;
> 	else
> 		skb->next = tskb;
> 
> [...]

Here is the summary with links:
  - net: kcm: fix memory leak in kcm_sendmsg
    https://git.kernel.org/netdev/net/c/c47cc304990a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


