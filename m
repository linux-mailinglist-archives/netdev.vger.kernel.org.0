Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B90488D8C
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 01:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbiAJAuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 19:50:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53460 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiAJAuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 19:50:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 700B561043
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 00:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E925C36AEB;
        Mon, 10 Jan 2022 00:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641775810;
        bh=aEOY+ZQXRYHxYybxZHZLsxsa37ozTJNha+Liz4Z/kZE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NkCdbqbDBY2peXpefeAuC8RpMq1E+rhpdaz3k7NZx4s6hlNi/IwevqiujeJNPppTo
         NADGmRkkxvPf50bY2mL062+Hx587Fv7gLYskdxlBfzslIskbEoCkOaoximjFtXRiZO
         Ng6cJbB4BKOj1nm54hV2Fr4XGwlAyKaOBnyKuM1FUVoZGxRinZyUAKbmMnXSiwqF6f
         LzeB5KX79RNRENrxNvNdXcx3zAHrwl8CFp1ALl/eTBRmBULCsmphCktmtlDPbSVxuO
         tgxI03Jxn8pTPveO4vtzeWfQu/5iaQcrspdurVBqbYWarlDkUMdPPLFmJf8yZjC8ok
         udjmBWORqYYZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B120F60790;
        Mon, 10 Jan 2022 00:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5e: Fix build error in fec_set_block_stats()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177581049.14212.11112437586048648389.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 00:50:10 +0000
References: <20220109213321.2292830-1-kuba@kernel.org>
In-Reply-To: <20220109213321.2292830-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, saeedm@nvidia.com,
        leonro@nvidia.com, lkp@intel.com, leon@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 13:33:21 -0800 you wrote:
> Build bot reports:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_stats.c: In function 'fec_set_block_stats':
> drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:1235:48: error: 'outl' undeclared (first use in this function); did you mean 'out'?
>     1235 |         if (mlx5_core_access_reg(mdev, in, sz, outl, sz, MLX5_REG_PPCNT, 0, 0))
>          |                                                ^~~~
>          |                                                out
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5e: Fix build error in fec_set_block_stats()
    https://git.kernel.org/netdev/net-next/c/342402c42690

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


