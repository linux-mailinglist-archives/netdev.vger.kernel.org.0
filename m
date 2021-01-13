Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96182F430E
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbhAMEUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbhAMEUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 48E0723134;
        Wed, 13 Jan 2021 04:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610511608;
        bh=5KUuhIq3uOqRP7W9A2HCOu6gyEGmBhVNKHwxZAsOoFo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fNjdM0i7al3wjz6ayQAsC7VGR7LqKQ0Iq6NopHQKESyusL2OQ1GJmjsYcoDvs+QV9
         Q7YJvoaq/8HiRwKV1MaT6kloMi4QA0o23zb1CvIeOat2nbj0ACMvKi67R2Xb4xI88G
         vSsFvglq+y1Q6ensu9mBnxqusumTrgHNK5XKgognI2DFsvFksHCXXgWE+xhj732Ndj
         /x3P90vaNCke1g3+13laH7One8Ch5OHbojtJgbi2Pl8hxymlcLXlsXtsth4dVyDwvP
         GA25vaD3T8tDC/Z3BxlxlO4KtflMram6o5LMoKLqZg9UTP3PjVzCADRyMj3Mj6A7V/
         SLYEWuHSsuCSA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 39E2B604FD;
        Wed, 13 Jan 2021 04:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] mptcp: a couple of fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161051160823.32446.9328881553119033183.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jan 2021 04:20:08 +0000
References: <cover.1610471474.git.pabeni@redhat.com>
In-Reply-To: <cover.1610471474.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 12 Jan 2021 18:25:22 +0100 you wrote:
> This series includes two related fixes addressing potential divide by 0
> bugs in the MPTCP datapath.
> 
> Paolo Abeni (2):
>   mptcp: more strict state checking for acks
>   mptcp: better msk-level shutdown.
> 
> [...]

Here is the summary with links:
  - [net,1/2] mptcp: more strict state checking for acks
    https://git.kernel.org/netdev/net/c/20bc80b6f582
  - [net,2/2] mptcp: better msk-level shutdown.
    https://git.kernel.org/netdev/net/c/76e2a55d1625

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


