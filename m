Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1346044B994
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 01:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhKJAW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 19:22:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230101AbhKJAWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 19:22:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BC160611F2;
        Wed, 10 Nov 2021 00:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636503607;
        bh=VhP0RP2KMOKL6LOVB9R7rLDtAJpB4BY/2Qlr4DHR1/U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rVRQRS//cYZujcMiOVJ+eU8nC8TCXfjcJQw3ft40iThdUSPE5RuILcR0QvxvMm3yz
         m3PCrg1Kxf6E4tU4ZQboZp8Ak8SG/jV6OqlkvNsRe+N24BF0yngWrww6iGwkX7UpM6
         ioWdaAd8Cv7nxrBL5Pynslh4eq1C7WiYTG1IK2aDKR1wzZK/YnFAf/xI6CLd6phbKA
         xjaslV+7T6Ke2SUYi4Z6vZY5xDHwTTmRvgr0onLTSGYak+e/B6QLu0HVpKlFLSPHOj
         4lZpa10g/EAYsHtX3YH2O4j67RPJYggbZXnIqM4Lg8YGaJycU6OL86kFKMwacaUX7k
         d/Wzz41tzTj9Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AEF8460AA3;
        Wed, 10 Nov 2021 00:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2021-11-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163650360771.25764.3222582613298225886.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Nov 2021 00:20:07 +0000
References: <20211109215702.38350-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20211109215702.38350-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, kuba@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  9 Nov 2021 13:57:02 -0800 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 7 non-merge commits during the last 3 day(s) which contain
> a total of 10 files changed, 174 insertions(+), 48 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2021-11-09
    https://git.kernel.org/netdev/net/c/fceb07950a7a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


