Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B107445323E
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 13:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbhKPMdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 07:33:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235801AbhKPMdF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 07:33:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9283F61AD2;
        Tue, 16 Nov 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637065808;
        bh=4xzeFJCMDJcYztRfXVC+Cr8EC6x2im98sbOS9XDsTBg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dbmQQQa7LYrA/Dfpvq+tmAyVfpZdoGJp/OIlKZUj7V+5wfH7zM/DlsXRfbl8axTgI
         TUUKkarVUPlNRHrhqp4lORPSyBAUfuMjj5a1fcUOLtfVxunzzHr4Ub2RWhudIV8xsd
         hmlTpV/A5nE6Zvxsk18kKr7IxsB18t2eQrU02PPLdgAW4pSPl2IXsJC1XmhQbZRMBW
         atTYE4AT5SC+rm4KjdbPnlOcR3vQVt0zEYwVBmk4CQzOPUMNJJ/4MqS3PHwdYst+wX
         8hYJhoUldfPRz9DiYcOp/OXULk/zyBqDG+nwK66TOAUsMf2jnjV/cUEmWds5ODaD5Z
         HiDGBB1D5/FUg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 88C4160A0C;
        Tue, 16 Nov 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH bpf] udp: validate checksum in udp_read_sock()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163706580855.29093.3984047233836515742.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Nov 2021 12:30:08 +0000
References: <20211115044006.26068-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20211115044006.26068-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        cong.wang@bytedance.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, lmb@cloudflare.com, jakub@cloudflare.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Sun, 14 Nov 2021 20:40:06 -0800 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> It turns out the skb's in sock receive queue could have
> bad checksums, as both ->poll() and ->recvmsg() validate
> checksums. We have to do the same for ->read_sock() path
> too before they are redirected in sockmap.
> 
> [...]

Here is the summary with links:
  - [RESEND,bpf] udp: validate checksum in udp_read_sock()
    https://git.kernel.org/bpf/bpf/c/099f896f498a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


