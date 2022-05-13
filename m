Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBAE526054
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379570AbiEMKkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 06:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379541AbiEMKkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 06:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B7A28B854;
        Fri, 13 May 2022 03:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9F46614FB;
        Fri, 13 May 2022 10:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 30924C34114;
        Fri, 13 May 2022 10:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652438416;
        bh=t+j2oa0sybV7dpErO/Q6VSoSiLVS3Ad1s7QqbLdvJL0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pIsWii6X8QcgtsWvhRaP2wkzZeRLhz3bPxkC69fjDD9eES9nD5Ew55L3Q4tB7MbrQ
         uqJwZqLk1yoDq908WDPmOTQeKrXVMqVoGh6cAfjVLMZTKlou90wHU7hVex8yZ6UCkd
         TeKAxRH7S98faImX2dF6Hi5Gqf8utzxW+Oor8bRTPqBhKeXpgXABp35kFYFTTvuEAh
         j3dDhxuDq4/02sDCorIQIErwxbMxLCaU3nVk9FHYqsdO+NNnJ8bCqpx+wGuu7gEdtg
         Q5MVCpHFj8e0l8uEVgRHHg+ynWSqwnc9xWLHdSIfG0zjkICiDJinAasxAIZaQqV//a
         dCsqElYURR/8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 17DF7F03937;
        Fri, 13 May 2022 10:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: ethernet: fix platform_no_drv_owner.cocci warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165243841609.19214.3757815327753045737.git-patchwork-notify@kernel.org>
Date:   Fri, 13 May 2022 10:40:16 +0000
References: <20220512080357.44357-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20220512080357.44357-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     wellslutw@gmail.com, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, abaci@linux.alibaba.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 12 May 2022 16:03:57 +0800 you wrote:
> Remove .owner field if calls are used which set it automatically.
> ./drivers/net/ethernet/sunplus/spl2sw_driver.c:569:3-8: No need to set
> .owner here. The core will do it.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [-next] net: ethernet: fix platform_no_drv_owner.cocci warning
    https://git.kernel.org/netdev/net-next/c/7b8b82224c26

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


