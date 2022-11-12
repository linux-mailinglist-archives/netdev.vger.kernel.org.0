Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A31626716
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 06:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbiKLFKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 00:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiKLFKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 00:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30F732BB1
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 21:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E33C60B2A
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 05:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B0C8C433D7;
        Sat, 12 Nov 2022 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668229817;
        bh=jneOVE3GfaKfaROHq9JE5QpB6p2XTSjke1cKpJ42kM4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bIIxoj3ojW6zpzdaRqAwrpE3OJhoEUCmqDXHsnGTlpTNJpt6Rkh6WUvW7blcTwsWA
         Ax5t6ksIgw9GGRoG/CGBKIPmk9QR92oiZ2tPzvR9h6RsjYA2+hei16QFtl9eKAnrQL
         f1kAMfNtOn506eml0rfP/9mkl4a+Tu72WKe9oTDwBOQHKFNed9OXQd9Nhz+3bDb95M
         AwnU4g0yfEF5ngpDo+tmeqvfqDwNoQxfEdQDKPGbIrRCLUZcHfXV9r5lQsSv3/YEIq
         xWDpLh6UFXp1B4XXsGsiDEU9t7JRp13YaVvP9GuYVOuJuf/Ku6t3js5KPtGepRzGY1
         FHk7YBFQtB/pQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 49DC5E4D022;
        Sat, 12 Nov 2022 05:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bgmac: Drop free_netdev() from bgmac_enet_remove()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166822981729.20406.8789696456884171815.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Nov 2022 05:10:17 +0000
References: <20221109150136.2991171-1-weiyongjun@huaweicloud.com>
In-Reply-To: <20221109150136.2991171-1-weiyongjun@huaweicloud.com>
To:     Wei Yongjun <weiyongjun@huaweicloud.com>
Cc:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, f.fainelli@gmail.com, weiyongjun1@huawei.com,
        netdev@vger.kernel.org
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

On Wed,  9 Nov 2022 15:01:36 +0000 you wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> netdev is allocated in bgmac_alloc() with devm_alloc_etherdev() and will
> be auto released in ->remove and ->probe failure path. Using free_netdev()
> in bgmac_enet_remove() leads to double free.
> 
> Fixes: 34a5102c3235 ("net: bgmac: allocate struct bgmac just once & don't copy it")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Here is the summary with links:
  - [net] net: bgmac: Drop free_netdev() from bgmac_enet_remove()
    https://git.kernel.org/netdev/net/c/6f928ab8ee9b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


