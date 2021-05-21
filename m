Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8294838D094
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 00:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhEUWLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 18:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhEUWLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 18:11:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A2DD060FE6;
        Fri, 21 May 2021 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621635009;
        bh=0uVcNxOzwjj6HgFGhdzBsNKWDRSYPj4Wl754blSaKs4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LMePJvgsueutj6hpfcEgEtv/FY2zejlIuQs/8iLqInoiRqQ7V+m2vWw4OVUF1poFe
         +tFlJhskjDV4Gq6lftNJvCI+6R4FOfPmjy4nhiG5VLiPzADifw6hG3TxMN7KNUW4dU
         bT8V1/H7RZDzB/EZyHLxc62KwKtipYaqtGUjiRbPWxE895PBvd1NWGhI586kt+XvkY
         2R4ejbFiyh3KgIQpPkLa4JS6Q/PQ+dHh2Mh8v2ynm75pbJReKAG8CH1ZTHLPrXkSA3
         WspckFPhGk0mp7YaoLPKKNRcgnVEwOihNpoWIt0cjLdg93SOxtVijZNfylLJRGiYko
         pNZ8b1SSk804g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9692260A56;
        Fri, 21 May 2021 22:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: record frag_max_size in atomic fragments in input
 path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162163500961.23315.17400956009063652295.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 22:10:09 +0000
References: <20210521202115.218095EC05F0@us226.sjc.aristanetworks.com>
In-Reply-To: <20210521202115.218095EC05F0@us226.sjc.aristanetworks.com>
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edumazet@google.com, willemb@google.com,
        kuba@kernel.org, dsahern@kernel.org, yoshfuji@linux-ipv6.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 21 May 2021 13:21:14 -0700 you wrote:
> Commit dbd1759e6a9c ("ipv6: on reassembly, record frag_max_size")
> filled the frag_max_size field in IP6CB in the input path.
> The field should also be filled in case of atomic fragments.
> 
> Fixes: dbd1759e6a9c ('ipv6: on reassembly, record frag_max_size')
> Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
> 
> [...]

Here is the summary with links:
  - ipv6: record frag_max_size in atomic fragments in input path
    https://git.kernel.org/netdev/net/c/e29f011e8fc0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


