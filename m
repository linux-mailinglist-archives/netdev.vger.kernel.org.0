Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFF549AA43
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1325129AbiAYDf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415505AbiAYBrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 20:47:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759ADC01D7C8;
        Mon, 24 Jan 2022 17:27:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13E4361214;
        Tue, 25 Jan 2022 01:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7807CC340E5;
        Tue, 25 Jan 2022 01:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643074019;
        bh=jHdoOJoEuHZBeA+OwrUqeObi/wvxQlAIyr5XxNX6914=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VqDOV0m3mR3XjIf70NBI/GUkCqpGemEz98EzNc3qyUJgVPHRt/iPbs3IEibvfG2ey
         UcRFAKDHCk3631inXq+kwKELB+IDWWx5sey0IWYLiNoA9pWjmPgFFTVfLYI48q+RsD
         nXTUhYnAVSMu4yvSdSll6OjeCivkKrakLvDsuACeStnfAVDjLmV5Wly+y64Twssekz
         R+teu/QpJ/Lnza0K2OuzKNBhBXHLC3lnIRroAG7UbAP/2BtnKlPl+Z6B/mq3fPSYgG
         rTGWj5V0glQivlccxyYYVFv8G2J9i21MFqVk2CbQJ45cssPUG7PAgOSPZ99EGBTokZ
         UXXwdyM1l9mLQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5F51BF60799;
        Tue, 25 Jan 2022 01:26:59 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fec_ptp: remove redundant initialization of variable val
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164307401938.21160.8256923052141890317.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Jan 2022 01:26:59 +0000
References: <20220123184936.113486-1-colin.i.king@gmail.com>
In-Reply-To: <20220123184936.113486-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 23 Jan 2022 18:49:36 +0000 you wrote:
> Variable val is being initialized with a value that is never read,
> it is being re-assigned later. The assignment is redundant and
> can be removed.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/freescale/fec_ptp.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - net: fec_ptp: remove redundant initialization of variable val
    https://git.kernel.org/netdev/net-next/c/6e667749271e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


