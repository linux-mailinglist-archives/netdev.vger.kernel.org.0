Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5721B34507E
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhCVUK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230163AbhCVUKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:10:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6DECD6192E;
        Mon, 22 Mar 2021 20:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616443810;
        bh=0trmCG3jaIfo5XELMD73LjdgDJfcVxs490ETY/MW4ow=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d13LcAE6vMJPnqQZxL7oDPLwUdgZ+U666KBOtLjcV6WUoK4KCOEPPZ2Rlvcth2LcU
         +f526h8Cy2wxeUn9xZ3jOF8fehHpL5zV9lVAC51LhTcmCOt2QhU/OTnleNIC56iZFT
         sNwG00eI5olcgCQfxVEuKv4DIxSm/+49iK3F9Za1VTjWgVGF4tXDl+tlIuqC1K5+EJ
         k61FGNbzJII31hKaN1vgOe8lHxOYBC8S9Ggfsahxf8vv9FwRDgVuMM42mUHSWNmxoD
         Z7dCB393fJhgr2CLF/Tw66eLFBgBQOEsY9LF4h2eKQ4RbA3c2aqCXr0gANbTeNfl8X
         MY8qbpsTS4l1Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5B2D960A6A;
        Mon, 22 Mar 2021 20:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 0/7] net: hns3: refactor and new features for flow
 director
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161644381036.22637.12567078527418286788.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 20:10:10 +0000
References: <1616385122-48198-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1616385122-48198-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 11:51:55 +0800 you wrote:
> This patchset refactor some functions and add some new features for
> flow director.
> 
> patch 1~3: refactor large functions
> patch 4, 7: add traffic class and user-def field support for ethtool
> patch 5: refactor flow director configuration
> patch 6: clean up for hns3_del_all_fd_entries()
> 
> [...]

Here is the summary with links:
  - [V2,net-next,1/7] net: hns3: refactor out hclge_add_fd_entry()
    https://git.kernel.org/netdev/net-next/c/5f2b1238b33c
  - [V2,net-next,2/7] net: hns3: refactor out hclge_fd_get_tuple()
    https://git.kernel.org/netdev/net-next/c/74b755d1dbf1
  - [V2,net-next,3/7] net: hns3: refactor for function hclge_fd_convert_tuple
    https://git.kernel.org/netdev/net-next/c/fb72699dfef8
  - [V2,net-next,4/7] net: hns3: add support for traffic class tuple support for flow director by ethtool
    https://git.kernel.org/netdev/net-next/c/ae4811913f57
  - [V2,net-next,5/7] net: hns3: refactor flow director configuration
    https://git.kernel.org/netdev/net-next/c/fc4243b8de8b
  - [V2,net-next,6/7] net: hns3: refine for hns3_del_all_fd_entries()
    https://git.kernel.org/netdev/net-next/c/f07203b0180f
  - [V2,net-next,7/7] net: hns3: add support for user-def data of flow director
    https://git.kernel.org/netdev/net-next/c/67b0e1428e2f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


