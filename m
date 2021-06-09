Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667423A204B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhFIWm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFIWmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:42:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 31E3B6139A;
        Wed,  9 Jun 2021 22:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623278425;
        bh=ueQ8dqoZxOqzgAObx/mbqpSAUqVFJ53xqae5CBvGNpk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rCu9ipTJhSmBkLRU42NQaAK3TU4KNwPXFNgibjXvPYrbDp3w6eVoNyxQ7VfAYRU+v
         j0fHd2QoyRBYDL+zP5ft2JFJobqdeXBrbSMmNxFkRNBmGnYobLkUTkWShryHDba1lm
         A5vPsIeHRYcFzsCQP6iCJO6D+ausRo184in6EqI7c8n5QTE+e0y7AVQKgoKcc/1Kxi
         r/2ytPpyuDE7wMOsDmaD0yiXmCyWW/ZT5vqpdZy6HOb4JMr93aMPmqtjXLrFr4VJAz
         6XQS/emUREe1trpIaN02uOo+rrRfPii7cFgD2Mf07KEm4RMh9y/M01dFoEoR7dCkfc
         wslz557Rhw6+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 297AD60A53;
        Wed,  9 Jun 2021 22:40:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: stmmac: Fix missing { } around two statements in
 an if statement
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327842516.25473.1151254563839233754.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 22:40:25 +0000
References: <20210609170512.297623-1-colin.king@canonical.com>
In-Reply-To: <20210609170512.297623-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk,
        weifeng.voon@intel.com, michael.wei.hong.sit@intel.com,
        vladimir.oltean@nxp.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  9 Jun 2021 18:05:12 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are missing { } around a block of code on an if statement. Fix this
> by adding them in.
> 
> Addresses-Coverity: ("Nesting level does not match indentation")
> Fixes: 46682cb86a37 ("net: stmmac: enable Intel mGbE 2.5Gbps link speed")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - [next] net: stmmac: Fix missing { } around two statements in an if statement
    https://git.kernel.org/netdev/net-next/c/345502af4e42

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


