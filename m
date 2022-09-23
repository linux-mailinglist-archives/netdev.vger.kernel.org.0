Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C975E70BE
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 02:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiIWAkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 20:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiIWAkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 20:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19A89C23C
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 17:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DD1B62381
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 00:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABB0EC433D7;
        Fri, 23 Sep 2022 00:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663893616;
        bh=xBJR/o3wPL2z1JweX107SsREDPKIl4/pFHKSCFKStWE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WfYCnq50U8MzGsX8m1CW/wRITdLwTH202onHsw1MhXzJY9FfL03xSMwmNU2NTwtDB
         qv+pTpXhW6yyx+Iwy/LirsBmvoXlLoTa1YX0siNE2PMANWYmSmxLjuOiLFGy/mygWO
         VuvPd2wSWzy8coYLOmKfqakXTwWo3v9iLOf5UMXAz4lgMnurgrpCbb3xLem1rqiTW6
         2dLr5DXJNDI9TUAZXb8PfqjFT/YxTiLY2adibAiOh6OC1SG1yv091kGCoz/XTFacjU
         ZyVxTUnqnAUanIkS5TgjtfEVh3o+H70APXmOw6IM+xgBtTzq/vNPasf4QjtCWCrs74
         dMGiOExIp089A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D4EFE21ED1;
        Fri, 23 Sep 2022 00:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] Support 256 bit TLS keys with device offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166389361657.358.1050349660231548360.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 00:40:16 +0000
References: <20220920130150.3546-1-gal@nvidia.com>
In-Reply-To: <20220920130150.3546-1-gal@nvidia.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        saeedm@nvidia.com, tariqt@nvidia.com, john.fastabend@gmail.com,
        borisp@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 20 Sep 2022 16:01:46 +0300 you wrote:
> Hey,
> This series adds support for 256 bit TLS keys with device offload, and a
> cleanup patch to remove repeating code:
> - Patches #1-2 add cipher sizes descriptors which allow reducing the
>   amount of code duplications.
> - Patch #3 allows 256 bit keys to be TX offloaded in the tls module (RX
>   already supported).
> - Patch #4 adds 256 bit keys support to the mlx5 driver.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] net/tls: Describe ciphers sizes by const structs
    https://git.kernel.org/netdev/net-next/c/2d2c5ea24243
  - [net-next,v2,2/4] net/tls: Use cipher sizes structs
    https://git.kernel.org/netdev/net-next/c/ea7a9d88ba21
  - [net-next,v2,3/4] net/tls: Support 256 bit keys with TX device offload
    https://git.kernel.org/netdev/net-next/c/56e5a6d3aa91
  - [net-next,v2,4/4] net/mlx5e: Support 256 bit keys with kTLS device offload
    https://git.kernel.org/netdev/net-next/c/4960c414db35

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


