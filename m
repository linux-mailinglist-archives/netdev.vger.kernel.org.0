Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552D76387DA
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 11:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiKYKu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 05:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiKYKuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 05:50:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863A648424;
        Fri, 25 Nov 2022 02:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36D4EB82A73;
        Fri, 25 Nov 2022 10:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB485C4314B;
        Fri, 25 Nov 2022 10:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669373419;
        bh=a0thxUE/wj+BKyAY4Yj0/YxnDdRFpXDPSQVJAA5bU3Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QiyBzLOh/XO4RrMezigI7GgKICfQZXgrOaopgzCFQEHrWb+Zai5AglOfOXCy8mdX9
         OS089UYpwFbfN6fLIQBV8TruJFtEID8V2SbJSBCcTx8Rzxa53dszhPBSn1z/45U85r
         pMoCNQCO2OXciYlXtPduOVDMo/e+BLbkZDQcWiDe5sx/c1wqQoGt1wImyakVbmOx32
         uqNanv4fKRzYODBgQ7LC0ZpYHSzIPc/b1ckGjXlk41ohfz4JqTNBA+TsgPgprv+M8s
         NQVAvEkVop5eBGDz0geUUyYCXw5W4sITNi1+PARzQ9udT1fbpppEBKPQtx0AzwNwZ7
         Ss9rsErKJ6SBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 737EEE5250B;
        Fri, 25 Nov 2022 10:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/7] net: lan966x: Extend xdp support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166937341945.11224.81925006983586457.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 10:50:19 +0000
References: <20221123203139.3828548-1-horatiu.vultur@microchip.com>
In-Reply-To: <20221123203139.3828548-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        UNGLinuxDriver@microchip.com, alexandr.lobakin@intel.com,
        maciej.fijalkowski@intel.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 23 Nov 2022 21:31:32 +0100 you wrote:
> Extend the current support of XDP in lan966x with the action XDP_TX and
> XDP_REDIRECT.
> The first patches just prepare the things such that it would be easier
> to add XDP_TX and XDP_REDIRECT actions. Like adding XDP_PACKET_HEADROOM,
> introduce helper functions, use the correct dma_dir for the page pool
> The last 2 patches introduce the XDP actions XDP_TX and XDP_REDIRECT.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/7] net: lan966x: Add XDP_PACKET_HEADROOM
    https://git.kernel.org/netdev/net-next/c/7292bb064d62
  - [net-next,v5,2/7] net: lan966x: Introduce helper functions
    https://git.kernel.org/netdev/net-next/c/3d66bc578655
  - [net-next,v5,3/7] net: lan966x: Add len field to lan966x_tx_dcb_buf
    https://git.kernel.org/netdev/net-next/c/49f5eea8c4f5
  - [net-next,v5,4/7] net: lan966x: Update rxq memory model
    https://git.kernel.org/netdev/net-next/c/77ddda44411c
  - [net-next,v5,5/7] net: lan966x: Update dma_dir of page_pool_params
    https://git.kernel.org/netdev/net-next/c/560c7223d6e4
  - [net-next,v5,6/7] net: lan966x: Add support for XDP_TX
    https://git.kernel.org/netdev/net-next/c/19c6f534f636
  - [net-next,v5,7/7] net: lan966x: Add support for XDP_REDIRECT
    https://git.kernel.org/netdev/net-next/c/a825b611c7c1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


