Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F786509FA
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 11:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiLSKUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 05:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiLSKUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 05:20:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE9CDEE7;
        Mon, 19 Dec 2022 02:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC14560EE7;
        Mon, 19 Dec 2022 10:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59FD1C433F0;
        Mon, 19 Dec 2022 10:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671445217;
        bh=5l2+H81WJDeQl++asDPSeSFnj4CQZAXDdnJPaHp4lD4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u0zVSeHuZg9ATkyP9Qbsmp+0nvbNmVlekQ+qoKDXYr40R0rs9vDOqcRPxK39/vfQL
         ys0CkChjcuBBIWGAiJk7z/aqUoQ4mIs7TBrqzHPOaCIHgFlkBr0vrm/2aixhb4KVNM
         fN75D7OFxS13cJQLTABqlt4Bo4cC1R97gQCqwH2zDvp50VEvxjN4Ysp6P4KcHGRmrp
         TesUlDmGjY7pwM1NStg1lnFSZPg/I/8pFQ2g8aAtFqM+tOlJAsSuS6juGEUGnS+94A
         vp/OgTuJPWZj1IDjFUfi/VS9qxGSNgOwXDxbhGgKqXaO7rLvIP1ciuLW4M4V9KpVxM
         +WG0BGgu/QQVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 38886E21EEE;
        Mon, 19 Dec 2022 10:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/9] rxrpc: Fixes for I/O thread conversion/SACK table
 expansion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167144521722.28172.4423252711475608734.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Dec 2022 10:20:17 +0000
References: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
In-Reply-To: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, error27@gmail.com,
        linux-afs@lists.infradead.org, marc.dionne@auristor.com,
        hdanton@sina.com,
        syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 15 Dec 2022 16:19:38 +0000 you wrote:
> Here are some fixes for AF_RXRPC:
> 
>  (1) Fix missing unlock in rxrpc's sendmsg.
> 
>  (2) Fix (lack of) propagation of security settings to rxrpc_call.
> 
>  (3) Fix NULL ptr deref in rxrpc_unuse_local().
> 
> [...]

Here is the summary with links:
  - [net,1/9] rxrpc: Fix missing unlock in rxrpc_do_sendmsg()
    https://git.kernel.org/netdev/net/c/4feb2c44629e
  - [net,2/9] rxrpc: Fix security setting propagation
    https://git.kernel.org/netdev/net/c/fdb99487b018
  - [net,3/9] rxrpc: Fix NULL deref in rxrpc_unuse_local()
    https://git.kernel.org/netdev/net/c/eaa02390adb0
  - [net,4/9] rxrpc: Fix I/O thread startup getting skipped
    https://git.kernel.org/netdev/net/c/8fbcc83334a7
  - [net,5/9] rxrpc: Fix locking issues in rxrpc_put_peer_locked()
    https://git.kernel.org/netdev/net/c/608aecd16a31
  - [net,6/9] rxrpc: Fix switched parameters in peer tracing
    https://git.kernel.org/netdev/net/c/c838f1a73d77
  - [net,7/9] rxrpc: Fix I/O thread stop
    https://git.kernel.org/netdev/net/c/743d1768a008
  - [net,8/9] rxrpc: rxperf: Fix uninitialised variable
    https://git.kernel.org/netdev/net/c/11e1706bc84f
  - [net,9/9] rxrpc: Fix the return value of rxrpc_new_incoming_call()
    https://git.kernel.org/netdev/net/c/31d35a02ad5b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


