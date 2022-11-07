Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A1C61F352
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 13:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbiKGMbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 07:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiKGMai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 07:30:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF791BE8B;
        Mon,  7 Nov 2022 04:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26E3761026;
        Mon,  7 Nov 2022 12:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86096C43142;
        Mon,  7 Nov 2022 12:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667824215;
        bh=AkeDM75MuSCotGSfJVxtee6zfh4I4/JS77n+voLVauk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tafyXBm96n2VjBiY4rXDqfxqQUeOhGIOKpcxPINwFELy4PyRYbbpf319XGaHGt2Ja
         FslPgYpC1kgWnhns8ox/jdwhri+QBDDtTKLV7Ba3xo5o4dGd8Fo3XsWNrl+Z/sgq2D
         WM0s1EfWeCOhSn2ohO5wTgQi6nnJR2IqJqF6bQ+0evhXQITMftqR3lDFS0LOqB8pVE
         SfsLC1I5u8paycU0Uk5TOHDpbjuxMT/xFGrN2VbkjXqayEVPCy9udeNfXcMqTi+net
         pd77OKv9Wm2qOlhyBuNAKnBz8/dJ0y1PMxJMuwWICKJ8gF4Qx/NUd4Ozs+2x9wKBDn
         hFaMx3Y9eTI+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70043C73FFC;
        Mon,  7 Nov 2022 12:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/5] net: ethernet: ti: am65-cpsw: Add suspend/resume support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166782421544.17007.7447279086503813057.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Nov 2022 12:30:15 +0000
References: <20221104132310.31577-1-rogerq@kernel.org>
In-Reply-To: <20221104132310.31577-1-rogerq@kernel.org>
To:     Roger Quadros <rogerq@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vigneshr@ti.com, vibhore@ti.com, srk@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Fri,  4 Nov 2022 15:23:05 +0200 you wrote:
> Hi,
> 
> This series enables PM_SLEEP(suspend/resume) support to
> the am65-cpsw network driver.
> 
> Dual-emac and Switch mode are tested to work with suspend/resume
> on AM62-SK platform.
> 
> [...]

Here is the summary with links:
  - [1/5] net: ethernet: ti: am65-cpsw/cpts: Add suspend/resume helpers
    https://git.kernel.org/netdev/net-next/c/cef122d4cf5b
  - [2/5] net: ethernet: ti: am65-cpsw: Add suspend/resume support
    https://git.kernel.org/netdev/net-next/c/fd23df72f2be
  - [3/5] net: ethernet: ti: cpsw_ale: Add cpsw_ale_restore() helper
    https://git.kernel.org/netdev/net-next/c/eadb43437407
  - [4/5] net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after suspend/resume
    https://git.kernel.org/netdev/net-next/c/643cf0e3ab5c
  - [5/5] net: ethernet: ti: am65-cpsw: Fix hardware switch mode on suspend/resume
    https://git.kernel.org/netdev/net-next/c/1af3cb3702d0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


