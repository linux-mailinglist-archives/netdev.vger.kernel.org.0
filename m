Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C66630B9D
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 04:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbiKSD4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 22:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiKSDz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 22:55:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CF1C75BA;
        Fri, 18 Nov 2022 19:51:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC2E9B8270B;
        Sat, 19 Nov 2022 03:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47CB4C43470;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668829818;
        bh=U5khnDz7RcjClKsASB6iTZtp8xENL3BOpG4hrA8vqQM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nBcClLwvUDx4fH7pwupz9GXJ+5WZCYwkQ0rUuh/eF2/dO37P8BWIUnUQ8ctUUyKhx
         pC4uS74LhyIP0+bsC4w3/B3qva/rt4RAjb63uKESZsVRSfSPHzoB5aOmE4jL+UtKAJ
         C+eNH2lVh70VLkTakc8Dg2fhhlSmLiC6mS7/svsiQyRhtLD461taGvWBDA/2uNpdy+
         jPEUZu+1rlKqPVrzbLTHFUIZni1CYBXBVFwtCCfZUBHRWosr979S+tsLEeTGg75g/+
         u87rtmLrwIfPCKGY4toWHAEm8NTyiCug+KLE191iyJGsc8pkeYRYvjONnBCFXFqYNE
         LQ24XDlzgGhGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2DDD1E524E5;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v5] net: mvpp2: fix possible invalid pointer dereference
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166882981818.27279.1458629384078328986.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Nov 2022 03:50:18 +0000
References: <20221117084032.101144-1-tanghui20@huawei.com>
In-Reply-To: <20221117084032.101144-1-tanghui20@huawei.com>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        mw@semihalf.com, linux@armlinux.org.uk, leon@kernel.org,
        andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yusongping@huawei.com
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

On Thu, 17 Nov 2022 16:40:32 +0800 you wrote:
> It will cause invalid pointer dereference to priv->cm3_base behind,
> if PTR_ERR(priv->cm3_base) in mvpp2_get_sram().
> 
> Fixes: a59d354208a7 ("net: mvpp2: enable global flow control")
> Signed-off-by: Hui Tang <tanghui20@huawei.com>
> ---
> v1 -> v2: patch title include target
> v2 -> v3: keep priv->cm3_base NULL if devm_ioremap_resource() failed
> v3 -> v4: change if (priv->cm3_base) to if (base)
> v4 -> v5: use the idiomatic error handling, keep success path un-indented
> 
> [...]

Here is the summary with links:
  - [net,v5] net: mvpp2: fix possible invalid pointer dereference
    https://git.kernel.org/netdev/net/c/cbe867685386

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


