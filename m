Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300CC61352F
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiJaMAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiJaMAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69F35588;
        Mon, 31 Oct 2022 05:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83C92611C8;
        Mon, 31 Oct 2022 12:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3958C43140;
        Mon, 31 Oct 2022 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667217616;
        bh=S+twGuGOYDf7kP2wsyHW6PL3iq4P3hFaKpE8XvwADTY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NEjKiC0ntOJIGMQnd2Lvh7L7BFV6UNAkP6pV/K32ftwMHSUdrHIuwTSVJr3ahuhJq
         tv2qLH78Xx6l71P65/RU9NmGmSqGF6veGZh76q7s8wZ5CLscucCehylRYQzhUf9oxo
         iAWQ1yrjtW1Sx5u353RTyWvj0S2HywSjuKyaEpbpuOW+l+ft+UMtxraEHlwMSu9AXh
         JvfLalPmCezDQvboOLXmXleIeAbyDEAEq6KWyuRqQj1vQ5KXMDvHTtetT4sqSl9t1y
         gZI/gw+ayFUBiqk2LwDeygfG4ln7dB+taI0QWOF1EX+qiUUDJdSnh8qICPT7gvmpYd
         S1flwr/q3R6+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C0994E50D71;
        Mon, 31 Oct 2022 12:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mvneta: Remove unused variable i
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166721761678.1563.9202612383294369590.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 12:00:16 +0000
References: <20221028123624.529483-1-colin.i.king@gmail.com>
In-Reply-To: <20221028123624.529483-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     thomas.petazzoni@bootlin.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Oct 2022 13:36:24 +0100 you wrote:
> Variable i is just being incremented and it's never used anywhere else. The
> variable and the increment are redundant so remove it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - net: mvneta: Remove unused variable i
    https://git.kernel.org/netdev/net-next/c/0cf9deb3005f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


