Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C8143E556
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhJ1Pmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:42:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230126AbhJ1Pmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 11:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 742F4610CF;
        Thu, 28 Oct 2021 15:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635435608;
        bh=Lo44b0rW1gj+oT6zZVf+WbryFgBd3jrRmWGI9w20vk0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K049cS+VwMaRRMWqyo6i8Wiq705B3V8UFh5iNW/LziHsxZIF1Y0SVddUY2ExcpqAJ
         E5qe4sq4dgIXZ72XbiiEpFvcb4aHV0gqRUs3jplvi+n5u2OzTiBwr812szl4cmmMk3
         M73be33VkCclyaeUmtzJp1JE+UA5LeeOQ7tXx1y/jzXQNINStaIvjsU8f0CHsjG76B
         YK1A1brdbRUpkDRvge3k89kDnOli6gK18nbRqOm+GV6W91G3tS+NeAvz9c/vTGLj6G
         7+cOZEIbK8lK8WMsGGKmsrTODxgUuvj7wyXA7QudMckyL9rMzq4N5MUMGdjOcseN2N
         GuXJRPjeJZGKw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 61F4260A1B;
        Thu, 28 Oct 2021 15:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "net: hns3: fix pause config problem after autoneg
 disabled"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163543560839.29178.11743093544263683251.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 15:40:08 +0000
References: <20211028140624.53149-1-huangguangbin2@huawei.com>
In-Reply-To: <20211028140624.53149-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangjie125@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Oct 2021 22:06:24 +0800 you wrote:
> This reverts commit 3bda2e5df476417b6d08967e2d84234a59d57b1c.
> 
> According to discussion with Andrew as follow:
> https://lore.kernel.org/netdev/09eda9fe-196b-006b-6f01-f54e75715961@huawei.com/
> 
> HNS3 driver needs to separate pause autoneg from general autoneg, so revert
> this incorrect patch.
> 
> [...]

Here is the summary with links:
  - [net] Revert "net: hns3: fix pause config problem after autoneg disabled"
    https://git.kernel.org/netdev/net/c/35392da51b1a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


