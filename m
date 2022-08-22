Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7165459C093
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 15:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbiHVNaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 09:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234201AbiHVNaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 09:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809E211172;
        Mon, 22 Aug 2022 06:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 184E261197;
        Mon, 22 Aug 2022 13:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 714CFC433D7;
        Mon, 22 Aug 2022 13:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661175014;
        bh=Br3dFwFRKh/ahgdNc3tJhfg8BpRtaS6hl84zqsj1IYg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uwG4falmfE+b83C+0Kk7MSK4UDH0aIctQdfs/EFkJ4PfZq4B1mry3qI3ypJopg7vk
         rpES1nCLFjbW0Q1scF8OqP6uUGAvBvIWxUMgjZ63JmAxHiywNTmfBsHV3nzEjFAYKd
         L6adaW/YBCWBJpYUDK4cvFG5q8i5lcIuvFgYbSMEsru5pRoCK80pkE1HJJWBS/W2Nw
         lsY85GJh5w007sG4JKcHzvkINWIlcf6dHVNQSs8v9VULQqr7m9/yqdP5jYAeCaN1xb
         jIMUpyC9wqYVB4EVSG3pajzzGeMUTRZxpK280JQqTNS04vmuJupDEKairtTTFyGlGb
         bYKx62hp3RZog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5488FE2A03D;
        Mon, 22 Aug 2022 13:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 1/1] rose: check NULL rose_loopback_neigh->loopback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166117501433.5977.6208963641259789772.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Aug 2022 13:30:14 +0000
References: <Yv2BhXInteHP7eJm@electric-eye.fr.zoreil.com>
In-Reply-To: <Yv2BhXInteHP7eJm@electric-eye.fr.zoreil.com>
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     netdev@vger.kernel.org, linux-hams@vger.kernel.org,
        bernard.f6bvp@gmail.com, f6bvp@free.fr, thomas@osterried.de,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
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

On Thu, 18 Aug 2022 02:02:13 +0200 you wrote:
> From: Bernard Pidoux <f6bvp@free.fr>
> 
> Commit 3b3fd068c56e3fbea30090859216a368398e39bf added NULL check for
> `rose_loopback_neigh->dev` in rose_loopback_timer() but omitted to
> check rose_loopback_neigh->loopback.
> 
> It thus prevents *all* rose connect.
> 
> [...]

Here is the summary with links:
  - [v2,net,1/1] rose: check NULL rose_loopback_neigh->loopback
    https://git.kernel.org/netdev/net/c/3c53cd65dece

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


