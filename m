Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8F8697578
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 05:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjBOEkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 23:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBOEkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 23:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1636E82
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 20:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93BCF61A1E
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 04:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0394C433D2;
        Wed, 15 Feb 2023 04:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676436018;
        bh=qooXKZ5hQbPND5bqla7nZ7LRtj5E4Z261EybdM+NDTo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lZmupEk5B+pqXsngDvobGt0oXEL0Vg25CCCDuzbgOpb+Rt3qPv0WSHoCEUudM0rR8
         13QKZk0yJ5YayXbaM+wn0jMSspgmvgi+Eq82uAnrC9Ie4i14mE/DROYWVgtFW7IibL
         wx31YaohzXx2/9cgoAfLvvYyiVCdNv0lbBoQl0E0al5PtKtvv7FPV1EABGUE7IExED
         Y7c7+cUKKm8Ipb4GBBrlU5Go2CRj4d+tddDPx/GlMVxIBHsKHOECd/BAyUuFw10hjX
         AfSz/S8mgFRugA3SZBeD+ybpxtRxH/vZDAfY3ZB6KwJVXHkyEjN4rY23fJI2lSJtB7
         1cmAcNkzukljQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C45BAC4166F;
        Wed, 15 Feb 2023 04:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: use a bounce buffer for copying skb->mark
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167643601779.13762.14947321801246008920.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Feb 2023 04:40:17 +0000
References: <20230213160059.3829741-1-edumazet@google.com>
In-Reply-To: <20230213160059.3829741-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, lnx.erin@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 13 Feb 2023 16:00:59 +0000 you wrote:
> syzbot found arm64 builds would crash in sock_recv_mark()
> when CONFIG_HARDENED_USERCOPY=y
> 
> x86 and powerpc are not detecting the issue because
> they define user_access_begin.
> This will be handled in a different patch,
> because a check_object_size() is missing.
> 
> [...]

Here is the summary with links:
  - [net] net: use a bounce buffer for copying skb->mark
    https://git.kernel.org/netdev/net/c/2558b8039d05

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


