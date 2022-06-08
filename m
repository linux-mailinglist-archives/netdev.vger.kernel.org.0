Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3C7543B9C
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 20:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiFHSkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 14:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiFHSkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 14:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D3EDAB;
        Wed,  8 Jun 2022 11:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7443561C19;
        Wed,  8 Jun 2022 18:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF32FC3411E;
        Wed,  8 Jun 2022 18:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654713612;
        bh=30tODfc6hksfi/e5fv3mEodBVRjsmN8xJwXku7rlyAc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aHITNgaHvWBn0uGI8SQcz7iT2XBunNTyY/OJYl9KSBaePkbNwxGqdtgsSre7T0CgP
         aiPjzyhUI/EWFGNwrZ9gnUxIOJayo9iMA2lfyfU1gdYOJWwIDYk2qNDmbGnYnuHB9z
         NZd7U2IxKggewU3dCXRR8BoSrRpLifKZdRNsHAVu80l8hu4Ob+Mr9/0J7hLuhQK8pY
         JEnJ+yeEMBUA8EAUXaTjEF3hfMWDFdh9yyyA3YvGFv9ZGsfnQZWdWcpLwJe3qgTwpE
         r68nUhPGvagfQGGeivjgil5XwZl/N7+w+3Bc6CbMn5onyjPMiYGAbRDenZuMLQGfUr
         xNsoFakz2rjxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B2BE7E737FA;
        Wed,  8 Jun 2022 18:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] au1000_eth: stop using virt_to_bus()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165471361272.14949.3296877350202206249.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Jun 2022 18:40:12 +0000
References: <20220607090206.19830-1-arnd@kernel.org>
In-Reply-To: <20220607090206.19830-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, arnd@arndb.de, manuel.lauss@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Jun 2022 11:01:46 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The conversion to the dma-mapping API in linux-2.6.11 was incomplete
> and left a virt_to_bus() call around. There have been a number of
> fixes for DMA mapping API abuse in this driver, but this one always
> slipped through.
> 
> [...]

Here is the summary with links:
  - au1000_eth: stop using virt_to_bus()
    https://git.kernel.org/netdev/net/c/a6958951ebe7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


