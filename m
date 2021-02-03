Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA9830D1FC
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 04:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhBCDKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 22:10:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232274AbhBCDKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 22:10:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2A73864F7C;
        Wed,  3 Feb 2021 03:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612321812;
        bh=qZPpFZc3WzJer8f8TuEQuvjG19UNDwQBG1nFF+2EB2g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rofnNuavmv8cEbyzXBnTjYKsjI4Oc9/5EK/TBFBZGiiwsNP+M3VfG6Wda7dK/FopR
         0mVnkQw1h6v0qpmqTk+PvnZHyIBmPJ4GJAgHMSzxHfwb5chWef9vMC0Lbl39V1HfuS
         tiTWZu6Ylg3jndhdX3p+YvkD3amOEzFqIexDeBJetICRnEaov8w+Pb7Kop7B7BVJG+
         Yhuh4MuEz6f9QCbGVRP+N3D6yYMyJUkEYbVCpzHPpQq0JBAHPK8/2dKKbU83XlzR4J
         x0eKZNSZhIu/toOuZiAMBeKxNXavlMH394e10bt/8jbkRMm+pgQRJV+EWTvjSt86hO
         q5KLW+L/4wMmQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 24078609EB;
        Wed,  3 Feb 2021 03:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] inet: do not export inet_gro_{receive|complete}
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161232181214.32173.7513983064557485164.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Feb 2021 03:10:12 +0000
References: <20210202154145.1568451-1-eric.dumazet@gmail.com>
In-Reply-To: <20210202154145.1568451-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, leonro@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  2 Feb 2021 07:41:45 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> inet_gro_receive() and inet_gro_complete() are part
> of GRO engine which can not be modular.
> 
> Similarly, inet_gso_segment() does not need to be exported,
> being part of GSO stack.
> 
> [...]

Here is the summary with links:
  - [net-next] inet: do not export inet_gro_{receive|complete}
    https://git.kernel.org/netdev/net-next/c/fca23f37f3a7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


