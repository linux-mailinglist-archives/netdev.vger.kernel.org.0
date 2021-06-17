Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416723ABBF2
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 20:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbhFQSmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 14:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232166AbhFQSmN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 14:42:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D2E16613EE;
        Thu, 17 Jun 2021 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623955205;
        bh=8AGY9k3gxRMxuVh8IKgShU1Z62NiqmyNDgO9ar9yh2Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j0ynxlRgYAv7v6m4u9RedQXwTyXzeLfa6P95HLxRYWlKCiwzpCSw8yz5DcI7eSsZV
         pzwT2O91Z94+AbQexwGXhzMCEsl+FFfq9v4FhXedaffXX9xRzMC/REEXLZP37wW8l/
         PhuUVchhYwU5Iidt2vr4JOi/n/WJrCpwWbf+6nc1hhxrmrwsJtMftUTrIfhyLPMPw7
         d/ybkh3z70DjEdIapZ289//QTr4MKJAQLHdD25T4s3tggYaJiJ3EO/BdNUNAvftEas
         Z/P9uIDtykhNTiMjJTtJYyEdJzGijKElFkeUBXSouWvx4iC4PtBnPIvjF2u0uOX9u/
         qGoXMwRIQNUuw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CD8B160A6C;
        Thu, 17 Jun 2021 18:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fix mistake path for netdev_features_strings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162395520583.2276.12788603251816919204.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Jun 2021 18:40:05 +0000
References: <1623901031-9920-1-git-send-email-shenjian15@huawei.com>
In-Reply-To: <1623901031-9920-1-git-send-email-shenjian15@huawei.com>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linuxarm@openeuler.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 17 Jun 2021 11:37:11 +0800 you wrote:
> Th_strings arrays netdev_features_strings, tunable_strings, and
> phy_tunable_strings has been moved to file net/ethtool/common.c.
> So fixes the comment.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> ---
>  include/linux/netdev_features.h | 2 +-
>  include/uapi/linux/ethtool.h    | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: fix mistake path for netdev_features_strings
    https://git.kernel.org/netdev/net-next/c/2d8ea148e553

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


