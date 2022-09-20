Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B8D5BEEBE
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 22:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiITUuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 16:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiITUuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 16:50:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422314D178;
        Tue, 20 Sep 2022 13:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C72BC614B5;
        Tue, 20 Sep 2022 20:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25605C433D7;
        Tue, 20 Sep 2022 20:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663707018;
        bh=KjOtBowGvvlXkY0CJ/ZXa41LgAc2HijH/N9ZoIAn4Vw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OVvBlnI32wtXmw49Ixv3W+jIyVKJlYTch98OR7gtaudqrUJhOt7B7HzLZpIi8KEGf
         24UizCAQDwboJ31NnOQuZc8G5pjA9L7zQuLa1M2cADVXV9azHbQAUb05sn0ekZCYb9
         nNVNdGCJIqqhPAIdAH2IYKhc8JXa3q8C70rvhtYZ3eMTIVh+Li4rIICcImFikEnPJZ
         gDkmBm1Kp3Ft6gLrzyiplZN6QVS19jxGZo8aba5leU/XHTM5o+ewUB1fKokV25Okd6
         wp6PLNZ2kL4bkJOZev7e5LKwlCDVY5NCa9wSQbTl42NyHABdw/NsUP7nR3V/BoivGd
         l9UC6uHF43FCA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 057DFE21EE2;
        Tue, 20 Sep 2022 20:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: Add myself as a reviewer for Qualcomm ETHQOS
 Ethernet driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166370701801.15267.18212299614611715724.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 20:50:18 +0000
References: <20220915112804.3950680-1-bhupesh.sharma@linaro.org>
In-Reply-To: <20220915112804.3950680-1-bhupesh.sharma@linaro.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        vkoul@kernel.org, davem@davemloft.net
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Sep 2022 16:58:04 +0530 you wrote:
> As suggested by Vinod, adding myself as the reviewer
> for the Qualcomm ETHQOS Ethernet driver.
> 
> Recently I have enabled this driver on a few Qualcomm
> SoCs / boards and hence trying to keep a close eye on
> it.
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: Add myself as a reviewer for Qualcomm ETHQOS Ethernet driver
    https://git.kernel.org/netdev/net/c/603ccb3aca71

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


