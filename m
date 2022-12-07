Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC3364531D
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiLGEk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiLGEkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F1B56EE5
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 20:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 305ED61A11
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 804A7C433B5;
        Wed,  7 Dec 2022 04:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670388016;
        bh=JDTKMj5g4KHew7Am2kN8rxZTxcMBpGGHVgMEGAVBMTw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OSl7f3lQNY7ZANzlwCV6oxUMTPEl665nwbKv5tHCWRcYcm6XEUbmpa0hdKGD1PLXD
         LdpCincGfOcCQ9d2I49I2PwrZqOwIlAC9Z36ptNNAsHgbmGVW5Vu5o7L8Gh/HD7cYM
         D8YonEuyZRi+jrQCL6fQBXji36xKo9c73E0reLM1Q7HUrHU+uNNuGC5QFOlgJHhyL8
         U57DpfXqo6oVOMJ3GjN18/SJlmqacxRAxAz5g300auy+YximNE5PG7PiHYnUlxAHXR
         xvsQmvSjZsKluuC5Xzg3omIGh3RLRm9+ww7rmipZqDIYKF+cqXLA+JNCmBq4YCuON5
         kdiKC5YR0wzUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A8AFC5C7C6;
        Wed,  7 Dec 2022 04:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: sja1105: fix memory leak in
 sja1105_setup_devlink_regions()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167038801636.19727.11005345882247395111.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 04:40:16 +0000
References: <20221205012132.2110979-1-shaozhengchao@huawei.com>
In-Reply-To: <20221205012132.2110979-1-shaozhengchao@huawei.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
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

On Mon, 5 Dec 2022 09:21:32 +0800 you wrote:
> When dsa_devlink_region_create failed in sja1105_setup_devlink_regions(),
> priv->regions is not released.
> 
> Fixes: bf425b82059e ("net: dsa: sja1105: expose static config as devlink region")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_devlink.c | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - net: dsa: sja1105: fix memory leak in sja1105_setup_devlink_regions()
    https://git.kernel.org/netdev/net/c/78a9ea43fc1a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


