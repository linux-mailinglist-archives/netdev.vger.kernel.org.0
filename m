Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F4C515D55
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 15:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382693AbiD3NNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 09:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380509AbiD3NNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 09:13:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3360E12086;
        Sat, 30 Apr 2022 06:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28E7DB82B70;
        Sat, 30 Apr 2022 13:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0B25C385A7;
        Sat, 30 Apr 2022 13:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651324210;
        bh=Xx2UgnFkR/QPeDIHJlOOc/xs0nNUqnZFf9vqF2zUImY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ufj/vsENd6XGNJdBFvFELoJhEVczhFPnjZGcSTbT0SnAzw1PIUTRFy7LkDT1Wx5LW
         V6ELV0LN1E3rNut5+WOlHJeR+WZR6dE/fY89iw9XxlDXm67WXggtDfZwYbMnvka486
         TYTPw/n09hDqLfRCrLRDAHM2g6Koxdjd6/1msbGG03v7obiHOjkRBd/kRiowAEFWnc
         kVouwKvQwQOIFLfG3DH5CBugRzvZYRvyTBwKdjW5D98wYJF/tgEXYgZL9tHehAlmKG
         8KUvAcEHHVC473oHwyevSnIdkHHlDyxbTRYRjVvPYUMZHJqO89/U8K9RmUQJVCX2uV
         KbPkmaB0eSXgg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD9A1F03841;
        Sat, 30 Apr 2022 13:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: Enable IPv6 checksums on transport socket
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165132421070.7001.755926570910238927.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 13:10:10 +0000
References: <165126271697.1384698.4579591150130001289.stgit@warthog.procyon.org.uk>
In-Reply-To: <165126271697.1384698.4579591150130001289.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, marc.dionne@auristor.com,
        lucien.xin@gmail.com, vfedorenko@novek.ru, davem@davemloft.net,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 29 Apr 2022 21:05:16 +0100 you wrote:
> AF_RXRPC doesn't currently enable IPv6 UDP Tx checksums on the transport
> socket it opens and the checksums in the packets it generates end up 0.
> 
> It probably should also enable IPv6 UDP Rx checksums and IPv4 UDP
> checksums.  The latter only seem to be applied if the socket family is
> AF_INET and don't seem to apply if it's AF_INET6.  IPv4 packets from an
> IPv6 socket seem to have checksums anyway.
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: Enable IPv6 checksums on transport socket
    https://git.kernel.org/netdev/net/c/39cb9faa5d46

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


