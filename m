Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446815667B1
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiGEKUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiGEKUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:20:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9CD140A3
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 03:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7BA87CE1B0C
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 10:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3BFEC341CE;
        Tue,  5 Jul 2022 10:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657016412;
        bh=YXa+PVTe/rlUFQ2H8Da1SdFis4G8lhYCwQs/j7hoRg0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HQZtf18Xaoj2GRmrv/CL3zR7FAOACIznQu5N98KZFkLUCHXOcBFtyi+/11vKoyqah
         s/sBTBzKu5OXb6RKAHlCy+IfRqSNYlv7Dy9DxmHKeuyqsN5seQLGYIlEvoCTgFM3AF
         WCfpyLILnQi0JCvFLJ46vSyIL4EE8IBnlMq0OOw45BxE2ceWRzPlO1a792d5JhfHO7
         oxPZ5gqDaKpbMQrTKGt8iEZIVHetcpMVp3Eedb726VG0yltQWvHO5VOGufAS8Xlesq
         Khi9f+T61dQBB2QRhZHDZuMuaH9tghIMaLu+0XtkBHn6Z5YJLfxbLxkJkEBtVI1oZT
         74/XGEr6gqFyg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9AF42E45BDD;
        Tue,  5 Jul 2022 10:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5: fix 32bit build
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165701641263.9187.11019893032439385663.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Jul 2022 10:20:12 +0000
References: <ecb00ddd1197b4f8a4882090206bd2eee1eb8b5b.1657005206.git.pabeni@redhat.com>
In-Reply-To: <ecb00ddd1197b4f8a4882090206bd2eee1eb8b5b.1657005206.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, saeedm@nvidia.com, leon@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        jianbol@nvidia.com, roid@nvidia.com, lariel@nvidia.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue,  5 Jul 2022 09:17:04 +0200 you wrote:
> We can't use the division operator on 64 bits integers, that breaks
> 32 bits build. Instead use the relevant helper.
> 
> Fixes: 6ddac26cf763 ("net/mlx5e: Add support to modify hardware flow meter parameters")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net/mlx5: fix 32bit build
    https://git.kernel.org/netdev/net-next/c/55ae465222d0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


