Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC7A32C9C8
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 02:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244557AbhCDBMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 20:12:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:39974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240479AbhCDBAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 20:00:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6781064F25;
        Thu,  4 Mar 2021 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614819613;
        bh=GnSj60mFLmIJfDsTMcfwvqQgyk8jK+GXWDP9ZhGd80E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=flyc7vMNUYK5NRRT2sDvDWXw6oYspzTlZPCxwPHhjBrj4dyU8A90sv/9sGrW/L76/
         cE4q7LL0JFpXVuSFcQHGr28QvXTCiLFoCHT8HfOG9JJfohRRVwoIjxYn7o8fZiAdvP
         LZDn6klAT8gYo/qGfZC2ci7N+O9c9FNMzeqq7lYS9CHbWLWxAzkCwWsJ1PCtMXPpJs
         CCvOUf01/RVwRPjEdK+BlTk7ZS4WNO8GzOgBNsGeguS+9ds6G9ser+5VK9R5IvSOXk
         HZZqcmQeQx6PX6nJxrrfye8TxKAt87RZuvfapW2W5PHcy3V2W8EAgB9rVciBSW9WEy
         CrVmcg/RQdJXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5CD29609E7;
        Thu,  4 Mar 2021 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] net: macb: Add default usrio config to default gem config
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161481961337.28060.7556775091575181826.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Mar 2021 01:00:13 +0000
References: <20210303195549.1823841-1-atish.patra@wdc.com>
In-Reply-To: <20210303195549.1823841-1-atish.patra@wdc.com>
To:     Atish Patra <atish.patra@wdc.com>
Cc:     netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  3 Mar 2021 11:55:49 -0800 you wrote:
> There is no usrio config defined for default gem config leading to
> a kernel panic devices that don't define a data. This issue can be
> reprdouced with microchip polar fire soc where compatible string
> is defined as "cdns,macb".
> 
> Fixes: edac63861db7 ("add userio bits as platform configuration")
> 
> [...]

Here is the summary with links:
  - [v4] net: macb: Add default usrio config to default gem config
    https://git.kernel.org/netdev/net/c/b12422362ce9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


