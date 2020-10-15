Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED08828F8AC
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730950AbgJOSdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 14:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgJOSdC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 14:33:02 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602786781;
        bh=de+spJiuW0MoskwctT/cBv2p6oj7cQouTTaBzGjjGtU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DbDrwR/37Zi2rof/0EuqMbCHltA0ZrgyUS2NxzGonlidlF1RsOuqt6ZyMxnc0PK1n
         aWGQXLPin4l6v/PhBul8pWhUtbvdblGYiT1wZaUphRwRDk/lgNL2OhIvwyp3XEF/Tb
         WS56TBBALxy2FPxfbuDGH8o295LfX86rY79tIqNk=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] rxrpc: Fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160278678121.17812.13011148239593102113.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Oct 2020 18:33:01 +0000
References: <160276675194.955243.3551319337030732277.stgit@warthog.procyon.org.uk>
In-Reply-To: <160276675194.955243.3551319337030732277.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 15 Oct 2020 13:59:11 +0100 you wrote:
> Here are a couple of fixes that need to be applied on top of rxrpc patches
> in net-next:
> 
>  (1) Fix a bug in the connection bundle changes in the net-next tree.
> 
>  (2) Fix the loss of final ACK on socket shutdown.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] rxrpc: Fix bundle counting for exclusive connections
    https://git.kernel.org/netdev/net-next/c/f3af4ad1e08a
  - [net-next,2/2] rxrpc: Fix loss of final ack on shutdown
    https://git.kernel.org/netdev/net-next/c/ddc7834af8d5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


