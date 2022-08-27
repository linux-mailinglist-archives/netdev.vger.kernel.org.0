Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8BF5A332A
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 02:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241599AbiH0AkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 20:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiH0AkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 20:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA05613CDD;
        Fri, 26 Aug 2022 17:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D3C9B83369;
        Sat, 27 Aug 2022 00:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B463CC433D6;
        Sat, 27 Aug 2022 00:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661560814;
        bh=rkzh3nR20qW/jQRU/zac4HyBSh6rIWKYlUSOlnHbI4A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c569Bwb5eXT6yVQHpZh7AKQXJF8J29T8tup8DzsnA0ZRyUrHVU5sm4uQfQj/PzBFz
         /xU9AKRFRaDyzpCKTBfGx2KAsjT3WIRecDwPiGanC+M6oTLcKkANal6uXUvznpQ4I3
         6lLOGUTQ6qU5dgU11efBv3avC8HSIWt5EBvhVM41d1FyRbuAZ2BECstSc4oLcYEh8L
         feDP9X5YIrjOo4f1UAwj3spgFWYZSBmktzlvBtWvN/KKVkcCBtCEZoD2rQyvFc7MHm
         wDu6J8TdqOdll3dChktz1NeOGBDb8AcYLpEoFY0j847PM71mgXlGKr9KzVCI4ouHHQ
         vF40SgVxrMOjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99FDDC0C3EC;
        Sat, 27 Aug 2022 00:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/mlx4: Fix error check for dma_map_sg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166156081462.5783.10194691553134779123.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Aug 2022 00:40:14 +0000
References: <20220825063533.21015-1-jinpu.wang@ionos.com>
In-Reply-To: <20220825063533.21015-1-jinpu.wang@ionos.com>
To:     Jinpu Wang <jinpu.wang@ionos.com>
Cc:     kuba@kernel.org, davem@davemloft.net, tariqt@nvidia.com,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        leonro@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 25 Aug 2022 08:35:33 +0200 you wrote:
> dma_map_sg return 0 on error.
> 
> Cc: Tariq Toukan <tariqt@nvidia.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> [...]

Here is the summary with links:
  - net/mlx4: Fix error check for dma_map_sg
    https://git.kernel.org/netdev/net-next/c/0c1f77d87d69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


