Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863C662B297
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 06:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiKPFKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 00:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKPFKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 00:10:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2516D18E20
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 21:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF65C615C4
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 05:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EECBAC433D7;
        Wed, 16 Nov 2022 05:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668575416;
        bh=9+h1w5gKY6sFK6oaS7tjjV/pGZBjMTGBpkDQr17bOmM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rZqiCz1Do3QJrYbc5kPr2iLpNJuLeLorkOQiNK4ES8ObNN9z6svvY3ri8PWkXFEtZ
         8LrHPEgWiE9+S8gpiT7rwH69HfuUbdqCbM2W9jLjIAe1Fz9+/V6cCS7KTV7xiDNyAW
         5lon5zfyh3T0tuUVmU3y8k87gRyYKi3HNcPFTqpkFeSAIyhRNciZT2PuSyzw8I1B8C
         Qz+F8Lh1uaA35LvHm+ZYgbXXzaDoA16SZQyBx5nJPZBYdcfIdStm3WEQtsO/RCFkT6
         CQDtKgB7oIdaHMk2oN2MvU57X7WQe0KezwuIrNdyc4GFtNL1dhQpctqmViNFLTs0Nr
         7uzJh/ymbhLEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5182E21EFE;
        Wed, 16 Nov 2022 05:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: don't leak tagger-owned storage on switch
 driver unbind
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166857541586.12533.2602592342499682605.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 05:10:15 +0000
References: <20221114143551.1906361-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221114143551.1906361-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
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

On Mon, 14 Nov 2022 16:35:51 +0200 you wrote:
> In the initial commit dc452a471dba ("net: dsa: introduce tagger-owned
> storage for private and shared data"), we had a call to
> tag_ops->disconnect(dst) issued from dsa_tree_free(), which is called at
> tree teardown time.
> 
> There were problems with connecting to a switch tree as a whole, so this
> got reworked to connecting to individual switches within the tree. In
> this process, tag_ops->disconnect(ds) was made to be called only from
> switch.c (cross-chip notifiers emitted as a result of dynamic tag proto
> changes), but the normal driver teardown code path wasn't replaced with
> anything.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: don't leak tagger-owned storage on switch driver unbind
    https://git.kernel.org/netdev/net/c/4e0c19fcb8b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


