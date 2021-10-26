Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A53743BE06
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 01:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236324AbhJZXmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 19:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236229AbhJZXmc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 19:42:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 36BF260F39;
        Tue, 26 Oct 2021 23:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635291608;
        bh=yNx7XfdlfJ7oRYWfbXrrm1jXcenexmo+jtcLE1mVGk8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c2uKiOSr4KSgIC8aBsnpBrphmZLHyUbAEdmoWrWcFoCeqLr1AEif6exH3ci2y34Qq
         H2y3TY8utVxL9LhN8x+QNg+eHiykzHSSfWTSmzWtdqnB/79qSBkwavd4iOtfhCNBPZ
         OSmFcrsGXGPijXsKlJ645L69mTYrjEzQVXBpZE9KqxGzCi4dxViiggmw1kF2CuE1N7
         MbYhsv1SB53r3jDHUblpg+pvcHvtcVUAJTVKmkXztpXHN2E7uaNuDQyNIcGOyqe0I2
         M95VG8BbfDT6lZoAzisBT4WwIPtH2IdJzzdJUFVxDUpDT00xNTKl1m9T1SUGEp3ScK
         eos2goXGLKU8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 25395609CC;
        Tue, 26 Oct 2021 23:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2021-10-26
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163529160814.22474.8187180917461728878.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 23:40:08 +0000
References: <20211026201920.11296-1-daniel@iogearbox.net>
In-Reply-To: <20211026201920.11296-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Oct 2021 22:19:20 +0200 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 12 non-merge commits during the last 7 day(s) which contain
> a total of 23 files changed, 118 insertions(+), 98 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2021-10-26
    https://git.kernel.org/netdev/net/c/440ffcdd9db4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


