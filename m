Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953F8520829
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 01:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiEIXOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 19:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiEIXOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 19:14:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D452B29743E;
        Mon,  9 May 2022 16:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7892C611E1;
        Mon,  9 May 2022 23:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C75FBC385C3;
        Mon,  9 May 2022 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652137811;
        bh=DYjOzkKhHPeQqTfoxCr+QZ3wi0zP8JSixvmnYJsK1WM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rsqSkG5B1EXLVgaMWZUfF5hjzd8Wq3fhQdXlfBYKpY4Uzyn23/ldQ9Sey8TVb/K/V
         UD66sRzOwHzDjLLU7r2wOrnFLj1zxM7ocUIZEuU0kO9IwmcDMrsLz9/O/8YHJLQRLJ
         Y6yXeKTPXMVSJ8D9B8U4UQDKCHp+8tyj6N1wX3QCb9otchfyAUs2tyj/WwmOba+d9H
         14h6ZVKrvgMI0llZnDYE/hFRke/vk/TAZ59974H/ndplA8wjTG6Yu8J32PdvWFbSrA
         W/nQLOfRL2/mjMjOttqhebCrPZW7yO5NZa93LfTSN7g81jRFFmmR313TbszQABeYya
         U4TLWZRj1rTRg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD9D3F0392B;
        Mon,  9 May 2022 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet: tulip: fix missing pci_disable_device() on error in
 tulip_init_one()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165213781170.14018.4375827334756602076.git-patchwork-notify@kernel.org>
Date:   Mon, 09 May 2022 23:10:11 +0000
References: <20220506094250.3630615-1-yangyingliang@huawei.com>
In-Reply-To: <20220506094250.3630615-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 6 May 2022 17:42:50 +0800 you wrote:
> Fix the missing pci_disable_device() before return
> from tulip_init_one() in the error handling case.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/dec/tulip/tulip_core.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Here is the summary with links:
  - ethernet: tulip: fix missing pci_disable_device() on error in tulip_init_one()
    https://git.kernel.org/netdev/net/c/51ca86b4c9c7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


