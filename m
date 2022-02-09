Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226154AF2BE
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbiBINaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbiBINaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:30:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B10C05CB8E;
        Wed,  9 Feb 2022 05:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D2B1619E3;
        Wed,  9 Feb 2022 13:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B50C5C340EF;
        Wed,  9 Feb 2022 13:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644413411;
        bh=9lPNQncCynWQmeWQFAEDCcB4YeBytw/5ZAbh6NQ2tu8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bzhtS21QahzPQy5Swd5ocJ6+bwrsHlZw7rZrdXil0LS2DM3tsvWbkx0f4n54jbeJe
         i2Ayz+RPYd+UzS6aiPKBxBMf4/gJJH1T+D1WuYQ4t5yVFGXub9gXaSGqsasNbVw/vr
         lb3MhFVpExHzepxyUPr34NJV9fhZbDqU5guWD82b65RXgE6ro9Yp3PvAE5D8tOdZpM
         AJLvSGlNWTxTf/pcUTnVxuDF19UbD9DLO9p2dzP2Zg6E4VY0Gd/nxPk37Vl6q0wohO
         tFeZJsJu7cCpa/4dLPE/nFvviwUrBDbSoHWSe8m37x6MkkHwVihcmLCdfkMa1PkMlk
         NDvFujQxGkVoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9C2D4E6D45A;
        Wed,  9 Feb 2022 13:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: cavium: use div64_u64() instead of do_div()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164441341163.22778.9220881439999777663.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 13:30:11 +0000
References: <1644395960-4232-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644395960-4232-1-git-send-email-wangqing@vivo.com>
To:     Qing Wang <wangqing@vivo.com>
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  9 Feb 2022 00:39:19 -0800 you wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> do_div() does a 64-by-32 division.
> When the divisor is u64, do_div() truncates it to 32 bits, this means it
> can test non-zero and be truncated to zero for division.
> 
> fix do_div.cocci warning:
> do_div() does a 64-by-32 division, please consider using div64_u64 instead.
> 
> [...]

Here is the summary with links:
  - net: ethernet: cavium: use div64_u64() instead of do_div()
    https://git.kernel.org/netdev/net-next/c/038fcdaf0470

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


