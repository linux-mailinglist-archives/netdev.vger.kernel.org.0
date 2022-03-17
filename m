Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33A74DD171
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 00:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiCQXvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 19:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiCQXvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 19:51:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC962B04C6;
        Thu, 17 Mar 2022 16:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60ECBB820F6;
        Thu, 17 Mar 2022 23:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1F31C340F6;
        Thu, 17 Mar 2022 23:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647561013;
        bh=s/uzjXFtGIXKc01OR/pFV1FwrMKMh3VZerdx1mKXWng=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DORmnQmc0fymHtKx2U57oXPUPR4yBSMgo4cy4WYUwvojfFk3/o56mRGe7DzeHmPyS
         qXNPOVOZbfnCejEr8oPGD7jffYsMbkjTDUhgEnOiS7dm7w4E/T9UVNkYztCxJQWjFd
         7r2RzaMyyFgI9OCWRRpdryJhgkhAvR9N8qLL71S441ViJdh6ZqUAWH/OIU+3wIPdMi
         PzNcWhuSjas2+lPrz3mpKNbnqPMRL7ycZZUv/UCNkvcpraZVwigai/0TgUn+nhoNke
         StsTaQJ8qdYPy1UIGZtqbdZRTB7Ntdbb00LgU3eD6Gjm/Tlqw1fxv+xIINx2CONdaU
         /OkpTR7qcKF1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3665F03843;
        Thu, 17 Mar 2022 23:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet: sun: Fix spelling mistake "mis-matched" ->
 "mismatched"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164756101286.14093.12322733555904014333.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 23:50:12 +0000
References: <20220316234620.55885-1-colin.i.king@gmail.com>
In-Reply-To: <20220316234620.55885-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Mar 2022 23:46:20 +0000 you wrote:
> There is a spelling mistake in a dev_err message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/sun/niu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - ethernet: sun: Fix spelling mistake "mis-matched" -> "mismatched"
    https://git.kernel.org/netdev/net-next/c/21c68644ff83

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


