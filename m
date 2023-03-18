Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FA36BF813
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 06:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjCRFk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 01:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjCRFkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 01:40:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E236233EE;
        Fri, 17 Mar 2023 22:40:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 50FD7CE1724;
        Sat, 18 Mar 2023 05:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 510E9C433A4;
        Sat, 18 Mar 2023 05:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679118019;
        bh=lGnEy3znbXM9CBXGHEwiyH5hDhz3ikM7nnM9AgDmO6o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nvfxizgs4pwekPOaEBXkvhXRaGpVIzTcLuepKnANcXyfWD1XCpZo/ImHOxF6YfLux
         pBzmQoVkBdJMA+dCYn1mF3um3nKuAzHMhgzYUT3ExogEaLU+ZF3/B/zbXQdthbD+Ni
         YFhmrWqhP24sedAEmWTCd8ZZaCjjv+ZJZi5ry08zgNgFbQd+OeAWwH4VBqFGEbHhTO
         6dvKRyaPpNLBLx0xI0f1b916Ldw6t2Mp/ZBPmjsrjeIQkKvv2Aus2eGAXVrn5vgtOm
         5ahLMQvP5mEjOOgfyUKw0+gEjlRC1w8oz48TEiEKC7DCI411rxSouRgx+RvIJMkkah
         Vt/3bAjMuKUiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 34839E2A03D;
        Sat, 18 Mar 2023 05:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: macb: Increase halt timeout to accommodate
 10Mbps link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167911801921.9150.17435609525495000288.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Mar 2023 05:40:19 +0000
References: <20230316083050.2108-1-harini.katakam@amd.com>
In-Reply-To: <20230316083050.2108-1-harini.katakam@amd.com>
To:     Harini Katakam <harini.katakam@amd.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michal.simek@amd.com,
        harinikatakamlinux@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Mar 2023 14:00:50 +0530 you wrote:
> From: Harini Katakam <harini.katakam@xilinx.com>
> 
> Increase halt timeout to accommodate for 16K SRAM at 10Mbps rounded.
> 
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: macb: Increase halt timeout to accommodate 10Mbps link
    https://git.kernel.org/netdev/net-next/c/ed0578a46c5f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


