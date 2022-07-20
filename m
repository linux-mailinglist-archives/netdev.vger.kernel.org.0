Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7229C57B462
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 12:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbiGTKUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 06:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiGTKUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 06:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFB5A442;
        Wed, 20 Jul 2022 03:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0FA561BA0;
        Wed, 20 Jul 2022 10:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 377E3C341C7;
        Wed, 20 Jul 2022 10:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658312413;
        bh=HOQhHtGXtjzLVdj1ro/LNI+1Ny99QaZ7D4TbaiXg7kM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NJnBuh2O0vvm4+r7jN3xINsWwaruI1vle/1OZ5rv2sXDZpriwH11+l8ryfbqVNM8E
         XtNB7WIhfAVbcIVrZDnA0L8tNedSY20MMKG/VKY3jKNXxM4UIWEkDnaj0DQKx2JEKN
         PR3jt2Krwi4RONFOKdMENmLOMKRPovMtXu14h9jfk79pDeKHlfGenCYiCSsqncgjna
         GQIYKJI9WKcUhWqKcw3x4GpN3GQrDYtAUpVFXICl3iLfUQtqC7+v1KiZnG/n29h6Z1
         yxD9r/Wr7LFO/W0FbyDLnd4oAphDAAGIp9/Dw/a1E/gEnEM0vaNhqB+NMpdiGGHrKu
         VLJc2eqNkvKdw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1D59BE451BC;
        Wed, 20 Jul 2022 10:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] can: mcp251xfd: fix detection of mcp251863
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165831241311.14288.2555817485894575710.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 10:20:13 +0000
References: <20220720083621.3294548-2-mkl@pengutronix.de>
In-Reply-To: <20220720083621.3294548-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Wed, 20 Jul 2022 10:36:20 +0200 you wrote:
> In commit c6f2a617a0a8 ("can: mcp251xfd: add support for mcp251863")
> support for the mcp251863 was added. However it was not taken into
> account that the auto detection of the chip model cannot distinguish
> between mcp2518fd and mcp251863 and would lead to a warning message if
> the firmware specifies a mcp251863.
> 
> Fix auto detection: If a mcp2518fd compatible chip is found, keep the
> mcp251863 if specified by firmware, use mcp2518fd instead.
> 
> [...]

Here is the summary with links:
  - [net,1/2] can: mcp251xfd: fix detection of mcp251863
    https://git.kernel.org/netdev/net/c/db87c005b9cc
  - [net,2/2] can: rcar_canfd: Add missing of_node_put() in rcar_canfd_probe()
    https://git.kernel.org/netdev/net/c/7b66dfcc6e1e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


