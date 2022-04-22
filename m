Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56FB950C55D
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 02:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiDVXxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiDVXxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:53:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0522B1ABF;
        Fri, 22 Apr 2022 16:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8304C61EC0;
        Fri, 22 Apr 2022 23:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0E32C385AA;
        Fri, 22 Apr 2022 23:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650671411;
        bh=ME6vr3xeVTBMLcmAeaUvTXyNGGUWwnb3GH9N2NotUmw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Im/gJ8MWoDT3RY3+Hy0Rjqf+vygJLxyhtdhv2qjLos7Bx3hX0ZlE2WPfnOeljOXss
         ZXjJbGurY3hPwrJaGP2bcJTgtCRbGWVFeJCYu7Oc6Rzqi8B/2F896WYmDvl2sNO8SK
         /CB8L74Li2ZaRRU9njItl52wuzgEP8YcJfVAM753W4KR1LzQzjWqzWSpO+Y7por8en
         J8oLqjIjy+7pVaCL4QngGE5neopUxSkmHKe4f5VJbT2mCtSg1QucZ5SPvLnqWJRg8J
         d83jyFjcewQIZG/5M2XYPwnzfRfcpJma5j9oAqMosoaz/cAZ2LnuHLqBO5C3Hrp0xB
         ik20akkBaoYug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7D74E8DBDA;
        Fri, 22 Apr 2022 23:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: hns3: Fix spelling mistake "actvie" -> "active"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165067141174.16286.17854833074663901294.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 23:50:11 +0000
References: <20220421085546.321792-1-colin.i.king@gmail.com>
In-Reply-To: <20220421085546.321792-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 21 Apr 2022 09:55:46 +0100 you wrote:
> There is a spelling mistake in a netdev_info message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] net: hns3: Fix spelling mistake "actvie" -> "active"
    https://git.kernel.org/netdev/net-next/c/31693d02b06e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


