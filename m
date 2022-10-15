Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B195FF9A8
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 12:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJOKUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 06:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiJOKUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 06:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700172B1B5;
        Sat, 15 Oct 2022 03:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82167B808BC;
        Sat, 15 Oct 2022 10:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C16AC433B5;
        Sat, 15 Oct 2022 10:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665829216;
        bh=lAoPxEd9hihSQsYuYFrqaXn0bxY/2iC/UswM7GGFcq0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AYvhg9q7lzTK0iKiqfBro04AlHEBK+x/3jTmktd6ARVNSC6VbbpBW+LNsYiqnQ+Fz
         HnOLo9Xi2V+By/rN1kRt0gsrnU7Y6fjOVwvIAXz4qbUiTO/dBdV7l9hCiN71mbsxb+
         Q3/LRSFFsDMZNI0tVpq1jDm7taC/ebRmxWSCVtF+hCgKslmE5L392dlKo9W5GTPQos
         QZMxrbVuAynq6EdRt5UEM3Uaznq6U6p+Srqz4qb7/zJaro24QpV0qNwl1cMeBxeBkV
         A7XSM0d9uRsfdegRE+QRaDZwsJYA65AGBYf+XUukX3NB27IZTba27GN1SvPX31WpHx
         Rms4UcCcuqGgA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F1346E4D00C;
        Sat, 15 Oct 2022 10:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: Fix an error code in smc_lgr_create()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166582921598.1299.11979713488950787523.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Oct 2022 10:20:15 +0000
References: <Y0ktLDGg0CafxS3d@kili>
In-Reply-To: <Y0ktLDGg0CafxS3d@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 14 Oct 2022 12:34:36 +0300 you wrote:
> If smc_wr_alloc_lgr_mem() fails then return an error code.  Don't return
> success.
> 
> Fixes: 8799e310fb3f ("net/smc: add v2 support to the work request layer")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  net/smc/smc_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] net/smc: Fix an error code in smc_lgr_create()
    https://git.kernel.org/netdev/net/c/bdee15e8c58b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


