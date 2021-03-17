Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62E433FA89
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 22:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCQVkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 17:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231156AbhCQVkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 17:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9C40664F2A;
        Wed, 17 Mar 2021 21:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616017207;
        bh=MykEbFec6VqdlLDN008GkifuEp5MxXO1ImpcmPxvoyY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HbA2aH+OG7P30ugRkYaj1RsD+LN2bk1vQ6yO4mdpfr0kSM4nLFE0J8+hVZV9Yi2Ts
         yFjYeZ9QgOsXwB8fufp0KdKpL+xxV/axUvh/IYRf/rIhBg/U6pgKG6H1yMNqviD9W/
         T7bX1LMssqWQw1N01tvXLOImlkG9a9ilMUyD5BaZ85zum+ZLTsapInHzaz/AP6kNF9
         cg7eB9Y/ts/UBXHtczF4qxFzsF+OfJhaaqz1ZgecPdYF8EfR2k9ncNB6ErCkw+VZQ7
         yv0TdqM4SKEIzqm1iSvMcyeBK4Dwlj4wftbtPjSlBrAG8pejkg8WayAJWnV/MQd8MI
         9+MkcyvEocIKw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 925F760A60;
        Wed, 17 Mar 2021 21:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/1] net: stmmac: add per-q coalesce support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161601720759.5355.17806697288501319323.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 21:40:07 +0000
References: <20210317010123.6304-1-boon.leong.ong@intel.com>
In-Reply-To: <20210317010123.6304-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Mar 2021 09:01:22 +0800 you wrote:
> Hi,
> 
> This patch adds per-queue RX & TX coalesce control so that user can
> adjust the RX & TX interrupt moderation per queue. This is beneficial for
> mixed criticality control (according to VLAN priority) by user application.
> 
> The v2 patch has been tested (with added negative tests) and results from the
> output of the ethtool looks correct.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/1] net: stmmac: add per-queue TX & RX coalesce ethtool support
    https://git.kernel.org/netdev/net-next/c/db2f2842e6f5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


