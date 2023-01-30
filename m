Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA80168069C
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 08:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbjA3HkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 02:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbjA3HkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 02:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6B929428;
        Sun, 29 Jan 2023 23:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B15ECB80DEA;
        Mon, 30 Jan 2023 07:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56079C433D2;
        Mon, 30 Jan 2023 07:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675064416;
        bh=8yVisn/1+2M3nRRRBQrIsODeQaLdwjW82PLGIyzKcXA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p2YFUo49qUZPvGwkucOLcXGuVnqYFYJRBeuz8m22lAaRkBNOV4vuEfLQY0frgybNq
         GaqitSzTzKYILGx97UEoq6UAdUYEn6wcbW2Td7AuWnY/DLJy21zv1QTucYT/DObAD2
         ILEFUh7xHTp2PyK6u0UczLseP9Yz40Fpo6FeNajFGcJ28daSBgDs3x5HlVHms64XdL
         LSGbMLenj5MKsammniCgGdmdmQYQBv5mA0rAoUPbRQIyDDMj8U8CnFpFnOUIuQ0nfu
         +KHFv3505CqIdyr0lHhFyZezguo1DTBX9gMkJTgHtw6HA9+3hy4nWx4SJccTBnop3f
         cI0VUPnmvE63w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3BA39E21ED8;
        Mon, 30 Jan 2023 07:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] netrom: Fix use-after-free caused by accept on already
 connected socket
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167506441623.19672.3737671367502579587.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Jan 2023 07:40:16 +0000
References: <20230127023250.GA71840@ubuntu>
In-Reply-To: <20230127023250.GA71840@ubuntu>
To:     Hyunwoo Kim <v4bel@theori.io>
Cc:     ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kuniyu@amazon.com,
        imv4bel@gmail.com, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+caa188bdfc1eeafeb418@syzkaller.appspotmail.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 26 Jan 2023 18:32:50 -0800 you wrote:
> If you call listen() and accept() on an already connect()ed
> AF_NETROM socket, accept() can successfully connect.
> This is because when the peer socket sends data to sendmsg,
> the skb with its own sk stored in the connected socket's
> sk->sk_receive_queue is connected, and nr_accept() dequeues
> the skb waiting in the sk->sk_receive_queue.
> 
> [...]

Here is the summary with links:
  - [v4] netrom: Fix use-after-free caused by accept on already connected socket
    https://git.kernel.org/netdev/net/c/611792920925

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


