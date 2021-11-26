Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735C345E692
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357741AbhKZDfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 22:35:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358044AbhKZDdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 22:33:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4991A610FE;
        Fri, 26 Nov 2021 03:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637897409;
        bh=YG7PHmdR+Jr89vCp67on9JKJd0pdHAWVw0r43nAEg/4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lTsCowsxVrvw2vp0kepWTo0ePEtOnMzoat+rKW8YQl/1QoFQ1wJzebjeZeS36qOp+
         xvfjPmg70knNo0JhQSfprLcoJLRXIe/Anu5uvH2EodY16zxwh6Hrs0XBvlpqLvKUvB
         Ky/EsNU0NxNgWJlRlbQGJnIoDzYsiYx67va/Wrv63az2oGcgYbo0SQmb7QalbSmYda
         xLEWyVfNWSWZW/sPcPflQqzFDOHhMHT5FK9LTAxrXJDyLl3tWLODA370pzPtYyBPz5
         L4pauFKPNxOs/Q3HVqBLn9FCUXcnCZbV1a6sSF8ZfTjl8JJBl8y/A6qdD1ifrp+CfU
         bBiUAu+K5Kiyw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 386F660A6C;
        Fri, 26 Nov 2021 03:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v2] veth: use ethtool_sprintf instead of snprintf
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163789740922.8117.1922567670532399409.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 03:30:09 +0000
References: <20211125025444.13115-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20211125025444.13115-1-xiangxia.m.yue@gmail.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Nov 2021 10:54:44 +0800 you wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> use ethtools api ethtool_sprintf to instead of snprintf.
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] veth: use ethtool_sprintf instead of snprintf
    https://git.kernel.org/netdev/net-next/c/a0341b73d843

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


