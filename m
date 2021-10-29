Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907F343FC6C
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbhJ2Mmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231530AbhJ2Mmh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 08:42:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 854F561184;
        Fri, 29 Oct 2021 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635511208;
        bh=Fffx43u3g7+ftdon8LgWAfub6my9z//4/ZIVL2l1p9Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MytEJzfZ1Tlc6x6WZ0dc1W/+ntB9d042Fw1XHzK3xrioczE0fdwwJ27BlSpX4uM7r
         Y5fd1fc7ifbFITjcwX4k/dxK3YA6VsD84wpOf3+JHc8hb6rXpcJ3dF1kUewlqIwPmj
         k6zgvHjIEJPJQsM6ageqWOzB9GLQsB2Lqk63ZBWYlN3y8w955ViVICcujvzwXR/ikS
         GnmPHpl9fPu7/6qm67tv/FISZeRwjk3/5/Z5B+crcxMk49ZTWKSo481KRjkh9n52Kp
         QuG1wvrmRNlasNpvl3Z4J7whfxU0eOEap35GjW228N454XDU7cpZf80Jcc7BJFSS4G
         /jNXaMg2Qnd4w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 759AE60A5A;
        Fri, 29 Oct 2021 12:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: netxen: fix code indentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163551120847.27055.6001101207379359593.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 12:40:08 +0000
References: <20211028182453.9713-1-sakiwit@gmail.com>
In-Reply-To: <20211028182453.9713-1-sakiwit@gmail.com>
To:     =?utf-8?q?J=CE=B5an_Sacren_=3Csakiwit=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     manishc@marvell.com, rahulv@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Oct 2021 12:24:52 -0600 you wrote:
> From: Jean Sacren <sakiwit@gmail.com>
> 
> Remove additional character in the source to properly indent if branch.
> 
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> ---
>  drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: netxen: fix code indentation
    https://git.kernel.org/netdev/net-next/c/c4cb8d0ac714

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


