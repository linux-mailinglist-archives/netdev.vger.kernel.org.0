Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C92462B9A
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 05:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238160AbhK3EXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 23:23:33 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39456 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238140AbhK3EXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 23:23:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 379DCCE1774;
        Tue, 30 Nov 2021 04:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56852C53FCC;
        Tue, 30 Nov 2021 04:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638246011;
        bh=FdnIHTyocyzQQLGNo2feJtJEXjqHUWQkOpxIOGJFXrw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U3f5Ldza0eP+JNvdDqqegPkCpWX6kkcGmk+iV+Bpw+6YwRFKVpBki00w+Ox0XrDe4
         qKVZJg7Bf03uTSYTfXEAZDjxsLlzqta8UOReTuvrqIaWuuSTRCzZYDBxfYVaW/XCpP
         3FugnmNsSdf3e2+ZVRKcaN8B5nQWRQIcfFv96PrT1JsdfRlI58q5AMQZN6AlUQKsP6
         ZxgS28YpJdcsgviME11Xz4xmflIqvZwSDtOW8uVcXUmyp7El07ql5pftJZgQwPWao8
         Ty7KDgBg7v303Ndo8xuiZpgD0SMNU3lQWXOxQ3lKIeJQo68G3eRPmzBpAs+zcCiznb
         ORqeJWvO+omVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3093B60A5A;
        Tue, 30 Nov 2021 04:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] rxrpc: Leak fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163824601119.29763.1146825132755537453.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 04:20:11 +0000
References: <163820097905.226370.17234085194655347888.stgit@warthog.procyon.org.uk>
In-Reply-To: <163820097905.226370.17234085194655347888.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        marc.dionne@auristor.com, eiichi.tsukata@nutanix.com,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David Howells <dhowells@redhat.com>:

On Mon, 29 Nov 2021 15:49:39 +0000 you wrote:
> Here are a couple of fixes for leaks in AF_RXRPC:
> 
>  (1) Fix a leak of rxrpc_peer structs in rxrpc_look_up_bundle().
> 
>  (2) Fix a leak of rxrpc_local structs in rxrpc_lookup_peer().
> 
> The patches are tagged here:
> 
> [...]

Here is the summary with links:
  - [net,1/2] rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()
    https://git.kernel.org/netdev/net/c/ca77fba82135
  - [net,2/2] rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()
    https://git.kernel.org/netdev/net/c/beacff50edbd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


