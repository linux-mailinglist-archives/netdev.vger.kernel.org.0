Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79D55A0701
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 03:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbiHYB5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 21:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbiHYB47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 21:56:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCF0A1D0D;
        Wed, 24 Aug 2022 18:51:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05EA760DE4;
        Thu, 25 Aug 2022 01:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60A95C4347C;
        Thu, 25 Aug 2022 01:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661392214;
        bh=pcOqHJ5OtoMjIvOh0M9GjMirUSz25xmeL8d2/yf+u+c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qtioLEhDnng4MZcBkq1rYE1rzQ2a3Ixn7F0HvxMX3vlGxeaat3FvF8NN1+uRe+zdF
         argS+1rxX1+r4bxiEFcYtV2PhU8D+ynLqfqVHR+1H0aq4CxgEWOGbRZC/2CJbkQ22s
         plXd9hbGLUtMC+2Nl+rAPMWHDzq29kPiqV3nDoB0BSCfdNFgoBc45xilCLAbCGxsS+
         aJF5WrIv6oqQpwBA7Q5S5wqlfbNsy+bLIuOekVUYov9lwqdh3psdyWvupKaZR+jYTQ
         kGwNMAYYNqDTH3Akn8UfDBZcx1MS7tuhFpa0irpkpJfFZNETPHWRUnNx/k7UwmqOet
         cP9YHOjkHDyDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48110C0C3EC;
        Thu, 25 Aug 2022 01:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Documentation: sysctl: align cells in second content
 column
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166139221428.11258.13872554797501208069.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 01:50:14 +0000
References: <20220824035804.204322-1-bagasdotme@gmail.com>
In-Reply-To: <20220824035804.204322-1-bagasdotme@gmail.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        corbet@lwn.net, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, hmukos@yandex-team.ru, lucien.xin@gmail.com,
        stephen@networkplumber.org, atenart@kernel.org,
        razor@blackwall.org, dsahern@kernel.org, sfr@canb.auug.org.au
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Aug 2022 10:58:04 +0700 you wrote:
> Stephen Rothwell reported htmldocs warning when merging net-next tree:
> 
> Documentation/admin-guide/sysctl/net.rst:37: WARNING: Malformed table.
> Text in column margin in table line 4.
> 
> ========= =================== = ========== ==================
> Directory Content               Directory  Content
> ========= =================== = ========== ==================
> 802       E802 protocol         mptcp     Multipath TCP
> appletalk Appletalk protocol    netfilter Network Filter
> ax25      AX25                  netrom     NET/ROM
> bridge    Bridging              rose      X.25 PLP layer
> core      General parameter     tipc      TIPC
> ethernet  Ethernet protocol     unix      Unix domain sockets
> ipv4      IP version 4          x25       X.25 protocol
> ipv6      IP version 6
> ========= =================== = ========== ==================
> 
> [...]

Here is the summary with links:
  - [net-next] Documentation: sysctl: align cells in second content column
    https://git.kernel.org/netdev/net-next/c/1faa34672f8a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


