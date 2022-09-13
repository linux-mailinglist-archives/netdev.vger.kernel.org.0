Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21755B69BB
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 10:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbiIMIke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 04:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbiIMIkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 04:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DBF1EC4E
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 01:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A31A561357
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 08:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2F4BC433D7;
        Tue, 13 Sep 2022 08:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663058416;
        bh=PfqPI+4Yxc/8+p6JOdbXVF9TVWa1ZWrTKEzRZqDoHgk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SKepAf+OE0XupEOPioF6mP09XnsqjA3qEuRx9H79Y1h8YUurGsBXC4OlN/H9GFPkv
         BfwBSsHyzxNLMcOGqQRo63nMcNLnxcw2fkiXWGAIFWYP7nVRlQwdu+CYjh0vOXdPf9
         f8chi6uROJ5+UFiSrDdcTvqRorMqE81TgrVPammlNz4ZwkJ2XjM0hhXC9E99BAQgdu
         zbBnZphf71Lya+JxLUwNf4bQxzCuckdjwg6ty58v91LGUy+2MdM2G0z+MQ+mQGnOkv
         0JGaFWYgxFNKX+PCco4sMX/esWJ8IE4Y8Qdt1ibONGP4onZRLYkMdn4w5kejHtXZwz
         kNCsLhGQPnQ7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D00A8C73FED;
        Tue, 13 Sep 2022 08:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: remove rtl_wol_shutdown_quirk()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166305841584.10377.12218125467875940321.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Sep 2022 08:40:15 +0000
References: <2391ada0-eac5-ac43-f061-a7a44b0e7f33@gmail.com>
In-Reply-To: <2391ada0-eac5-ac43-f061-a7a44b0e7f33@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 6 Sep 2022 20:24:57 +0200 you wrote:
> Since f658b90977d2 ("r8169: fix DMA being used after buffer free if WoL is
> enabled") it has been redundant to disable PCI bus mastering in
> rtl_wol_shutdown_quirk(). And since 120068481405 ("r8169: fix failing WoL")
> CmdRxEnb is still enabled when we get here. So we can remove the function.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: remove rtl_wol_shutdown_quirk()
    https://git.kernel.org/netdev/net-next/c/c9ae520ac3fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


