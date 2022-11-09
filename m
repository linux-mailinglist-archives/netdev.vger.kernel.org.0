Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79992622185
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 03:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiKICAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 21:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiKICAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 21:00:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3412B18C
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 18:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9AF0B81CF1
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 776DFC43141;
        Wed,  9 Nov 2022 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959215;
        bh=nnogosC7oZMCldk43nPmGlQoFRsEeZCTMxeRvmh39Lg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PlUuaRp1yWiOu/wJTnucfFZbedBc74BFGw1WZD1CR3QRJzbbpcsbTwLEmPDuPEmUO
         O79ne+V/ODzYNNkMUggjWYJ9yCOEz1wJg3ptb5wxqA0vAA99MBPLb90Hm9K5GXrhuv
         lWHIXZiOJtujSot5jrha+0iD80HA77B5ejE3PtwqJ4CtX0g+CfKdcKWMlStFLeFx/f
         hWYNRnklY9KK7J4dRJDuvYu9UscyRYGUTotxqwRedSxSayOLVg8drdFhmzvp+bBaNZ
         AyKgNMkCX5kUwG/JJac6Pgv+L+FjPHZxZkhPzX8W80gEQ4cbreWUjA/y/BoPvzPp+h
         HDAIjTfm4lJvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 427FFE270CE;
        Wed,  9 Nov 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: nixge: disable napi when enable interrupts failed in
 nixge_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166795921526.12027.11201556109412673354.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Nov 2022 02:00:15 +0000
References: <20221107101443.120205-1-shaozhengchao@huawei.com>
In-Reply-To: <20221107101443.120205-1-shaozhengchao@huawei.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, khalasa@piap.pl,
        leon@kernel.org, arnd@arndb.de, wsa+renesas@sang-engineering.com,
        christophe.jaillet@wanadoo.fr, mdf@kernel.org, petrm@nvidia.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
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

On Mon, 7 Nov 2022 18:14:43 +0800 you wrote:
> When failed to enable interrupts in nixge_open() for opening device,
> napi isn't disabled. When open nixge device next time, it will reports
> a invalid opcode issue. Fix it. Only be compiled, not be tested.
> 
> Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: nixge: disable napi when enable interrupts failed in nixge_open()
    https://git.kernel.org/netdev/net/c/b06334919c7a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


