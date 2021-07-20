Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDB83CF7EC
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 12:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbhGTJwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 05:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237569AbhGTJt0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 05:49:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 97C1761107;
        Tue, 20 Jul 2021 10:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626777004;
        bh=FloHqqycp0A7+niPuxIPpQDSnvqm94Iao33Xdp0nDKc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qheZQZPmxvfVVPjzjclsSBDxXoCXlW7AF1BS5TpFEEH340wos5mdPozI5dRiPsTVh
         tC1lfe7ElmGw6odnQdPDopK6Y0hy/K0uXyud5Z71GOLAAdjxvKJ+FXLwArW4SbRpem
         4RumYA8bl+U1rjJuRMllE1YaN58x2/Sa27BYpT6GZfy0jLOxtn6mTqJW6K9hU4RraG
         zjNHPoCTsojG88FvSP2CXlenbPMZrgVRgXsNBHy0PPwisBExxAnSe2PdZQeZmnrQNf
         vNcF9mPRQ003S2anvj/aOPN5+FJ/yWQ2p3EDEnc3mXNce84KuZQf5t6Ci+zYlEBy9I
         0R9+gEIoafHtQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8CC5E60A5C;
        Tue, 20 Jul 2021 10:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/tcp_fastopen: remove obsolete extern
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162677700457.29107.2709194564760182905.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 10:30:04 +0000
References: <20210719092028.3016745-1-eric.dumazet@gmail.com>
In-Reply-To: <20210719092028.3016745-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, yanhaishuang@cmss.chinamobile.com,
        weiwan@google.com, ycheng@google.com, ncardwell@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 19 Jul 2021 02:20:28 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> After cited commit, sysctl_tcp_fastopen_blackhole_timeout is no longer
> a global variable.
> 
> Fixes: 3733be14a32b ("ipv4: Namespaceify tcp_fastopen_blackhole_timeout knob")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
> Cc: Wei Wang <weiwan@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> 
> [...]

Here is the summary with links:
  - [net] net/tcp_fastopen: remove obsolete extern
    https://git.kernel.org/netdev/net/c/749468760b95

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


