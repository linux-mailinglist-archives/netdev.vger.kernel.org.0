Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0AF6474DD
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 18:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLHRKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 12:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLHRKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 12:10:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85C785D16
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 09:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8684BB82565
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 17:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2DF2DC433F0;
        Thu,  8 Dec 2022 17:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670519415;
        bh=z50DMIcPQJZPAHuOu/auxofu66MQFyw2N/RT1Oa92fE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DFJ7rUtumz5vxUN4DvYRydBw4wn0FBykI0nM95IY6Rfi4K2B4jYr4KuTr6pVrO5WG
         khc7OJzQPCqXbmQzNZktQ0g7PhNsu6Q0Q4UpkEWao1KWIo9b0lA1/i5DWJNkiF0sJt
         cpcd36QdSJZDg+gCwobO3Xvj7qsEeE8v1sbKxQFbydWFc9IuhBb5IVMW+K5VlRXJQP
         8uzsZ1Tsttg8Ef0sdziI9zcXacgcHQCh9z62ObYGm34/CT+RYDtmngj+otVkEJLxer
         JkYDDJ5CFkV2b5wtOSXzr/JSpbzQu2M69Y9do0NSABFyICrJsQh6iYETwQwPUTHXZL
         02cCwHH3yUJSQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 081A1C433D7;
        Thu,  8 Dec 2022 17:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: thunderbolt: fix memory leak in tbnet_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167051941502.15414.8866645504012322065.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 17:10:15 +0000
References: <20221207015001.1755826-1-shaozhengchao@huawei.com>
In-Reply-To: <20221207015001.1755826-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, michael.jamet@intel.com,
        mika.westerberg@linux.intel.com, YehezkelShB@gmail.com,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 7 Dec 2022 09:50:01 +0800 you wrote:
> When tb_ring_alloc_rx() failed in tbnet_open(), ida that allocated in
> tb_xdomain_alloc_out_hopid() is not released. Add
> tb_xdomain_release_out_hopid() to the error path to release ida.
> 
> Fixes: 180b0689425c ("thunderbolt: Allow multiple DMA tunnels over a single XDomain connection")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [net,v3] net: thunderbolt: fix memory leak in tbnet_open()
    https://git.kernel.org/netdev/net/c/ed14e5903638

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


