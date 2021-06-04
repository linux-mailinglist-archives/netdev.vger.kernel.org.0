Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC1639C312
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 00:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhFDWBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 18:01:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229668AbhFDWBu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 18:01:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BB9B061404;
        Fri,  4 Jun 2021 22:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622844003;
        bh=SFFqPJcgVlA4vsF9pOLrJMuNb8C+P28BarhiInV/NyY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z8oEb+9nmy4+A8/JNWh23RrTIQ1NTGhdU5UjFQde6tAJUao83FJigWIZG2LVsjayw
         sXrmsEnmy+f+6R77R/oH3Kg2rcQlOLU4dWOP4rVv8FpRINe8m1dfPh0URd9mwM42CY
         mDgapQG9XDUGvG6sc3P5YzEZt9fOQcwGFTCYxiBT/N65WvhAz6TfBWNo2Xt7a/PMFp
         OiI8ZMSvfEZ5yG0fFtenW0aWyt6EnLnzfTubJ8636Aryh3yNVX2xb00Df/60SQLQX9
         8lfhIAScdryr3hHFcE9zCOmB2x62/NdDOZNrTz7M/ZY52tihYAA32IDXUv5oHGT7YP
         e4sdrSW0ngzbA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AF31E60BFB;
        Fri,  4 Jun 2021 22:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: xrs700x: allow HSR/PRP supervision dupes
 for node_table
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162284400371.9401.10316874311102871483.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Jun 2021 22:00:03 +0000
References: <20210604162922.76954-1-george.mccollister@gmail.com>
In-Reply-To: <20210604162922.76954-1-george.mccollister@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  4 Jun 2021 11:29:22 -0500 you wrote:
> Add an inbound policy filter which matches the HSR/PRP supervision
> MAC range and forwards to the CPU port without discarding duplicates.
> This is required to correctly populate time_in[A] and time_in[B] in the
> HSR/PRP node_table. Leave the policy disabled by default and
> enable/disable it when joining/leaving hsr.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: xrs700x: allow HSR/PRP supervision dupes for node_table
    https://git.kernel.org/netdev/net-next/c/1a42624aecba

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


