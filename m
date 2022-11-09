Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4AD9622D34
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 15:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiKIOKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 09:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiKIOK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 09:10:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CF211820
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 06:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78A3561AD8
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 14:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2529C433D7;
        Wed,  9 Nov 2022 14:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668003015;
        bh=Zc7wNojr8ZHMIsh+blbl/wU/F9Wv0CT4NFkdA27rkdE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LRy21AN03oKNqIXy4FTb637NOWNmCKB6GftlYlwV/GiTW2YwzO60upPD27X/WIov8
         SWgAY4oV/ykgt4GlNlwZM97njYKKm5/HPAGHcK+J8fudJLn41gzArCMVqfWcJF6L2V
         NXzMO6sZ912IKfhTRmSxSB7mJvDk/zPdyc7/AMGzKXqw7YTsdeBhwuWVdCBL+5ie3/
         /MQdN0EsW3an6mvANzzxr2N6Vz3dNpImI/orNYMy4ytlg5iDLJGCce/tVfWbaCxFpW
         hsca8aJFxm0KwYrQPYI/IcqbSKpvlw6vFWNr0lkdH7QBlPnyFeOpWvqggf8u3fWJaG
         V5MAvLBWGkgDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2410C395F6;
        Wed,  9 Nov 2022 14:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V2 0/4] net: wwan: iosm: fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166800301565.27724.12126417654708152557.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Nov 2022 14:10:15 +0000
References: <20221107073414.1978162-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20221107073414.1978162-1-m.chetan.kumar@linux.intel.com>
To:     Kumar@ci.codeaurora.org, M Chetan <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        edumazet@google.com, pabeni@redhat.com, linuxwwan@intel.com
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

On Mon,  7 Nov 2022 13:04:14 +0530 you wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> This patch series contains iosm fixes.
> 
> PATCH1: Fix memory leak in ipc_pcie_read_bios_cfg.
> 
> PATCH2: Fix driver not working with INTEL_IOMMU disabled config.
> 
> [...]

Here is the summary with links:
  - [net,V2,1/4] net: wwan: iosm: fix memory leak in ipc_pcie_read_bios_cfg
    https://git.kernel.org/netdev/net/c/d38a648d2d6c
  - [net,V2,2/4] net: wwan: iosm: fix driver not working with INTEL_IOMMU disabled
    https://git.kernel.org/netdev/net/c/035e3befc191
  - [net,V2,3/4] net: wwan: iosm: fix invalid mux header type
    https://git.kernel.org/netdev/net/c/02d2d2ea4a3b
  - [net,V2,4/4] net: wwan: iosm: fix kernel test robot reported errors
    https://git.kernel.org/netdev/net/c/980ec04a88c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


