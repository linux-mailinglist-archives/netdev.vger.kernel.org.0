Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE7D64F7CC
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 06:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiLQFUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 00:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiLQFUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 00:20:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF82813DEF;
        Fri, 16 Dec 2022 21:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65532B81ED0;
        Sat, 17 Dec 2022 05:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07E5EC433F1;
        Sat, 17 Dec 2022 05:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671254417;
        bh=bOIml/bUnsVWLiSKgiMSTRwMKCcHC+M9YVMloPjqiJg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aLCrBlksp5vxTrIZuD4Fj5gyfXoOMwi+saDVZ5kwZ9l+trc4gLUqray6pY9hcd2QM
         YcwYtUlDjjIkyZIOS+x28SjZzURH+pCdPrIgn7jh9JhlyyaMep0Y5P3rv4xeLmeCsI
         C2qSj3RCHj+ePKGQnCvy/FQhBBiOkTL1uRZ8bWa9xdye2rT2ZCrgnco9cB2fPTspn+
         YBOSLdPHKkEezCaootjO6GRJuy4BlkVH/oU7zfGnuoFYVpXG6DlnERh8v/QeQVfTsJ
         PLvtQ6g68bcxQKw8Mb2LCope13n7aVIC02x6fucnblMUKVaoD/bO8e49iStbSoNz2D
         Pr5Y42CEm5gYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E02C9E4D028;
        Sat, 17 Dec 2022 05:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: am65-cpsw: fix CONFIG_PM #ifdef
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167125441691.30458.9128974148949832508.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Dec 2022 05:20:16 +0000
References: <20221215163918.611609-1-arnd@kernel.org>
In-Reply-To: <20221215163918.611609-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, arnd@arndb.de, rogerq@kernel.org,
        s-vadapalli@ti.com, jiri@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Thu, 15 Dec 2022 17:39:05 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The #ifdef check is incorrect and leads to a warning:
> 
> drivers/net/ethernet/ti/am65-cpsw-nuss.c:1679:13: error: 'am65_cpsw_nuss_remove_rx_chns' defined but not used [-Werror=unused-function]
>  1679 | static void am65_cpsw_nuss_remove_rx_chns(void *data)
> 
> [...]

Here is the summary with links:
  - net: ethernet: ti: am65-cpsw: fix CONFIG_PM #ifdef
    https://git.kernel.org/netdev/net/c/078838f5b9c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


