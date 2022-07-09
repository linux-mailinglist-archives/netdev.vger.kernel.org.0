Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D29C56C677
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 05:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiGIDkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 23:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGIDkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 23:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AE1820EA;
        Fri,  8 Jul 2022 20:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B1BB62570;
        Sat,  9 Jul 2022 03:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C816AC341D2;
        Sat,  9 Jul 2022 03:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657338014;
        bh=lE2PVEPxqRNGTbJvL9bWQMNpBHMUyAcItHBtuqh/I50=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r/VEAVSTn45UXmNDgG5APLa5IMEpKxMvFIm/1cyL04obJLLdvKhUy47IXMvpijKrs
         iBerH0GKWTOEAFUelVj8aD2crdNLJOKna+Qn4k7WNB2mPg8xGNzkA/tWnwosyY+9Vq
         DUO3CEw1naVwX1PyC1nps2Uyng9Y11OA1vr0KJEVXOlusIR+YGFMkUOYv03IW/dIcJ
         pqeGbA5+jHxeb5PWfZ8aDYcLYlkZO9tq5mNkuUEN5ZoBx7S5X3te6HJYJBW6Yi7vxl
         DNaMWVq9FHxMqwyzf6hSJ5vkyhX/akIAwfvGfaCO5iPSYzDO8xSE8iPZNIYQ/kndRF
         sKxpD9Sq0QHrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A96E0E45BDA;
        Sat,  9 Jul 2022 03:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] bcm63xx_enet: change the driver variables to static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165733801469.11477.12428383942921107428.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Jul 2022 03:40:14 +0000
References: <20220707135801.1483941-1-yangyingliang@huawei.com>
In-Reply-To: <20220707135801.1483941-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 7 Jul 2022 21:58:01 +0800 you wrote:
> bcm63xx_enetsw_driver and bcm63xx_enet_driver are only used in
> bcm63xx_enet.c now, change them to static.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/broadcom/bcm63xx_enet.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [-next] bcm63xx_enet: change the driver variables to static
    https://git.kernel.org/netdev/net-next/c/9f7cb73ef64b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


