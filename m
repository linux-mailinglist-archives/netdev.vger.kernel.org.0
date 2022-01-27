Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB56949E3FE
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241661AbiA0OAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:00:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54838 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241028AbiA0OAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 560F961CBF
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB5B4C340E8;
        Thu, 27 Jan 2022 14:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643292012;
        bh=hrAMr1V+LwybgUtHSnTVnAaUGsZhHLWmSjeU9m0M2fc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DJTQhLjUOxZNmDk/2bSyvl2pcQhokz+Tty23sTKgmAphPKfEZypv+y75wJ9TDvsSN
         bt5MP83sNgdz7nx/Z52ttu0LoG0B3nhprHIZ5XXxXlFvfjOJJmFx54TRv6Xk0btKXn
         Bq5Sc8BOlb/3jLRoB5phmiXdY2EssGvkYq/nTkG/i+BqyzDSRLB/VHV1zrZWV/bMDD
         zRUUWr7v9vnjkZUUA+rLgPz6wL4XhG1c5zM46cdIIs7lmPqwoNKWHKH748ACkVtp4s
         xvqanNYKMmKMp7zsekwTTLRfHwVHf4e9OUgaPtazB42ktC21MTyw6c9e56MrbRbqlA
         f9Cg90AF//Ovw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA7C8E5D08C;
        Thu, 27 Jan 2022 14:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: mtk_star_emac: fix unused variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164329201269.13469.13076213367869775961.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 14:00:12 +0000
References: <9da2bbc0fc7f785f6ea43128b72bc6b8b4e23093.1643192687.git.lorenzo@kernel.org>
In-Reply-To: <9da2bbc0fc7f785f6ea43128b72bc6b8b4e23093.1643192687.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        bgolaszewski@baylibre.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Jan 2022 11:27:05 +0100 you wrote:
> Fix the following warning in mtk_star_emac.c if CONFIG_OF is not set:
> 
> drivers/net/ethernet/mediatek/mtk_star_emac.c:1559:34:
>     warning: unused variable 'mtk_star_of_match' [-Wunused-const-variable]
>     static const struct of_device_id mtk_star_of_match[] = {
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: mtk_star_emac: fix unused variable
    https://git.kernel.org/netdev/net-next/c/a9c5eb642f53

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


