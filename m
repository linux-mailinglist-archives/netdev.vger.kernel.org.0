Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D93241939B
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 13:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbhI0Lvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 07:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234051AbhI0Lvp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 07:51:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 399A560F91;
        Mon, 27 Sep 2021 11:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632743408;
        bh=OWFKk4aYgzNOYgfQ8YMqt91ieFqK/URAjPtdpwy3p6I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rb25YdLlSlJ1YehYrw2oJzv+ULy57jhNK3LC0at2YzRIkHE55KtHoUTny3WkWy/0S
         +KVCQqeq2MI/E+hLh9olCZ6Dv+9RUVGaFLjN755u3fo0glZ7XJY5SZoGQowLPWdrD8
         yinXWRMhSVg05KNftDrcyMP7MjkLfCRM6QBIEp2bC9BMjZN1MZBwUGmFNcMGrBcHjU
         GrC6zGslYkTqmFbNm5xHOHeSI33swdeY76GquWhHB1aGr8k1Z6MMFIJlWCmvZtpLNV
         pwtunrFCGUoTwP0D8qzHhfs3vfv9kDTaX2jUAHL0OfvrYC65+swqxZe+1M3iZMtTzG
         4xQ7zgJNvOxmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2E0E660A3E;
        Mon, 27 Sep 2021 11:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] FDDI: defxx: Fix function names in coments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274340818.15641.14879692860923715216.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 11:50:08 +0000
References: <20210925125209.1700-1-caihuoqing@baidu.com>
In-Reply-To: <20210925125209.1700-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     macro@orcam.me.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 25 Sep 2021 20:52:07 +0800 you wrote:
> Use dma_xxx_xxx() instead of pci_xxx_xxx(),
> because the pci function wrappers are not called here.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/net/fddi/defxx.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [1/2] FDDI: defxx: Fix function names in coments
    https://git.kernel.org/netdev/net-next/c/b38bcb41f144
  - [2/2] net: fddi: skfp: Fix a function name in comments
    https://git.kernel.org/netdev/net-next/c/064d0171d7ee

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


