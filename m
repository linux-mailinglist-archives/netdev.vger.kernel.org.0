Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E6A6CC12B
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 15:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbjC1Nk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 09:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbjC1NkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 09:40:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB3683D2;
        Tue, 28 Mar 2023 06:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFACBB81CF8;
        Tue, 28 Mar 2023 13:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98B1CC4339B;
        Tue, 28 Mar 2023 13:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680010819;
        bh=z2HnZVGT7+YCSQAlGFgSEcwYQy64DWO3R0IReXGvfGI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nTE0f0FdegCJoUag6APXbQ0XZpKFU+VFATNMHCc2o1CJAUypSTu/2PVXy3WivP8b2
         HUo31w3saYCylls8JumcfRJWb7efjYUZqelS7/WRQkWZGuTXk+FYHFQXB0RF/h3AZb
         Y8V5VyNdH0Eg8IdD5o6HeuOtBkHR1zylXCuZlziScIuCqzebeRV9NIIrqXCKoRGSZ+
         KlyIUWA/6PT/bN+hFbLFYayi2JckFXg9LolzKXpibnUfyxQyBAOnUJ4JWM4l0P8+9y
         DkpztcJ9khlf1mLasrYBtDO0uGDZnD9BZMTxJJuXP6K2NEQzZZS3YYckxteiZm1+l9
         6qqH0fmmTw9rQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C9ACE50D76;
        Tue, 28 Mar 2023 13:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpsw: add .ndo to set dma
 per-queue rate
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168001081950.18925.8811073139733105239.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Mar 2023 13:40:19 +0000
References: <20230327085758.3237155-1-s-vadapalli@ti.com>
In-Reply-To: <20230327085758.3237155-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rogerq@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 27 Mar 2023 14:27:58 +0530 you wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Enable rate limiting TX DMA queues for CPSW interface by configuring the
> rate in absolute Mb/s units per TX queue.
> 
> Example:
>     ethtool -L eth0 tx 4
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: ti: am65-cpsw: add .ndo to set dma per-queue rate
    https://git.kernel.org/netdev/net-next/c/5c8560c4a19f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


