Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CBD62169D
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbiKHObB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbiKHOap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:30:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED6054B31
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 06:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBF4BB81B05
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55CF6C433D6;
        Tue,  8 Nov 2022 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667917816;
        bh=N+6MURLF6YTKv/rGPcVKVIdpp2gp4VMU4pTPB9Msc5U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iEhrZVo+C3NeWpNQ0XllbCkhll7tYxXxKuyeraADWf27gXNUB0NXzhJTW3WvL7phI
         IjRWoqM29kUNt+H1KP5ToP/bLGwFATB8l6VmIZbHZEUQrCu+4NCDgKVVUUKG6hZmxG
         nbvR/m/uomnJzNf0700AkUqrFTOBSD0/KcUw2zeyqCAfTEUPIEPQgM722Bo1AcuLpU
         Ebb+PEVjrA2WzWKtEYEUM6LsUXho+aR0JJOGZlYW9pbqwMVEyuXMbcMUPmCGp2Tdrf
         sdbRgjpTEUwi/+wzmia5sGa2C+/9Monec6hDiOC63Nob4mPpTGYcwmhvNpC7skAePf
         lqAlM54L2ZhnQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30B51E270CE;
        Tue,  8 Nov 2022 14:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers: net: xgene: disable napi when register irq failed in
 xgene_enet_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166791781619.3002.14271344918316408469.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 14:30:16 +0000
References: <20221107043032.357673-1-shaozhengchao@huawei.com>
In-Reply-To: <20221107043032.357673-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, iyappan@os.amperecomputing.com,
        keyur@os.amperecomputing.com, quan@os.amperecomputing.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
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

On Mon, 7 Nov 2022 12:30:32 +0800 you wrote:
> When failed to register irq in xgene_enet_open() for opening device,
> napi isn't disabled. When open xgene device next time, it will reports
> a invalid opcode issue. Fix it. Only be compiled, not be tested.
> 
> Fixes: aeb20b6b3f4e ("drivers: net: xgene: fix: ifconfig up/down crash")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - drivers: net: xgene: disable napi when register irq failed in xgene_enet_open()
    https://git.kernel.org/netdev/net/c/ce9e57feeed8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


