Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3195E41750F
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 15:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346804AbhIXNOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 09:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346699AbhIXNMO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 09:12:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 199256125F;
        Fri, 24 Sep 2021 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632489008;
        bh=Rhi59CWRGLeGTesdkrj2YgsVN1gmIfiIHLMWjRKMly8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OMUgMrIpufAqKQg6CQoExhQD5y5S1ng66ymPvcEr0Js/I16ynqdltxUl13FY3AFdn
         U1U3TGnEv6MzeadLjOc9PBLoPDFE7yjvzpsDS8JWmVBj4Wid5kLlaExBw96ScPQQ8G
         azEr2myAewodlcOBqflZVv9LC1kXiy3/g62CEy2GpUCdpz5Qg7p/OtXSeLHlQ5q66O
         tcJGBLZGiTP/+wKwbg2FQfcOawQEiNASCRR7fm17aDmZ5+vvME4hSlqdZx8SplLZdK
         gxo34wM5IeGtbQGG11GRfyIfkfq/np1PzuUKYrR3r9t6VfBm39uyF1/9JvVDCISPPT
         EV+1Z1oMODjNQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1429E60AA4;
        Fri, 24 Sep 2021 13:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: felix: accept "ethernet-ports" OF node
 name
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163248900807.23178.2306275991459954572.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Sep 2021 13:10:08 +0000
References: <20210923153541.2953384-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210923153541.2953384-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 23 Sep 2021 18:35:41 +0300 you wrote:
> Since both forms are accepted, let's search for both when we
> pre-validate the PHY modes.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/ocelot/felix.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: dsa: felix: accept "ethernet-ports" OF node name
    https://git.kernel.org/netdev/net-next/c/abecbfcdb935

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


