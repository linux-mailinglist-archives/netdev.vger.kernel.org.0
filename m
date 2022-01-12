Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51E048BE16
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 06:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349097AbiALFUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 00:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiALFUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 00:20:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D74AC06173F;
        Tue, 11 Jan 2022 21:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 265186181B;
        Wed, 12 Jan 2022 05:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 772D8C36AEB;
        Wed, 12 Jan 2022 05:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641964810;
        bh=AzOdyxdNLcpXZj9rSQnl4af/zL3oy00xjDvN9zKnUGw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JZcEfcgOFueGdlUrv5DPGvdqpj2CTZHZQEUKA9mfl0aVmdSAiyxWujLzYLcFlN2ZB
         Rqla+H9bgcKN9vEC507vFbUspM0SbpWCrq3F8ensUog9UobwUG7dnzKv3kkse5hyyX
         Gx3EDUe2lAkxAw+SpfN+WE9IvrNZ/gF046BEKqRM3Xba+EsUxFoxmr8Y933kuF1uRm
         haVDCDID7pEGqoNpv1TqwNjunvMQEYpXOtxsRzgO7p02fZQGeyh0hoXd67Ke1ucpC5
         +UwNdEzqsVGd95bKwAaAqO/TKyzf++pBq9U/LsZvC8dVzdqscnvg1UdfeLihBh92AH
         5HuV37kVk7QCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5762DF60796;
        Wed, 12 Jan 2022 05:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: pn544: make array rset_cmd static const
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164196481035.2105.15169178738336777997.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Jan 2022 05:20:10 +0000
References: <20220109202418.50641-1-colin.i.king@gmail.com>
In-Reply-To: <20220109202418.50641-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     krzysztof.kozlowski@canonical.com, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 20:24:18 +0000 you wrote:
> Don't populate the read-only array rset_cmd on the stack but
> instead it static const. Also makes the object code a little smaller.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/nfc/pn544/i2c.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - nfc: pn544: make array rset_cmd static const
    https://git.kernel.org/netdev/net/c/e110978d6e06

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


