Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC662627A1E
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235807AbiKNKML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236192AbiKNKLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:11:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8982E20354
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2DAD60C96
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 10:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26EE9C433C1;
        Mon, 14 Nov 2022 10:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668420615;
        bh=Ocl7NWEKas4039gMzI9pg6nEIxUSEhchVljAbqMKgIg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MapmjdeYCce9bmdZMF80/b71z/zAubfnWYccqps9CUa5wgRXhdrmZyz8/H4tonfjY
         S6ANJMsHGCj4+bgLW7XMnLqgWpwoaewygIfLEXtI7kaoiJAGuZqEvaXawd5esdA2uZ
         MjAyr7KexjvaM3HjIhbltWJ9KOBsSnDPEh2ZerwZp4k4+FYp3sJl4FXhXoHfDLxdAg
         cab6s88q60EqB1R1p3Ys+9HjV43Aaoe4r2V35AEN9AmUCPM+vvqvA/eoemBGVSh2/O
         Ou8jttMRZUZQG4Jv2MmMupm2cZL2cd+BZdyMFkSNlIFle6BXrB1zwqNRGLk+Hz3NtR
         bXpfxnF/iYxIw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A88DC395FE;
        Mon, 14 Nov 2022 10:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: liquidio: release resources when liquidio driver
 open failed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166842061503.15162.7865291005287723428.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Nov 2022 10:10:15 +0000
References: <20221110103037.133791-1-shaozhengchao@huawei.com>
In-Reply-To: <20221110103037.133791-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, richardcochran@gmail.com,
        rvatsavayi@caviumnetworks.com, gregkh@linuxfoundation.org,
        tseewald@gmail.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
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

On Thu, 10 Nov 2022 18:30:37 +0800 you wrote:
> When liquidio driver open failed, it doesn't release resources. Compile
> tested only.
> 
> Fixes: 5b07aee11227 ("liquidio: MSIX support for CN23XX")
> Fixes: dbc97bfd3918 ("net: liquidio: Add missing null pointer checks")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: liquidio: release resources when liquidio driver open failed
    https://git.kernel.org/netdev/net/c/8979f428a4af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


