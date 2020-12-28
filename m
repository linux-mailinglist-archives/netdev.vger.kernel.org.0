Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CC42E6C16
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730330AbgL1Wzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:53734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729598AbgL1WAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 17:00:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 326E422262;
        Mon, 28 Dec 2020 22:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609192807;
        bh=GgNzki+pMhNheQr0R28svwo4eHJSQiRe5oYqUdEZVLQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iJ/iXV2q8IlXsT8FoqQ76gQsagHB9hPihFn+HJlUnMXEm1pDzoqlNab8EyOp280xc
         78vCGV1/mkJj8WYmEgfdrbQB+5sJb+R6KBEeoe2DRNVeC7kqIZ3Ug7ajvJ2uf9w/LP
         ahf7S+nszlD9EPkNC3ccPVBiCzxrm9atP/otcpbr1Lt60pnKYmbdw8mFOxPLj+p3ie
         sfa6sPdjA9QKpDYIz/tBvdr7mf0dLeClj3hPGSWkzBMV0RgNb0IVVbOJPH11c5lpDL
         FwCVo81zLvt5FvjY8XFXxlgV0ccm49Xn37997VXz5lenrGx45aVjEh+SwHFslBWeGT
         XIEsHMp3jWF5w==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 237DD600D9;
        Mon, 28 Dec 2020 22:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mptcp: cap forward allocation to 1M
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160919280713.22170.4812500231632961551.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Dec 2020 22:00:07 +0000
References: <3334d00d8b2faecafdfab9aa593efcbf61442756.1608584474.git.dcaratti@redhat.com>
In-Reply-To: <3334d00d8b2faecafdfab9aa593efcbf61442756.1608584474.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     mathew.j.martineau@linux.intel.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.01.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 21 Dec 2020 22:07:25 +0100 you wrote:
> the following syzkaller reproducer:
> 
>  r0 = socket$inet_mptcp(0x2, 0x1, 0x106)
>  bind$inet(r0, &(0x7f0000000080)={0x2, 0x4e24, @multicast2}, 0x10)
>  connect$inet(r0, &(0x7f0000000480)={0x2, 0x4e24, @local}, 0x10)
>  sendto$inet(r0, &(0x7f0000000100)="f6", 0xffffffe7, 0xc000, 0x0, 0x0)
> 
> [...]

Here is the summary with links:
  - [net] net: mptcp: cap forward allocation to 1M
    https://git.kernel.org/netdev/net/c/e7579d5d5b32

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


