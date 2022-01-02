Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6080A482BDE
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbiABQUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:20:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49608 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbiABQUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:20:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BFF8B80DC1;
        Sun,  2 Jan 2022 16:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC2D8C36AF9;
        Sun,  2 Jan 2022 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641140410;
        bh=p/iCGc/wt1YZV1lUMB7R/UYHEjX60AGaYqZTHTvBOXk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RSIqLtYSG0hhX5KiYUbUE/o6f42CljevdkpXPBHR4taQJwKo/xe745yfFTntMKjBx
         c7vOBq+2NWEYoWB9efMIVLCTnJHJo/Bu/fkMqzCt0bpvBy4UqM3QMBz5y+vHvzZk1R
         /OtPycKIAaj2rXd36R2rfHYt+h2hSwZafQef9ZaZIrRzh6sLrRjpgkxIsqRbM4LoK4
         JjAiNVKxhXQXwj+55kRyIlGO3T+Lld9c6S7sJngMsVO6SljO7ScLExUO2V/47RMvCx
         /6pVdLwsG1EejMCxnteYp2CDaHkvhjNMA0EWifcXccYOMAdajhMlSUhUcneueBh6P3
         ns1QGSUSJaG3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3D5CC395EA;
        Sun,  2 Jan 2022 16:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] chelsio: cxgb: Use dma_set_mask_and_coherent() and simplify
 code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164114040986.20715.4957244100970537500.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 16:20:09 +0000
References: <80d7dd276d9be857f090fbe1f3dbbdc4b07141ec.1641071656.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <80d7dd276d9be857f090fbe1f3dbbdc4b07141ec.1641071656.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     bigeasy@linutronix.de, davem@davemloft.net, kuba@kernel.org,
        tanhuazhong@huawei.com, arnd@arndb.de, moyufeng@huawei.com,
        chenhao288@hisilicon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  1 Jan 2022 22:15:29 +0100 you wrote:
> Use dma_set_mask_and_coherent() instead of unrolling it with some
> dma_set_mask()+dma_set_coherent_mask().
> 
> Moreover, as stated in [1], dma_set_mask() with a 64-bit mask will never
> fail if dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> [...]

Here is the summary with links:
  - chelsio: cxgb: Use dma_set_mask_and_coherent() and simplify code
    https://git.kernel.org/netdev/net-next/c/1aae5cc0a55c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


