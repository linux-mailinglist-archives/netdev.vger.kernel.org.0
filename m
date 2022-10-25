Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DEE60D7B1
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 01:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiJYXKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 19:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiJYXKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 19:10:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5C52AE30
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 16:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C1E2B81F97
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 23:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2293C433D7;
        Tue, 25 Oct 2022 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666739417;
        bh=aBKStai0C64juvFh12n/LiZ7bwz8hrQkGd+trJh8zMU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JRuq5c2JZx9LO2E1H312hhCHqkQ8cH7DZy+LRypBDOyPbh2QMFrczINJ9V6/xp8YW
         bXGyuj672qzPi6T6kqAUP5Tgd0rmf/cJyKITtpbm8tyIwrA2GskUAHLRZ6h7/e+1S9
         Jziz0aQchZlB9Yu5zhpRlVe+x5yYrICRye1pqEzsr8YpLnDtXTZMwJUJDS+i7R7ttT
         LkgtggYq7OqEQHgu0Kl16Djp5IIm9yOVDqCFwdSo1T1/RHhxbVxrHC5BG/neje6C5v
         RghBvMO0FPPCQjvjk/t6R3Vt3CkqDRH/RC+H5H+PLRQd9IPBdtI5yhDq5CRQbrr5cZ
         DXZQnkZZkUhxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BC89EE45192;
        Tue, 25 Oct 2022 23:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: ensure sane device mtu in tunnels
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166673941676.28648.14163356018533652801.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Oct 2022 23:10:16 +0000
References: <20221024020124.3756833-1-eric.dumazet@gmail.com>
In-Reply-To: <20221024020124.3756833-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com,
        syzkaller@googlegroups.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun, 23 Oct 2022 19:01:24 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Another syzbot report [1] with no reproducer hints
> at a bug in ip6_gre tunnel (dev:ip6gretap0)
> 
> Since ipv6 mcast code makes sure to read dev->mtu once
> and applies a sanity check on it (see commit b9b312a7a451
> "ipv6: mcast: better catch silly mtu values"), a remaining
> possibility is that a layer is able to set dev->mtu to
> an underflowed value (high order bit set).
> 
> [...]

Here is the summary with links:
  - [net] ipv6: ensure sane device mtu in tunnels
    https://git.kernel.org/netdev/net/c/d89d7ff01235

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


