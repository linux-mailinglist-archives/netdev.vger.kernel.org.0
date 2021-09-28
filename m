Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B3541AF0E
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240760AbhI1Mby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:31:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240555AbhI1Mbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:31:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 39493611C3;
        Tue, 28 Sep 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632832208;
        bh=I3XWtdOD1vtSOrYVVLCQDtrtiOIhQkIKbv8KsIxaoBQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fT0CFPKkUUW6pKfKmtHJnB9WGLPHBdKkZ+E714o6L2X/ph5i4T4HsnqQvj9P9sDLM
         T5LUvqgvt8Q4ZC5SvB2XIO+k9puZkkZuC1Loch9WO58W85zjsBRFh0FswHlNV/NVLj
         LV6VLnyULQUdz0KKpbM0wfFfhAckwR9/gNPkrEAVo0xmwUrQU4G+my7TJkGuYQ2grq
         GgCfly7MFuUFtCz6CSYW7fPSso+hsU/yfQ6JxfGzVqozeTUYnXCok/z8cLC/gQvQrJ
         5JUQEkrn9tZdl04cC7QbVq/rx8S8TuW89B/LRK9cvH7c4o+Tcfbh9vMxuInd+Lmi0w
         uusuhmNyo4oRg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2E81760A89;
        Tue, 28 Sep 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: udp: annotate data race around udp_sk(sk)->corkflag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283220818.6805.1759743596342099535.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 12:30:08 +0000
References: <20210928002924.629469-1-eric.dumazet@gmail.com>
In-Reply-To: <20210928002924.629469-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 27 Sep 2021 17:29:24 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> up->corkflag field can be read or written without any lock.
> Annotate accesses to avoid possible syzbot/KCSAN reports.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net] net: udp: annotate data race around udp_sk(sk)->corkflag
    https://git.kernel.org/netdev/net/c/a9f5970767d1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


