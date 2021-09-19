Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB4A410B8F
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 14:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhISMbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 08:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhISMbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 08:31:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 939C361074;
        Sun, 19 Sep 2021 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632054607;
        bh=bF+poJd5oVaA7RQlt6iltync30X7umtJ9CH0d0kGt2s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LNNi+4b3XIFoDhr6zKmM4WGSDr2NU1p5biZsN0nqyzPY/KDHFWPQegv6L1rtQL5F8
         awnHpuw62F2wDlzCntuHFJIKUzd1a6CWYPdAmDDkcjw/PS1hl//odQu7/cwYjzC7xt
         DmZpThLXIzrST8aWxhfl+RHL9xblaH7ZxaJ8lh8QRNxzjuI2R/Dc8c3KLOjNJDhzZT
         qesUluxiSIi7ADGhGidPb4ArwewkIphwGpAaP6Ds/iw2FdtJmVVdBfaY8maa7KPbbR
         a/OiQESR0GVa+vNgYqpYXwoRoc94430wMIT9LwnQzsNVCdeiftEgFSyqGF6kBS68mU
         CwRB0qOkEvJnA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 80BCE60A3A;
        Sun, 19 Sep 2021 12:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx4_en: Resolve bad operstate value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205460752.12471.5790209097160061994.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 12:30:07 +0000
References: <20210919115545.28530-1-tariqt@nvidia.com>
In-Reply-To: <20210919115545.28530-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        saeedm@nvidia.com, moshe@nvidia.com, lkayal@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 19 Sep 2021 14:55:45 +0300 you wrote:
> From: Lama Kayal <lkayal@nvidia.com>
> 
> Any link state change that's done prior to net device registration
> isn't reflected on the state, thus the operational state is left
> obsolete, with 'UNKNOWN' status.
> 
> To resolve the issue, query link state from FW upon open operations
> to ensure operational state is updated.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx4_en: Resolve bad operstate value
    https://git.kernel.org/netdev/net/c/72a3c58d18fd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


