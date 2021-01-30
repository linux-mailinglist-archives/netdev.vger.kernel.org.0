Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF69A30925B
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 06:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbhA3Fwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 00:52:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233849AbhA3Fuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 00:50:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4611C64E0F;
        Sat, 30 Jan 2021 05:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611985806;
        bh=YkktA9D2RqrvOfXpjwsBY5F76WSWd/IdZxmcSThDbA8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uYsifhWEWDK08jskAsg1IHaW3ayliEsO6LalfgCUFy2KoBjux9IqiSTcmF3kJq8Nm
         0Q7+IjwrkkZdVHIJc2MaW94fyRRC1g040j4IbjVc6RYB849xhJzGmsf+M2giljSUEl
         ib1YP01tgmahUIBPFMa5QpIGBsLsI1kNl+ro+dtVzneYcgKSXrR+roTmfcC/hEghVT
         gjVgCQ8Qp47ft7UWrVOAaEAMtFwfDmTLQdTURmwcz42AyCO71g1dZcfWkIrkLR2FRs
         zr4a1MZhqns1E8zyGEb2uwSlR5dl/jjN0L98WwF4sNvk3FjuasJ0ghKxOChyTh3tyd
         3NsG483V9YJFQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 34F9260983;
        Sat, 30 Jan 2021 05:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: Fix deadlock around release of dst cached on udp
 tunnel
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161198580621.4523.3032466823859435462.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jan 2021 05:50:06 +0000
References: <161196443016.3868642.5577440140646403533.stgit@warthog.procyon.org.uk>
In-Reply-To: <161196443016.3868642.5577440140646403533.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org,
        syzbot+df400f2f24a1677cd7e0@syzkaller.appspotmail.com,
        vfedorenko@novek.ru, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 29 Jan 2021 23:53:50 +0000 you wrote:
> AF_RXRPC sockets use UDP ports in encap mode.  This causes socket and dst
> from an incoming packet to get stolen and attached to the UDP socket from
> whence it is leaked when that socket is closed.
> 
> When a network namespace is removed, the wait for dst records to be cleaned
> up happens before the cleanup of the rxrpc and UDP socket, meaning that the
> wait never finishes.
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: Fix deadlock around release of dst cached on udp tunnel
    https://git.kernel.org/netdev/net/c/5399d52233c4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


