Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7A5506D5A
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 15:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349866AbiDSNW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348439AbiDSNW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:22:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8CFDF8A
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 06:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 810F161630
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 13:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB5D4C385AD;
        Tue, 19 Apr 2022 13:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650374412;
        bh=DC0Xb0Npd1G7yjXbe9NNKYjqNA35lhaHmwTAus+3eaM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B9RoW+J4yBLLYQ11j2RVTSD10csbeDau3/PMQ5dN8DTmaEeIk+WOPI5NdNO+nWuGS
         ZWH+5SOsN/FyIMmxLXudPZW6SQuIoAWzhtNeQckriP9PGYrTFl60QeCcjhBXxhOo4Z
         3LRWtXoYlhdLefTRXW6tgBbBoDlcxWZTk2Gynk+1RfWcGWmTLcmR7wS4D0qUmoCR7T
         /kh1V7Eo621l5q9qLWdrpEFrzzc+samt8nyhmP1ImQ3mkqP4+gjJ1EFLbPyYttGrV0
         XAukDfvqsOWbEkyCXc/zUOUIhtEjdxNz9ifm6OmXY2pqRhyU0YTIca/iuUOHQmIU50
         eR7gwZIZ10vpA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B96D2E8DD61;
        Tue, 19 Apr 2022 13:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netlink: reset network and mac headers in netlink_dump()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165037441175.13215.17556619254098753644.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Apr 2022 13:20:11 +0000
References: <20220415181442.551228-1-eric.dumazet@gmail.com>
In-Reply-To: <20220415181442.551228-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com,
        syzkaller@googlegroups.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 15 Apr 2022 11:14:42 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> netlink_dump() is allocating an skb, reserves space in it
> but forgets to reset network header.
> 
> This allows a BPF program, invoked later from sk_filter()
> to access uninitialized kernel memory from the reserved
> space.
> 
> [...]

Here is the summary with links:
  - [net] netlink: reset network and mac headers in netlink_dump()
    https://git.kernel.org/netdev/net/c/99c07327ae11

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


