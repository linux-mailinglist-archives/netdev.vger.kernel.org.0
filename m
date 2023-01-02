Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CEB65B2C4
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 14:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjABNk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 08:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjABNkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 08:40:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB006CC1
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 05:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B218B80D50
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 13:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E341C433F2;
        Mon,  2 Jan 2023 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672666816;
        bh=SlhFXHN8X6CLqDuwroB0aXpxpXx5X5K3JYO2Mk0l3EI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ga6RXkyrbX6nT08uGYWVcGVf1OoVPlMBJ3hF22sfdxFNFOu1Zp005D2V1FMr1g8m+
         Zaur/7Ua0u4S8KMjmPQdQGRz3DfeoHVw3Ax17ju2HaYrDzQVFXrabhZFN6nHV33QkQ
         orbANK8KnwUUtk5rtjRa+T/lHZFKCdpLDMAkyG73kAxwh979LICPjy4YBlnQaga3yg
         ORR3AoWBJzZk7jOJR1sJUvzPXqn7vQfi41CfnM//9M3w8Ru6Ung0C71Lf+sUtV2UX3
         zZ9BlXfF2rUDhs9zK5rFdIVRPOa6kP0OZjL5tkm4nO4FrH37UvOYLXJiKCj5GReRqv
         F15YBPkuFg3OA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1CF19C395DF;
        Mon,  2 Jan 2023 13:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vxlan: Fix memory leaks in error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167266681611.16415.16611714454863689111.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Jan 2023 13:40:16 +0000
References: <20230102065556.3886530-1-idosch@nvidia.com>
In-Reply-To: <20230102065556.3886530-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, roopa@nvidia.com,
        razor@blackwall.org, mlxsw@nvidia.com
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

On Mon,  2 Jan 2023 08:55:56 +0200 you wrote:
> The memory allocated by vxlan_vnigroup_init() is not freed in the error
> path, leading to memory leaks [1]. Fix by calling
> vxlan_vnigroup_uninit() in the error path.
> 
> The leaks can be reproduced by annotating gro_cells_init() with
> ALLOW_ERROR_INJECTION() and then running:
> 
> [...]

Here is the summary with links:
  - [net] vxlan: Fix memory leaks in error path
    https://git.kernel.org/netdev/net/c/06bf62944144

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


