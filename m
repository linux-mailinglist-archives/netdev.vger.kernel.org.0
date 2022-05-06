Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3576951CE45
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388152AbiEFBx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388142AbiEFBxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:53:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096F462A29
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 18:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99F7662044
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 01:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4501C385AC;
        Fri,  6 May 2022 01:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651801813;
        bh=S+1piw3bR98/WvXKMO/nSrz9ojI88U2ZYuIdzezM8+U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s/NR+xBsCY7+veOFhppArShOl8s8AAJB5ESD+h7ueth0G8ls7ENujibpMslPkzoCV
         biVoT/fMMdggJkP532o/XgfRRM4vwS3N9mTHx3377P7iW9zXN9HbwDS4F2C8jAci0D
         nCH+2toj98iacMpkSBvfZEJdxBa8SP7Tf3vDbbjjTmrn87prpt3Tn/f/Qg02Vfqg3+
         MuUE3XUsEMZyniNa8vVwAH9mr62I//TUv8jyFKh0Q+/qyDxuQnZ/qGHucUxGW5W4ey
         KOdNvwsSEPYWf331/5bz5WZm71u2FezMY6Z0mqOt2Q8PuCT04jXDdauiKqcwP/XxWO
         5WblMWlg0mdOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C03A7F0389E;
        Fri,  6 May 2022 01:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: Fix features skip in for_each_netdev_feature()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165180181278.30469.7040851368260362493.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 01:50:12 +0000
References: <20220504080914.1918-1-tariqt@nvidia.com>
In-Reply-To: <20220504080914.1918-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        gal@nvidia.com
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

On Wed, 4 May 2022 11:09:14 +0300 you wrote:
> The find_next_netdev_feature() macro gets the "remaining length",
> not bit index.
> Passing "bit - 1" for the following iteration is wrong as it skips
> the adjacent bit. Pass "bit" instead.
> 
> Fixes: 3b89ea9c5902 ("net: Fix for_each_netdev_feature on Big endian")
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net] net: Fix features skip in for_each_netdev_feature()
    https://git.kernel.org/netdev/net/c/85db6352fc8a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


