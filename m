Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8DF4B7378
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239493AbiBOPAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:00:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239440AbiBOPAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:00:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00DA2FFF1;
        Tue, 15 Feb 2022 07:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51F456152E;
        Tue, 15 Feb 2022 15:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6834C340ED;
        Tue, 15 Feb 2022 15:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644937211;
        bh=to3kVmcmgn+U0rI3lcpooQyf3iB2cKOoG3gY96rwPiM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=usMkd1JtbCVgwtDWRhw6y2Fqh53H1Go9cNxd8KdmHWXiRzEWDgtVmXqdXfgKfMyj4
         c9U2P+a9RTB7fwDJ491hXXYJLLjb+1VwdQ5DxtqQG9tuF7fl/KbI9mVz/ZIxWA6kRx
         h4HmLNx+nYRatMzqiTugq8PDueCD2SDM1sV9WFAx32eyl+1kTWgPqhx+Lj+T/mjd73
         T3gCR7SJ//KKLkcrhd4Ebu6pVDYZTjGmubb1Ph9Q77jXzsAJz60IH0Su6PAuoD0/pD
         i/jcG933tFOYvUe7KovXp+m8SiFgKfIwPRp/hVQ0m74XLgzJU5Ub9O94/6jSeoOiL4
         w06TiuvQLaBcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A245BE74CC2;
        Tue, 15 Feb 2022 15:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: dm9051: Fix spelling mistake "eror" -> "error"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164493721165.12867.10859876993004985508.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Feb 2022 15:00:11 +0000
References: <20220215103920.78380-1-colin.i.king@gmail.com>
In-Reply-To: <20220215103920.78380-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, josright123@gmail.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 15 Feb 2022 10:39:20 +0000 you wrote:
> There are spelling mistakes in debug messages. Fix them.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/davicom/dm9051.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [next] net: dm9051: Fix spelling mistake "eror" -> "error"
    https://git.kernel.org/netdev/net-next/c/2c955856da4f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


