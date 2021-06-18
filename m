Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F5C3AD2B7
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbhFRTWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235434AbhFRTWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:22:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B2CA2613FA;
        Fri, 18 Jun 2021 19:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624044006;
        bh=Boffnogb8HbtZJOa/QBADPbzDn4obiZkPMFYmvM0RFA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fIkm7Si+ULocwXFaS0XjwMY/crD1AqbS6PtiX2SwYqXRu4uB/DPXtiXPmIkh08KV9
         CtqTf4rbNRH6PlUiUjSsYBxD9i0kM9EqxY/NICELn3lq5x7ai4xFYMkH/5zpC+LfNL
         3lgKlgpp1w2IfRLs0MpIt01cDjMKhwGNBD81hm3BiLp85W4+KpTL9wOBM0k5F79HtV
         C+TXCMkus0qtiu9gvO9PjLHSYJzSBT9qInvamxTrtpka20VNp3+teskH2UaxndcbDb
         Jy5Gcntmb0fIQp6PAxaX5c8H6o7qYg+F9T7+1XnmlDF67wShtaQ5DYVs0c+8XcI3tv
         36/uCWJlCAzYw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A5EF360CDF;
        Fri, 18 Jun 2021 19:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: net: pxa168_eth: Fix a potential data race in pxa168_eth_remove
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404400667.12339.18217501119774620104.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:20:06 +0000
References: <20210618093526.GA20534@duo.ucw.cz>
In-Reply-To: <20210618093526.GA20534@duo.ucw.cz>
To:     Pavel Machek <pavel@denx.de>
Cc:     davem@davemloft.net, kuba@kernel.org, zhangchangzhong@huawei.com,
        andrianov@ispras.ru, michael@walle.cc, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 11:35:26 +0200 you wrote:
> Commit 0571a753cb07 cancelled delayed work too late, keeping small
> race. Cancel work sooner to close it completely.
> 
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> Fixes: 0571a753cb07 ("net: pxa168_eth: Fix a potential data race in pxa168_eth_remove")

Here is the summary with links:
  - net: pxa168_eth: Fix a potential data race in pxa168_eth_remove
    https://git.kernel.org/netdev/net-next/c/bd70957438f0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


