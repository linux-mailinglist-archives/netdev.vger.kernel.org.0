Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37496357793
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhDGWUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230168AbhDGWUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:20:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 70FF4613A0;
        Wed,  7 Apr 2021 22:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617834030;
        bh=qG39CG4BljqHpzaHMQVT7yWKROgH7n9yi/GfbZTp2S8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eufvZc6iN19TBfvezOACAH5q6ADrW6QNjix7/wwesh/Vn8HQ7hKwsR11xCqrhgh1S
         SMbwo0z3vaon1m5iSyjNbvINKn8tPJKeSzv95IUKs8qB7qR/VUM6qm1GtzHIFrvfC7
         iaUBVRwZN9H+5NQRUeVhRCkJ05PZ1SHEVwBigCoUMg2mZytarJLp8VrJCANpIn2/up
         QgeRFq8fOEU7ABxMaKIHpRNx8SWgk9c8Kt2Uwyvq2gocfbYJsOZ7bnLW9BwBUk5yRp
         Fy0+nskXtXZnCHZJmuMV5MBo3tRoRwI0ZWclmAL88UfP3eXSYBuFi2oPUs+Qag7WFf
         fLl0rkYpFOHKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6C64260ACA;
        Wed,  7 Apr 2021 22:20:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tulip: windbond-840: use module_pci_driver to
 simplify the code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783403044.11274.9838192452910134625.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 22:20:30 +0000
References: <20210407150707.362553-1-weiyongjun1@huawei.com>
In-Reply-To: <20210407150707.362553-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     kuba@kernel.org, christophe.jaillet@wanadoo.fr,
        vaibhavgupta40@gmail.com, gustavoars@kernel.org,
        netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 7 Apr 2021 15:07:07 +0000 you wrote:
> Use the module_pci_driver() macro to make the code simpler
> by eliminating module_init and module_exit calls.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  .../ethernet/dec/tulip/winbond-840.c    | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)

Here is the summary with links:
  - [net-next] tulip: windbond-840: use module_pci_driver to simplify the code
    https://git.kernel.org/netdev/net-next/c/95b2fbdb9321

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


