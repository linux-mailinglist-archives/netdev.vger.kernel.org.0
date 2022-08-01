Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0D758716E
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbiHATaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 15:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbiHATaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:30:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F872BE1;
        Mon,  1 Aug 2022 12:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1618CCE1884;
        Mon,  1 Aug 2022 19:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A584C433B5;
        Mon,  1 Aug 2022 19:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659382214;
        bh=I2NgVtOZ4TGglwULwwe3wQH5lHMLGhGHZFNhX7BecuE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XrZzqfVQGG1oANpx70ErYaWefSkXs7N2TLXgKtlSiV//YxvvoZIXqWGZlCcvSssUW
         i371WmIGKV+GZfqSAmJG1ERTD5V02gNHwxiLSCQz98ZF6QfUxWbjoHO9fiS1B6vwfC
         Mi2d93N0mliOOzpzuY4tXFpbt6Dk8sPYCfFpbki55Mi/opoBJzs6ns31Krb0vPxzQN
         x8QlQ0cVR5tLdRUaYjNHKJLhtYYvILXHUmsZobh17+AZOKTqW4Ym4xNxdSZb8ZGCyK
         gk/xyVNaSQXvyJ64N8CUmDg5ByiYxInpOpmhoYlXSntU8uY+9OsczOukdIZKRanzPZ
         gj9+EjU7m46wA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B271C43144;
        Mon,  1 Aug 2022 19:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: dsa: Fix spelling mistakes and cleanup code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165938221410.30942.7429616633323019916.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 19:30:14 +0000
References: <20220730092254.3102875-1-studentxswpy@163.com>
In-Reply-To: <20220730092254.3102875-1-studentxswpy@163.com>
To:     None <studentxswpy@163.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hacashRobot@santino.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 30 Jul 2022 17:22:54 +0800 you wrote:
> From: Xie Shaowen <studentxswpy@163.com>
> 
> fix follow spelling misktakes:
> 	desconstructed ==> deconstructed
> 	enforcment ==> enforcement
> 
> Reported-by: Hacash Robot <hacashRobot@santino.com>
> Signed-off-by: Xie Shaowen <studentxswpy@163.com>
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: dsa: Fix spelling mistakes and cleanup code
    https://git.kernel.org/netdev/net-next/c/062cf5ebc2e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


