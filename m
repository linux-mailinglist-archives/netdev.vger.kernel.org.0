Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D164F6493
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236775AbiDFPvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236489AbiDFPvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:51:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA21362338;
        Wed,  6 Apr 2022 06:10:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B405B8234F;
        Wed,  6 Apr 2022 13:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5102C385B1;
        Wed,  6 Apr 2022 13:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649250613;
        bh=+yUJtzjn1ArmUE7XUO1CCn8ocGMtCDkReX34QkTdbEw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kA9gnkZ/Z9z0a+3Eb0YiNlOohIMvagM93xXmoiTo2r0YvvMorFa7BQkLl/8eprgG8
         h+5bUzHzB9czo6jTkuEo+hdw9XDQtEmkIQSJboR0Mq1KkM8BAXjfwMltTmaYGvFcsC
         l5+vMtfw+I8FaWdnMRG4alrp4sWD6chSq4EjDuuGoUxLCctQ205vMrqc1OZyDxBUzs
         GQfIZBXEQo4Kf+CY2izvTJe37tZdwtNuMgGLWA5DpwdQMvJAjaDff/0qW4vGSb3T16
         43g/J1Cox9+4lAVi2oiDAJVc2CXlCYTpSsA1aH8l/OimSg3tDEBJ8SJb8lr+a2Kk/b
         PBqDjpnEAN4eQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 93453E8DBDA;
        Wed,  6 Apr 2022 13:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: sfc: fix using uninitialized xdp tx_queue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164925061359.5679.6011244296851234983.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 13:10:13 +0000
References: <20220405084544.2763-1-ap420073@gmail.com>
In-Reply-To: <20220405084544.2763-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        cmclachlan@solarflare.com, bpf@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  5 Apr 2022 08:45:44 +0000 you wrote:
> In some cases, xdp tx_queue can get used before initialization.
> 1. interface up/down
> 2. ring buffer size change
> 
> When CPU cores are lower than maximum number of channels of sfc driver,
> it creates new channels only for XDP.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: sfc: fix using uninitialized xdp tx_queue
    https://git.kernel.org/netdev/net/c/fb5833d81e43

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


