Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB43D415E34
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240925AbhIWMVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240682AbhIWMVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 08:21:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D04DA610A0;
        Thu, 23 Sep 2021 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632399607;
        bh=KKotaIpWbOED8GgpgBlS0nZS0zw3iCeL9P6vHeRlQtA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eWi5Iktegx6o9sC5FJVXZIPvWTYeqpi9UNKULw1mZ2kZJF85NyNqQYo8JaG2jC0Gs
         zTAh+awNJYJs6eYe5OwtpIogSK8b2ak/5FyeXvmZghkGrfjHVuUu6IonoTUTOPcOki
         nZ2LJd9xFykVVVw8WbmuWBokfDq4DQidV3UtJHV0XFeLUdgwxljA4xTLsuYqZhuaqJ
         FEYYGtEGWpdAsYozmnF6DysPdr98M4WLFGj1NmpQkx3CwQq2y6o3G5CSQYq/EX3WZH
         3No2j9MFeAjKIH8ZPnVIhBomHMKQQf7u7wVAMjhLIV7O4uRdr5N0mCiGjbu7QULc6i
         OdSV24dKo5g+Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C2B5B60A3A;
        Thu, 23 Sep 2021 12:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx4_en: Don't allow aRFS for encapsulated packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163239960779.10392.6541307426749738412.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Sep 2021 12:20:07 +0000
References: <20210923065145.27583-1-tariqt@nvidia.com>
In-Reply-To: <20210923065145.27583-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        saeedm@nvidia.com, moshe@nvidia.com, ayal@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 23 Sep 2021 09:51:45 +0300 you wrote:
> From: Aya Levin <ayal@nvidia.com>
> 
> Driver doesn't support aRFS for encapsulated packets, return early error
> in such a case.
> 
> Fixes: 1eb8c695bda9 ("net/mlx4_en: Add accelerated RFS support")
> Signed-off-by: Aya Levin <ayal@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net] net/mlx4_en: Don't allow aRFS for encapsulated packets
    https://git.kernel.org/netdev/net/c/fdbccea419dc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


