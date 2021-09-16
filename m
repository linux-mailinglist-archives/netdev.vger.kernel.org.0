Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109C840DA2C
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239884AbhIPMmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239835AbhIPMln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 08:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9625561260;
        Thu, 16 Sep 2021 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631796008;
        bh=nuz36/tY889PWXqfLn/1Ryug5OdOy3qE6tlL9C7PxP4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sfS+j5AXtfyWfjnj3290OyL0gp/pE+31MOhIe23xMQPICwoOzVfXKSYnP8xiRPFV0
         6OA3i3u7KXA7CNX20ZLKilCaW5wH7VtwvoTsEgzQuzH/Zu3L42GT6WLUBx1iW73TvK
         le0B4ujFDE720dP9MygJ1GPAqM3zOirT02kbl6NI7kae5dEqaBjdmeGZwWYOzEuVOa
         muIAyh7PXvz7BE+peXe1BOTJ4veyCTmprfoD38eFrM3dF5S83495t9ephwE+/3qFL7
         3C5z0hNLuWjIw9jNa52c+FAcsL4e0OsGF8EQvYf5b0OcDmbWxTl9d3qIUKF+X08Dj/
         AyqerEWGpLbYg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8D8BC60A22;
        Thu, 16 Sep 2021 12:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: arc_emac: Make use of the helper function
 dev_err_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163179600857.19379.5224983752075834228.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Sep 2021 12:40:08 +0000
References: <20210915145741.7198-1-caihuoqing@baidu.com>
In-Reply-To: <20210915145741.7198-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 15 Sep 2021 22:57:41 +0800 you wrote:
> When possible use dev_err_probe help to properly deal with the
> PROBE_DEFER error, the benefit is that DEFER issue will be logged
> in the devices_deferred debugfs file.
> And using dev_err_probe() can reduce code size, and simplify the code.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> 
> [...]

Here is the summary with links:
  - net: arc_emac: Make use of the helper function dev_err_probe()
    https://git.kernel.org/netdev/net-next/c/95b5fc03c189

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


