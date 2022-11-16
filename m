Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFAA62B64D
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 10:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiKPJUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 04:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbiKPJUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 04:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8302226123
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 01:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FCC861B32
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 09:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56C82C433D7;
        Wed, 16 Nov 2022 09:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668590417;
        bh=KdAylELyj4TzmzA2zxPVaaZ/k2suWEouka/a165/fOY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zt0scquHNrJRwd98eLLdpQR/FkAQU3jUoN1VtIsUE70aMh/f1OeFxK8TXa1bd4gTh
         RkbM91b8n7qaojWof85QHKmxAv8zoM7iTxsDl6B3rbQJQJzAocmcBFBsSbmwNoMSiv
         7H3rFrMB66TqseorFSRzm8uQNVGLEVlw0I675TVCmXQVktFKxbyFZ7KrGOdhxibrUs
         vPHc28zOfwlus2ilOBLj8pZ8RVn8kJQZ9Bl+IUYWkjBlLpsI1OBYG59pj6KwshgANa
         3qAXf/G1bNm78gT8TJZ2G9hDR4OpcKdAB+PdBeJQculWEsfjq2FCzgDS6LZA3oYLiU
         jxZkqdeSBGSkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39C85C395F6;
        Wed, 16 Nov 2022 09:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] net: microchip: Fix potential null-ptr-deref due to
 create_singlethread_workqueue()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166859041723.4735.637806296362007434.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 09:20:17 +0000
References: <20221114133853.5384-1-shangxiaojing@huawei.com>
In-Reply-To: <20221114133853.5384-1-shangxiaojing@huawei.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, daniel.machon@microchip.com,
        rmk+kernel@armlinux.org.uk, casper.casan@gmail.com,
        bjarni.jonasson@microchip.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 14 Nov 2022 21:38:51 +0800 you wrote:
> There are some functions call create_singlethread_workqueue() without
> checking ret value, and the NULL workqueue_struct pointer may causes
> null-ptr-deref. Will be fixed by this patch.
> 
> Shang XiaoJing (2):
>   net: lan966x: Fix potential null-ptr-deref in lan966x_stats_init()
>   net: microchip: sparx5: Fix potential null-ptr-deref in
>     sparx_stats_init() and sparx5_start()
> 
> [...]

Here is the summary with links:
  - [1/2] net: lan966x: Fix potential null-ptr-deref in lan966x_stats_init()
    https://git.kernel.org/netdev/net/c/ba86af3733ae
  - [2/2] net: microchip: sparx5: Fix potential null-ptr-deref in sparx_stats_init() and sparx5_start()
    https://git.kernel.org/netdev/net/c/639f5d006e36

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


