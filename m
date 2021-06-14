Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEEE3A7026
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbhFNUWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233352AbhFNUWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 16:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 481D261246;
        Mon, 14 Jun 2021 20:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623702006;
        bh=l/ile9LpGGslUF1/IXMULKglaz9RzVmifIqK1zP0p0E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dwbS9LtrqgSWl0nMphOEeSNdn4J8hA9fHDzQanfYnBES4icFwc1SooWqxaP2VTr2h
         NzQcSEucfzd/eP+DgVtKpYjoYacZpCburkmNgu20Z+ze8aMzpgV3RzzrfEtfKst+DK
         dmSMX1fPVA1VpL1qT4G3Bg3u4PJHMv/96RJ5mhnK/a8H/p9nWRoZhs/AAQ7E29dD8T
         O87n3vlTZ3DYnmhWfp/P+141wa8DSIfwmvZDMrvufcWiWobpFKmCU66ZxAbP7xawhL
         HRNIKdo2LuOxLU3EeVi7vu6JdjGpBCN35I+tHnfLaaN37UDSepEyh0gLJdLt2N4Tzr
         EZoA/a5v1jbNQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 37AE860972;
        Mon, 14 Jun 2021 20:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: flow_dissector: fix RPS on DSA masters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162370200622.25455.4104278884892114200.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 20:20:06 +0000
References: <20210614135819.504455-1-olteanv@gmail.com>
In-Reply-To: <20210614135819.504455-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 14 Jun 2021 16:58:19 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> After the blamed patch, __skb_flow_dissect() on the DSA master stopped
> adjusting for the length of the DSA headers. This is because it was told
> to adjust only if the needed_headroom is zero, aka if there is no DSA
> header. Of course, the adjustment should be done only if there _is_ a
> DSA header.
> 
> [...]

Here is the summary with links:
  - [net-next] net: flow_dissector: fix RPS on DSA masters
    https://git.kernel.org/netdev/net-next/c/ec13357263fb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


