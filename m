Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C6C436531
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 17:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhJUPMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 11:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231586AbhJUPMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 11:12:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E52FF61221;
        Thu, 21 Oct 2021 15:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634829007;
        bh=zZBKXxF8VUOttCw6IoQPOgtnEa/JdqVYQaOP22/2WhA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ofHzul/cj3mQnZ2sTuTE+BS90jwUd3Jan+LeA7c8ejlvS4PzmXZ3/Op1ZqLk6Chef
         xYDLXckpkBwrNuQVBiST+v2UZbMVMF3sCmAB7vFHwFqdPUKPpIaRu9GGs625hbI3Yx
         R74V8cZZEObXuDshSj8uZcQuw+6iZTuhbmRaCVy2DNs1YiLBMODCx17p9ygVuu3CV3
         VegdFOxdNfyjlxSt/ASBaN5NO76EB+QebCbFBdWnRhWWiDNlilleFaPo96F11UOES1
         /i9y/y5l/+OxSogeVA+sPNC3+6IMf4mAm2Uwe5bnBQaL6KcVOb5ZyvpNr00+oFPiBY
         PWZKbk5Xz6awA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DB88260A22;
        Thu, 21 Oct 2021 15:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: enetc: fix ethtool counter name for PM0_TERR
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163482900789.14016.8385196930971167918.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Oct 2021 15:10:07 +0000
References: <20211020165206.1069889-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211020165206.1069889-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        claudiu.manoil@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 20 Oct 2021 19:52:06 +0300 you wrote:
> There are two counters named "MAC tx frames", one of them is actually
> incorrect. The correct name for that counter should be "MAC tx error
> frames", which is symmetric to the existing "MAC rx error frames".
> 
> Fixes: 16eb4c85c964 ("enetc: Add ethtool statistics")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net] net: enetc: fix ethtool counter name for PM0_TERR
    https://git.kernel.org/netdev/net/c/fb8dc5fc8cbd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


