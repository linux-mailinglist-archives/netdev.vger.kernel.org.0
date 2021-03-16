Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BE233E1B4
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhCPWuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231660AbhCPWuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 18:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C171C64F40;
        Tue, 16 Mar 2021 22:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615935008;
        bh=gu+LxsBdKkP6/ZfHZ+ZHtQUH0Vnot+O4LLI/+ib5XxM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j5ms09tI3M1W/GVTWAQIdi8jAPfQqUCcptRGbzyho443qIg4v/ItGAP8zk3cxxMFC
         jO3Y5EDE5ytPiTDsaTeYZL35ZN/5zjZYYC6mwl6e61A+ULLWNpm5jDbORh1jaae5NX
         e+Kk2B/XHImP3EJI7/Im3dMr06qedc9kPiPKjewbsi6lUuc5xbfyWhSZS9tzuSLG1y
         Rb68gROhysJ0ZGAeOztm8BhySDiPerpPrQTrhD+JZkPfMfAVwoU803Y4GfpCTu0Jye
         S1dlGt91s/Ky0KsbEMQd64NGqkCvPGq48oCQMeF8NuXE9FpZzBH+GZeJtk9LZ/NABy
         L6qfhhPiBXVXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AF24060997;
        Tue, 16 Mar 2021 22:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] Fixes for nfp pre_tunnel code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161593500871.15002.14296629686192406959.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 22:50:08 +0000
References: <20210316181310.12199-1-simon.horman@netronome.com>
In-Reply-To: <20210316181310.12199-1-simon.horman@netronome.com>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     davem@davemloft.net, kuba@kernel.org, louis.peens@corigine.com,
        netdev@vger.kernel.org, oss-drivers@netronome.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 16 Mar 2021 19:13:07 +0100 you wrote:
> Louis Peens says:
> 
> The following set of patches fixes up a few bugs in the pre_tun
> decap code paths which has been hiding for a while.
> 
> Louis Peens (3):
>   nfp: flower: fix unsupported pre_tunnel flows
>   nfp: flower: add ipv6 bit to pre_tunnel control message
>   nfp: flower: fix pre_tun mask id allocation
> 
> [...]

Here is the summary with links:
  - [net,1/3] nfp: flower: fix unsupported pre_tunnel flows
    https://git.kernel.org/netdev/net/c/982e5ee23d76
  - [net,2/3] nfp: flower: add ipv6 bit to pre_tunnel control message
    https://git.kernel.org/netdev/net/c/5c4f5e19d6a8
  - [net,3/3] nfp: flower: fix pre_tun mask id allocation
    https://git.kernel.org/netdev/net/c/d8ce0275e45e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


