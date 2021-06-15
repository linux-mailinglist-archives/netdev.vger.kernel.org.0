Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BF23A8871
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhFOSWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231450AbhFOSWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 14:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1B46E613E9;
        Tue, 15 Jun 2021 18:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623781210;
        bh=YqFTQR999wuoyOeVVhR9qefjDWTrJrtx63JzrYBjN1Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dmjut/MLvdKu/V9d1loh3HF0dKBXrifT7g2V/wNaJJJvkyiymRlC6+WunEQhPMUTV
         IRxXkh3EeM2/0VE41k86G3iC3PZ3sRULxN64zfGi4MCkc9G6z8dp3UQ0hn4VHT0MeW
         1dvDeGgUhVvvFcb5BcOY2QpVXgh4akr0i6/VosN/KNVYrwbmrrttm5Iv2vQWcGJnbM
         gUzdpzZETd9C7W8Bn3yp+2nYY3EaJKR1RRH1afLKAh7whgHsDogiMbcO/AOOtL99H2
         VibLCg1yrLNr5TQrMHbR5l4a0RR3HH2bzFASLjgiH9mWgk9WEltYfBYo/Vn+GbfXaY
         F3vNlcxzzMieQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 141C660A0A;
        Tue, 15 Jun 2021 18:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH 0/6] Add ingress ratelimit offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162378121007.26290.15121739739901895294.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Jun 2021 18:20:10 +0000
References: <1623756871-12524-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1623756871-12524-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        sgoutham@marvell.com, hkelam@marvell.com, gakula@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 15 Jun 2021 17:04:26 +0530 you wrote:
> This patchset adds ingress rate limiting hardware
> offload support for CN10K silicons. Police actions
> are added for TC matchall and flower filters.
> CN10K has ingress rate limiting feature where
> a receive queue is mapped to bandwidth profile
> and the profile is configured with rate and burst
> parameters by software. CN10K hardware supports
> three levels of ingress policing or ratelimiting.
> Multiple leaf profiles can  point to a single mid
> level profile and multiple mid level profile can
> point to a single top level one. Only leaf level
> profiles are used for configuring rate limiting.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] octeontx2-af: cn10k: Bandwidth profiles config support
    https://git.kernel.org/netdev/net-next/c/e8e095b3b370
  - [net-next,2/5] octeontx2-af: cn10k: Debugfs support for bandwidth profiles
    https://git.kernel.org/netdev/net-next/c/e7d8971763f3
  - [net-next,3/5] octeontx2-pf: TC_MATCHALL ingress ratelimiting offload
    https://git.kernel.org/netdev/net-next/c/2ca89a2c3752
  - [net-next,4/5] octeontx2-pf: Use NL_SET_ERR_MSG_MOD for TC
    https://git.kernel.org/netdev/net-next/c/5d2fdd86d517
  - [net-next,5/5] octeontx2-pf: Add police action for TC flower
    https://git.kernel.org/netdev/net-next/c/68fbff68dbea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


