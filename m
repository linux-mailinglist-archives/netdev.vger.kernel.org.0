Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276A763A748
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiK1LkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiK1LkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:40:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F1764C7
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 03:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A33F4B80D5F
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 11:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 663EDC433D7;
        Mon, 28 Nov 2022 11:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669635616;
        bh=bsBAr1CuDIXhh89oT6na+4pHhnkQOfC21/8DvtVqWWA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BhNXbgLjCDfBX7gkYhdOugPAQEXgKxbmn+FPNOkDNUdOjpr9zEdnJN1Vg9uJlKYiI
         tQToLkF02yx7OVJUxWyNOF4lHtHCAVQeWKpyglXtUYdAte/NfhV7eEVpq5KKK3RKwu
         38a7l8Rd73UOjMlA6MVQdSJ6NkOyvDuIgkfrwo5gVPVH0NffLtsnpTwLSX51KU+FMz
         T4olQAj6d2ebFf9AkZVKXIARMhw6rxQVEMVTmag+62hYB5OHNCx/OwvhPAcFrvbseu
         uDM2DICXXdAvRgF5HwkqAzV7FTaTWRAQ9BBlA1dCRFGm/X18lEwlYqa4oeeq+lwomD
         B9IJ8h8JcMh8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E20DE270C8;
        Mon, 28 Nov 2022 11:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 0/4] net: wwan: iosm: fix build errors & bugs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166963561631.6906.4335002623783242487.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Nov 2022 11:40:16 +0000
References: <20221124103725.1445974-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20221124103725.1445974-1-m.chetan.kumar@linux.intel.com>
To:     Kumar@ci.codeaurora.org, M Chetan <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        linuxwwan@intel.com, edumazet@google.com, pabeni@redhat.com
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

On Thu, 24 Nov 2022 16:07:25 +0530 you wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> This patch series fixes iosm driver bugs & build errors.
> 
> PATCH1: Fix kernel build robot reported error.
> PATCH2: Fix build error reported on armhf while preparing
>         6.1-rc5 for Debian.
> PATCH3: Fix UL throughput crash.
> PATCH4: Fix incorrect skb length.
> 
> [...]

Here is the summary with links:
  - [v2,net,1/4] net: wwan: iosm: fix kernel test robot reported error
    https://git.kernel.org/netdev/net/c/985a02e75881
  - [v2,net,2/4] net: wwan: iosm: fix dma_alloc_coherent incompatible pointer type
    https://git.kernel.org/netdev/net/c/4a99e3c8ed88
  - [v2,net,3/4] net: wwan: iosm: fix crash in peek throughput test
    https://git.kernel.org/netdev/net/c/2290a1d46bf3
  - [v2,net,4/4] net: wwan: iosm: fix incorrect skb length
    https://git.kernel.org/netdev/net/c/c34ca4f32c24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


