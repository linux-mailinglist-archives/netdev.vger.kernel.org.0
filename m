Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C7A629193
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 06:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiKOFkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 00:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiKOFkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 00:40:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DE71AF2A
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 21:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A961961549
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFC1FC433C1;
        Tue, 15 Nov 2022 05:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668490815;
        bh=48C6P5MRFMwbvRwY1oRV6e6OXei01BDXNvBiG2dd6BA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t6mPcDtAh5ZPJBcr9637N2B8vM8DFxgmu/NIay/X6P5YzBOzV0OUcTFvtJEDs9UvM
         b20y//BzFqINNyMjcRX+IGsUj0S38gLx3oZiDnSQqWzcuK7EO94kcB+8dQboz0Ad0e
         Kvek3rI4m5Or1s4sF3j6kiMZ0Y0goS9vResPLOrEF5iRNysSu32ZnOoVAMuwKde3GT
         5b7f61oUn4jSHHgvzAZDoD6zT3U/jr2S3LQo0BUXBUAnuf0XYT8o0J8Nn61aGMtmZR
         mVJ85f+4ZB6DYGBIqcukGLGDd4/CyDK5w1AikrRRA0qF8EPESt4/csTLXUbgyQRp7n
         2mBa98ZwOPiCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D8C97E4D021;
        Tue, 15 Nov 2022 05:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ionic: Fix error handling in ionic_init_module()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166849081488.10793.1486894686796847826.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Nov 2022 05:40:14 +0000
References: <20221113092929.19161-1-yuancan@huawei.com>
In-Reply-To: <20221113092929.19161-1-yuancan@huawei.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     snelson@pensando.io, drivers@pensando.io, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        brett@pensando.io, netdev@vger.kernel.org
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

On Sun, 13 Nov 2022 09:29:29 +0000 you wrote:
> A problem about ionic create debugfs failed is triggered with the
> following log given:
> 
>  [  415.799514] debugfs: Directory 'ionic' with parent '/' already present!
> 
> The reason is that ionic_init_module() returns ionic_bus_register_driver()
> directly without checking its return value, if ionic_bus_register_driver()
> failed, it returns without destroy the newly created debugfs, resulting
> the debugfs of ionic can never be created later.
> 
> [...]

Here is the summary with links:
  - net: ionic: Fix error handling in ionic_init_module()
    https://git.kernel.org/netdev/net/c/280c0f7cd0aa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


