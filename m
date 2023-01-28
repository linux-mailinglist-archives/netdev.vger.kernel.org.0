Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F6A67F668
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 09:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbjA1IkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 03:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjA1IkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 03:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9C71D90B;
        Sat, 28 Jan 2023 00:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4371060B4C;
        Sat, 28 Jan 2023 08:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D6B1C4339B;
        Sat, 28 Jan 2023 08:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674895217;
        bh=5DtihC7IDWg5Cik8Koa582mUpiA0AhfmuQ356hSeT8M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZJwRTt1zuum2KUQa62leQbyxsieOkueQThLebDT+kOalB2eclUNse3asoy8ISew0L
         mJNlQpJ0nkfd6XzokDSouhhR32HYSs9QC1AVPq1lmo6q8AL02TMmC+O6Xetasc5dYW
         tSpenVS2uCb2yN1yhTPHsZW4Z9fXKt98fslKgdZ8m2P16ULl5jKnklbahkEF+gBWT4
         30eJ1qhth/ihfYnII/9n+XtM2CUBhbdQJ4PeOoCrb0zv0gxPSrIK+TJNpQFJA2oyNT
         l86jkW2dMi/iSRpqJKLy5G7CU+mElFnwvit7a9opOz40OOLoa2SBc72GUdjqd2E+T7
         Vdf64tSKZg75g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8031FF83ECD;
        Sat, 28 Jan 2023 08:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net/rose: Fix to not accept on connected socket
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167489521752.20245.5567947233486771877.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Jan 2023 08:40:17 +0000
References: <20230125105944.GA133314@ubuntu>
In-Reply-To: <20230125105944.GA133314@ubuntu>
To:     Hyunwoo Kim <v4bel@theori.io>
Cc:     ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kuniyu@amazon.com,
        imv4bel@gmail.com, linux-hams@vger.kernel.org,
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

On Wed, 25 Jan 2023 02:59:44 -0800 you wrote:
> If you call listen() and accept() on an already connect()ed
> rose socket, accept() can successfully connect.
> This is because when the peer socket sends data to sendmsg,
> the skb with its own sk stored in the connected socket's
> sk->sk_receive_queue is connected, and rose_accept() dequeues
> the skb waiting in the sk->sk_receive_queue.
> 
> [...]

Here is the summary with links:
  - [v3] net/rose: Fix to not accept on connected socket
    https://git.kernel.org/netdev/net/c/14caefcf9837

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


