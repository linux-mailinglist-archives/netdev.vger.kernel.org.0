Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9875463A719
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbiK1LWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiK1LVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:21:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01AE5FE0;
        Mon, 28 Nov 2022 03:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2653B80D50;
        Mon, 28 Nov 2022 11:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55A11C433D6;
        Mon, 28 Nov 2022 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669634415;
        bh=capgdYdlv8ImmaY/P/XJPNMe5ihxiGl9pspCb2NR7Ms=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hjWkUBknQuY85YbvoLRK+C3kMeqlNk8kfIYVmZwZg1Bdksi9SNVzwND2Ts88JG3bL
         CVXZQ/TYXcce3Jx+tHZrRpl6GdbItwfUfCWliibpS1HGb0C4DmAZ9JMrqmG6u8+Yuw
         vlUP9WvuIdA+n6/A/fe8dY4bDnuf8K2PruPoRmzJuPxTxQAbETZsU/Hdi47MzGrCEk
         RurMAHKK3BmoGWIrJLPUEv/2M3s5x39FH4PlRU6ryqOnBL3vFxArXLAtZzCILG5ul6
         SBnl6/tYAyTT+hnDw9tKwXFo5Soci/cWVuMZCJjRArA2F9DlnrdpIFB+6W/HXrEjn4
         0gv/Wdy+GnpOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 38E23E270C8;
        Mon, 28 Nov 2022 11:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: nixge: fix NULL dereference
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166963441522.28920.10870298587227160274.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Nov 2022 11:20:15 +0000
References: <20221124084303.2075092-1-YKarpov@ispras.ru>
In-Reply-To: <20221124084303.2075092-1-YKarpov@ispras.ru>
To:     Yuri Karpov <YKarpov@ispras.ru>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
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
by David S. Miller <davem@davemloft.net>:

On Thu, 24 Nov 2022 11:43:03 +0300 you wrote:
> In function nixge_hw_dma_bd_release() dereference of NULL pointer
> priv->rx_bd_v is possible for the case of its allocation failure in
> nixge_hw_dma_bd_init().
> 
> Move for() loop with priv->rx_bd_v dereference under the check for
> its validity.
> 
> [...]

Here is the summary with links:
  - net: ethernet: nixge: fix NULL dereference
    https://git.kernel.org/netdev/net/c/9256db4e45e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


