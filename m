Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739654274B1
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 02:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244008AbhJIAcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 20:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231975AbhJIAcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 20:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9F32760FC3;
        Sat,  9 Oct 2021 00:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633739407;
        bh=YhzapLlD2b8w64WjalOGhJStWCdozlftcCBZdrHIFKg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UUhCluffkvVEHUF/kx8stsKsMU02rMWawGCAova+LOBglWs2UbNC24kyFygEtbkCt
         2OyUVoZdi8dzCxmcjUaYxpO397GhwGEsNWaObBPMDUu7Taby9xUxK+jhaRGpbut3YM
         9wttvzN+LS6nEK2FF4jJK8uAlA/uHcUarmojBt9fCfST6SMkbx1CcEX1qWLOk8yS5S
         QoVm4USaR+xb2GSnBJ/DmME2lm0bPSokpszRSeCRJA7YOn1KAFptoUwFXmgU3qRW+n
         hIwtyoI0HhVu0tAknq4wedPhTHfx6vW02uaIYEr+oKxRUxtrzqIqc076ISXWX4VKEj
         T9EXbtYlVwIyw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9194660A38;
        Sat,  9 Oct 2021 00:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2,net] net: mana: Fix error handling in mana_create_rxq()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163373940759.10203.3853753861384323051.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Oct 2021 00:30:07 +0000
References: <1633698691-31721-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1633698691-31721-1-git-send-email-haiyangz@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        kys@microsoft.com, sthemmin@microsoft.com, paulros@microsoft.com,
        shacharr@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  8 Oct 2021 06:11:31 -0700 you wrote:
> Fix error handling in mana_create_rxq() when
> cq->gdma_id >= gc->max_num_cqs.
> 
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [v2,net] net: mana: Fix error handling in mana_create_rxq()
    https://git.kernel.org/netdev/net/c/be0499369d63

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


