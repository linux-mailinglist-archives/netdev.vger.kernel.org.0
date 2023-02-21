Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11B969D7D3
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 02:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbjBUBA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 20:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbjBUBA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 20:00:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DB92310C
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 17:00:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F3BFB80E0E
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 01:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA05EC4339C;
        Tue, 21 Feb 2023 01:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676941222;
        bh=WnvmcTTl6pTM96zX2EjdrjXlbOcrFObgGCS1IYevsvw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cwufg6KJ50soNfFbeBL/rUV6dofUMOzzoqEI0aa5XKme9SEROhTUQ/821wK8is8pX
         Cp2EGEnND/r5TeSPTQvXWYMFSJTDl5nDGyEunl/kl5RjWT1Xk2gHQeo79Up2/nVO+Y
         PnIJb+tMhKAh3b1Yqq47ht7Eq+zAYzUZBIx1tNzO+GudCDoBokkkdu9L1CFRvTOTzz
         FVutYuuq1qoEQ7vK5Q9IQHSiLhEeJdimxL/eBmGaKsb/0PT7QO6AAqzHLrBTFhLt70
         oyxc8cxdfBUr/VkWCTBw7pETEUfjAsWbppp+05pJTJCxlW3MQqjSdCS0YWuXi3tAsK
         nn2LPer/JxjKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF2CCC73FE7;
        Tue, 21 Feb 2023 01:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5e: Align IPsec ASO result memory to be as
 required by hardware
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167694122277.14671.15906311117907111221.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 01:00:22 +0000
References: <de0302c572b90c9224a72868d4e0d657b6313c4b.1676797613.git.leon@kernel.org>
In-Reply-To: <de0302c572b90c9224a72868d4e0d657b6313c4b.1676797613.git.leon@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        ehakim@nvidia.com, edumazet@google.com, netdev@vger.kernel.org,
        pabeni@redhat.com, raeds@nvidia.com, saeedm@nvidia.com,
        steffen.klassert@secunet.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 19 Feb 2023 11:09:10 +0200 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hardware requires an alignment to 64 bytes to return ASO data. Missing
> this alignment caused to unpredictable results while ASO events were
> generated.
> 
> Fixes: 8518d05b8f9a ("net/mlx5e: Create Advanced Steering Operation object for IPsec")
> Reported-by: Emeel Hakim <ehakim@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5e: Align IPsec ASO result memory to be as required by hardware
    https://git.kernel.org/netdev/net-next/c/f2b6cfda76d2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


