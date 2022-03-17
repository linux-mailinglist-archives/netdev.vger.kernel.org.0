Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8A84DBD21
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 03:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbiCQCld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 22:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346379AbiCQCl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 22:41:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D341FCEB;
        Wed, 16 Mar 2022 19:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52FA8B81DE8;
        Thu, 17 Mar 2022 02:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9A1DC340EC;
        Thu, 17 Mar 2022 02:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647484811;
        bh=fCnyaxuydA1Ee6SXEIWjzXv6AAEPPz7uakrwi2kauaA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VmZByRrWKoK2KyxEXBgJG/hQJBT9Vx4UZ/RCCeXJTYnGl8tGd4hv6EXhj6o8w0kuD
         wxd0bRE33dnYMoJ622RTEhK2JbL0svCCJzUd0fd/SasHBFjXoAcYfieteMYuKUpL7O
         qG/AI623iIbCkX+SaMiCuIdOOu5b24eaaO5Ze6iYyifOBKOtx7qBMXA2QMmIU/n7Ho
         NAuUAHkidNm9XcbXJmAyiWAqVarN0mwO6ZzjpaaZjRsSPxt+OyCcNu658DTukwWsMg
         V9rh8xRbWd+D31dbXwskCqHEu6az9QgAZSrDuNhU96U1cU6rtWQFjaYBcmkEt63a19
         nv3iX56OZKTHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BCE14E8DD5B;
        Thu, 17 Mar 2022 02:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] gve: Fix spelling mistake "droping" -> "dropping"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164748481076.31245.5657352758035872315.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 02:40:10 +0000
References: <20220315222615.2960504-1-colin.i.king@gmail.com>
In-Reply-To: <20220315222615.2960504-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     jeroendb@google.com, csully@google.com, awogbemila@google.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 15 Mar 2022 22:26:15 +0000 you wrote:
> There is a spelling mistake in a netdev_warn warning. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/google/gve/gve_rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] gve: Fix spelling mistake "droping" -> "dropping"
    https://git.kernel.org/netdev/net-next/c/2fc559c8cba0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


