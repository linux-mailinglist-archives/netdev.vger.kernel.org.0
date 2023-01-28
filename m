Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B4167F573
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 08:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjA1HUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 02:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjA1HUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 02:20:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B664E7E6CC;
        Fri, 27 Jan 2023 23:20:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EEFE60A25;
        Sat, 28 Jan 2023 07:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0893C4339B;
        Sat, 28 Jan 2023 07:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674890434;
        bh=MeyRTq/arodCF8K5T7IZpkPAOx4UAPBza5Pct0eGIjI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FDCdhCzLMvi+7ovTVkyKQFAYh5K740tEV1O/iDNCTjEN5w6tjO5fFG0pLWPx1uyby
         vTy839buesfXbrUiRHPSSnDFn7oyPUbXsDHXenEWIMfB3i3GevzxQBYyGWUNDChJuN
         dgcl7FyMMEVyz0kYZHecmaG2OBHdmVWR6q95P72QDQqRdm/2AnojhafuosjXKK1HaH
         Kd/HwtTTtZi4A9yVho8adWOPmWGTvNh8fmmfVU2kTL/o08tPFC7eYziARBQr3JZtcd
         4541dsQ2bsQSLxZEr+zKTyTzqffTdeaUegGLs2mhiyZ60u+RegdQZpNNFauIZ25VwB
         +bNKaz9KdcGVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 87D24E54D2D;
        Sat, 28 Jan 2023 07:20:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net/x25: Fix to not accept on connected socket
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167489043455.16992.12517633627951269745.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Jan 2023 07:20:34 +0000
References: <20230125110514.GA134174@ubuntu>
In-Reply-To: <20230125110514.GA134174@ubuntu>
To:     Hyunwoo Kim <v4bel@theori.io>
Cc:     ms@dev.tdt.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kuniyu@amazon.com,
        imv4bel@gmail.com, linux-x25@vger.kernel.org,
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 25 Jan 2023 03:05:14 -0800 you wrote:
> If you call listen() and accept() on an already connect()ed
> x25 socket, accept() can successfully connect.
> This is because when the peer socket sends data to sendmsg,
> the skb with its own sk stored in the connected socket's
> sk->sk_receive_queue is connected, and x25_accept() dequeues
> the skb waiting in the sk->sk_receive_queue.
> 
> [...]

Here is the summary with links:
  - [v3] net/x25: Fix to not accept on connected socket
    https://git.kernel.org/netdev/net-next/c/f2b0b5210f67

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


