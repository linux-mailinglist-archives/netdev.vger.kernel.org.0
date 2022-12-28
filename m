Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09467657504
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 11:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbiL1KAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 05:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiL1KAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 05:00:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAEE10065
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 02:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58109B8129F
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 10:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22F7AC433D2;
        Wed, 28 Dec 2022 10:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672221616;
        bh=rVxyhW5FFGOKtgNvHekze6Nb9G/t+Si/q+EtN44lIB8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Iq+NkOj3g2CGjSosusVClLKdaCzH2g6pMUSDhZhqhbYG9e5SYkzbynA5ljWwvZ2DE
         OHg5fsRW2wOpj6C1WgucZpTQnxYCqrN7EESPKVGeZtH3NjxK8I3LLFCN/pBX9fVQ5R
         w6dzLSgknWoUFgRwniWgbfSAbHJuPkF5NDWLip5SaZm7tDUELEz+dCMpLEnGP21rmq
         Vit95kKcTMJ/7mGy6VzfltIMygO69QWPbAWExKrsYpxneK6cKlcPW32jwDWIFbL8sk
         LlozA39Xb6o07zUeOzIvTwujRzWeUsTZAL2ioG0/yUJsbZRv0od+zBNvo7WTySnnFJ
         E1K74GAexCOng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0DDBEE50D70;
        Wed, 28 Dec 2022 10:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: Fix a couple of potential use-after-frees
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167222161605.1927.10892054873616365376.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Dec 2022 10:00:16 +0000
References: <167189334008.2649494.14058695597250049586.stgit@warthog.procyon.org.uk>
In-Reply-To: <167189334008.2649494.14058695597250049586.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, marc.dionne@auristor.com,
        linux-afs@lists.infradead.org
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

On Sat, 24 Dec 2022 14:49:00 +0000 you wrote:
> At the end of rxrpc_recvmsg(), if a call is found, the call is put and then
> a trace line is emitted referencing that call in a couple of places - but
> the call may have been deallocated by the time those traces happen.
> 
> Fix this by stashing the call debug_id in a variable and passing that to
> the tracepoint rather than the call pointer.
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: Fix a couple of potential use-after-frees
    https://git.kernel.org/netdev/net/c/0e50d999903c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


