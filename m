Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D4C48300E
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 11:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbiACKuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 05:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbiACKuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 05:50:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4E6C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 02:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83CAE60E08
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 10:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1AD1C36AE9;
        Mon,  3 Jan 2022 10:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641207008;
        bh=kte68/7XMyW9X1jTCr3WGw82v+g6tnHisJyw+z+iBw8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U/ApbmvQcNNOFfY3HYeDsfKAdpVhLmW3Oljgq1PHVlNOQNo2hmDRt/RfofMMB4IJU
         lyDpwLfODQZ24If8G+v8e/6yS0KEV57jMv7XzczyOvG8IKXYfnoCfaRL/+aWbDsCMY
         A+BLMUxLYwxRweE7FHmY9hzh+fK/UN7ItoYPCobT14M3M+HOjtd7OS+JA3qY7UAnhP
         1nnHZPJzkXQ/5JPQ23ZGFItyS/mQx6tgw1ugLZfVc2Zx+PqZ2daaTvVDw7Be+q8vmX
         h1/uTEY2S/MqwGBzmg3nWRYo/8gict2isDxIVxBcgLaxTXbHY/uk7Czai1EVKuK3Hm
         KF5UZMtbeuSkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ABDA3F79401;
        Mon,  3 Jan 2022 10:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/fsl: Remove leftover definition in xgmac_mdio
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164120700869.2591.17880335370272282976.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Jan 2022 10:50:08 +0000
References: <20220102165406.136860-1-markus@notsyncing.net>
In-Reply-To: <20220102165406.136860-1-markus@notsyncing.net>
To:     Markus Koch <markus@notsyncing.net>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun,  2 Jan 2022 17:54:08 +0100 you wrote:
> commit 26eee0210ad7 ("net/fsl: fix a bug in xgmac_mdio") fixed a bug in
> the QorIQ mdio driver but left the (now unused) incorrect bit definition
> for MDIO_DATA_BSY in the code. This commit removes it.
> 
> Signed-off-by: Markus Koch <markus@notsyncing.net>
> ---
>  drivers/net/ethernet/freescale/xgmac_mdio.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - net/fsl: Remove leftover definition in xgmac_mdio
    https://git.kernel.org/netdev/net/c/1ef5e1d0dca5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


