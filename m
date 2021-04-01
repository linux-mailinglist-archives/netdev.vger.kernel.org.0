Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EAB350B65
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 02:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbhDAAu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 20:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232884AbhDAAuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 20:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 949BB61056;
        Thu,  1 Apr 2021 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617238207;
        bh=XPF4Q0/UPk92f59QRnwx26hlEZhsY0om0aOe7itde7I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rWqJ0hKcC8iDGEDG1RUsgyTZeilqU8Lg2ECYtRJ2ssC7z765UK++I2vo6/7IDfQp/
         VHqAuJRtMAmtPvTUEQEcmZHaEkYpzV1tQUmifekctvOw68JsvQV0ipjCTqW61ap8u3
         TzE0llbS2p+wGgX/rO7H1wELdus7q68QFQ1c+g12bgxpclKs+gx4NnKQc3w6VFt8sy
         IwoU5z2xw8ypIRURhNU7CDZOIcjpiP9D/zvrVPP0c20+nKorVCksNP634T/oiL7X6B
         zJ5dSzVmjQZyXGHrW4AbyDLFnkx1W2IcpOMq2N7V24sqW2T/HIdhASrTNz8nfMUPX2
         t4mceqHrYDP0A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 892CE608FD;
        Thu,  1 Apr 2021 00:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests/net: so_txtime multi-host support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161723820755.26411.3929314544690696185.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 00:50:07 +0000
References: <20210401004020.3523920-1-cmllamas@google.com>
In-Reply-To: <20210401004020.3523920-1-cmllamas@google.com>
To:     Carlos Llamas <cmllamas@google.com>
Cc:     willemb@google.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  1 Apr 2021 00:40:20 +0000 you wrote:
> SO_TXTIME hardware offload requires testing across devices, either
> between machines or separate network namespaces.
> 
> Split up SO_TXTIME test into tx and rx modes, so traffic can be
> sent from one process to another. Create a veth-pair on different
> namespaces and bind each process to an end point via [-S]ource and
> [-D]estination parameters. Optional start [-t]ime parameter can be
> passed to synchronize the test across the hosts (with synchorinzed
> clocks).
> 
> [...]

Here is the summary with links:
  - [net-next] selftests/net: so_txtime multi-host support
    https://git.kernel.org/netdev/net-next/c/040806343bb4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


