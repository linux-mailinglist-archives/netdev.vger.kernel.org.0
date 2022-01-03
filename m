Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C9948300C
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 11:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbiACKuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 05:50:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57522 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbiACKuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 05:50:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21F2A61023;
        Mon,  3 Jan 2022 10:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86957C36AEE;
        Mon,  3 Jan 2022 10:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641207009;
        bh=Nt8rKJVx8L07QrjNrtOBcZ4c2qEOLYPssokLETed7ZU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OzwP/DZJpy19MOour9UXjU6NzLq4omAHTk1bJkwdnxt7ZdJ1J9oDRFgcsOYBXGG1L
         Ks3BTtW6lnAMZs/simQ1hqNp2QujK1zjsxd+xuTGlBTXMELwXaBh3NuZtxM4UFEUgs
         T+1DzogXJUPWwC6EXV2b8j59SnJnwM2A6PCKNqSSdtwy22sNEzm4UGL+l71eMp1q2L
         f/moHa6sSLFXbaGsHErh1TYCO9eK4kxwwiLnoMD8ng3IkS9fkQSHlCyGdvtKWC3IH9
         tTFxuArFXcUMOvGin4gdtRnq5GplmN4l0cWODwWmM+uv6Tl9uD8OL/brWj3mN6vyZ5
         DUFzQSs/hrM7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74C37F79402;
        Mon,  3 Jan 2022 10:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: vxge: Use dma_set_mask_and_coherent() and simplify code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164120700947.2591.17033109564004070251.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Jan 2022 10:50:09 +0000
References: <6e78ed8aef3240a2cbacb3e424c6470336253e47.1641157546.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <6e78ed8aef3240a2cbacb3e424c6470336253e47.1641157546.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jdmason@kudzu.us, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com, liuhangbin@gmail.com,
        colin.king@intel.com, zhengyongjun3@huawei.com,
        paskripkin@gmail.com, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun,  2 Jan 2022 22:07:05 +0100 you wrote:
> Use dma_set_mask_and_coherent() instead of unrolling it with some
> dma_set_mask()+dma_set_coherent_mask().
> 
> Moreover, as stated in [1], dma_set_mask() with a 64-bit mask will never
> fail if dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> [...]

Here is the summary with links:
  - net: vxge: Use dma_set_mask_and_coherent() and simplify code
    https://git.kernel.org/netdev/net-next/c/3d694552fd8f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


