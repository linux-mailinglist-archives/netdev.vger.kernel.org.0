Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD613ED1FB
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbhHPKap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:30:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231355AbhHPKah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:30:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 226F661BC2;
        Mon, 16 Aug 2021 10:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629109806;
        bh=2+xXMWL9GEx5kMsUH7Ortor+q2QWAlQ9C4AJZ41OTnI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BbhIZSiPE8R6j2W/Pu/tvZ4u/HwkcuJFXPLzaxIuhcXa+v6nZACcBayaP4amx6eKw
         /+K+yRyWpwvbn7hzZwSoSQ9xtasBiDk5Lt1jamWFIBBo5uB5zsw5ylvlu//zUolZvk
         ooFKSrMpEkC3F+7Cjq5mPZ6qQqcVNe4CysBmAPiFhib0nWvQil5fW4n1k7mUBJoZcX
         GguGlOREekkPn9haFEph53zZGhhNadBKqOSqCW7nqnQuGJNT79cUlhqjGkizkHIX+g
         3tZ/UZrq86TSnleHjjR8jdzEXSLFUF1ce7xzwaadJIRxKulIPoQ0Q2disKTuIdKmw4
         xLfTMYnvpmWuA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1770760976;
        Mon, 16 Aug 2021 10:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: call tipc_wait_for_connect only when dlen is not 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162910980609.576.5849241066258212728.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 10:30:06 +0000
References: <7b0de7eba8cf97280106732f84800b55ff359604.1629011616.git.lucien.xin@gmail.com>
In-Reply-To: <7b0de7eba8cf97280106732f84800b55ff359604.1629011616.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tipc-discussion@lists.sourceforge.net, jmaloy@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 15 Aug 2021 03:13:36 -0400 you wrote:
> __tipc_sendmsg() is called to send SYN packet by either tipc_sendmsg()
> or tipc_connect(). The difference is in tipc_connect(), it will call
> tipc_wait_for_connect() after __tipc_sendmsg() to wait until connecting
> is done. So there's no need to wait in __tipc_sendmsg() for this case.
> 
> This patch is to fix it by calling tipc_wait_for_connect() only when dlen
> is not 0 in __tipc_sendmsg(), which means it's called by tipc_connect().
> 
> [...]

Here is the summary with links:
  - [net] tipc: call tipc_wait_for_connect only when dlen is not 0
    https://git.kernel.org/netdev/net/c/7387a72c5f84

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


