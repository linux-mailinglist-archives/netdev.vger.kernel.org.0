Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB475446260
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 11:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhKEKws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 06:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230003AbhKEKwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 06:52:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DD60F6120E;
        Fri,  5 Nov 2021 10:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636109407;
        bh=ke52n55HQ2LSKnAVrU/HcMARYrUbPJNHu0gw9CYhLx0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fTOo2m/J1Y6tfAw2ZxnTT0Wy1YWh40NTxjRRbKJPM/0gaWXyjNCdzxgs1JHo/3oWc
         IkqN6JhcabYST5NSl/wul54TPmQeLcOw2KK7i8skqgmFJt4E27OaGRO7uciPjKnrEk
         mxbjBT9B5NM7lA9AWxs8hTr8UycduaEc2/uz7ydM45LDca7QM+Dt9/jASdcJNtxlH3
         ufdptB9Zl1FBg4p7NO2DWSjzIm06/Z4xrzSYtoETV4t/8JG4r+CQBSWWWurdVLgZSG
         EfFn4A5VnyfbobsgcXC3q1+jkLyz2kbC7yzuO8fH6dQY7jyFfDcS5T2ldNVx9QH0JS
         /I5mD0gfhOEYA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D3134609B8;
        Fri,  5 Nov 2021 10:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] amt: Fix NULL but dereferenced coccicheck error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163610940785.24664.1591851687839471191.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Nov 2021 10:50:07 +0000
References: <1636096370-19862-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1636096370-19862-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     ap420073@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  5 Nov 2021 15:12:50 +0800 you wrote:
> Eliminate the following coccicheck warning:
> ./drivers/net/amt.c:2795:6-9: ERROR: amt is NULL but dereferenced.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/amt.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [-next] amt: Fix NULL but dereferenced coccicheck error
    https://git.kernel.org/netdev/net/c/3f81c5799128

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


