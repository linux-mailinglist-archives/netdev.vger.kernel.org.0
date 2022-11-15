Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4906297E3
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiKOMAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiKOMAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67ADD58
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 04:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EB31B8162A
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 12:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36BABC433B5;
        Tue, 15 Nov 2022 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668513616;
        bh=9+w7Jwrt9NnIkWIO6JVsw9jk7YxvsAlt+Y+8DEFCCc4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ygnp8vKj3+aMRZmQ1l8vIjoZuf4Bc1tdDltJYhwx8MK8ooFakK0vzCMksQTiIwB++
         kntDT1TWLdXyg1k9RV5ODHnIayhhLVA+dP7nHJkn0FZJMX1RaW1kII743AyCXh7k0Y
         cuR8MvF3OV1Zfyjg4yzdwxCjznOhRl9kz6XY3+ouPZj6P8iaffcrVagHI/F5gtJ9Na
         ON9oZ0Jf3IfhiXKc0ZJDpcxP5HBLphRYYneToHoYW3gWQFwtpudGb8iy05984Kl2zv
         sR6WMBuQVnrx/I9UBRTY5SJgFqFyi8hlkCRko29JUr8Dn0/K/sh2T8AU7ubeBwPCtM
         hCa8qspzZvgtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1687BE21EFC;
        Tue, 15 Nov 2022 12:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ena: Fix error handling in ena_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166851361608.12756.1292040476130898222.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Nov 2022 12:00:16 +0000
References: <20221114025659.124726-1-yuancan@huawei.com>
In-Reply-To: <20221114025659.124726-1-yuancan@huawei.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        ndagan@amazon.com, saeedb@amazon.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nkoler@amazon.com, wsa+renesas@sang-engineering.com,
        netanel@annapurnalabs.com, netdev@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 14 Nov 2022 02:56:59 +0000 you wrote:
> The ena_init() won't destroy workqueue created by
> create_singlethread_workqueue() when pci_register_driver() failed.
> Call destroy_workqueue() when pci_register_driver() failed to prevent the
> resource leak.
> 
> Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> 
> [...]

Here is the summary with links:
  - net: ena: Fix error handling in ena_init()
    https://git.kernel.org/netdev/net/c/d349e9be5a2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


