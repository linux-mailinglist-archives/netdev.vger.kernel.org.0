Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D5A3AD2D3
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbhFRTcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233303AbhFRTcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E7C61613BD;
        Fri, 18 Jun 2021 19:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624044604;
        bh=jlL285nD40pwVx+4IEjWkPeJ3Yt4IQB4/F570aDFsEs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m9qC886PPVc7kHgS87Xx3K1GtNzxROwBOuRDHWR9RqgScg3WosqG5M+lc9/IL24xg
         vOEYixUoiWmaFEwQVkEmAsXUmWNkJaX1yagzaXANnM3d56qQMsrK6Enp9GE77K4wTo
         OZ1p3yboIcEGAKcEV0Ylh94CPHScBErVlJVbb1X9FL417hdZDQUjepI11QJwwCDBj3
         WDpfk7mPqcsFwZzCgP3vtdmwUy3qeEgJngrccXiL1CZDGzkdcxEBRKvsrn0yhlGnXi
         6HUrMRWMRzGvBgMFEHize6a2TgXQUZmE2hcRGjPfnUt8JUguVxJiQ0OYDvI9WuSpJ0
         UBS/Nh1dq8/QQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E21E3609D8;
        Fri, 18 Jun 2021 19:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: hns3: fix reuse conflict of the rx page
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404460492.16989.9581963902769754045.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:30:04 +0000
References: <1624018185-38469-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1624018185-38469-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, salil.mehta@huawei.com,
        lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 20:09:45 +0800 you wrote:
> From: Yunsheng Lin <linyunsheng@huawei.com>
> 
> In the current rx page reuse handling process, the rx page buffer may
> have conflict between driver and stack in high-pressure scenario.
> 
> To fix this problem, we need to check whether the page is only owned
> by driver at the begin and at the end of a page to make sure there is
> no reuse conflict between driver and stack when desc_cb->page_offset
> is rollbacked to zero or increased.
> 
> [...]

Here is the summary with links:
  - [net-next] net: hns3: fix reuse conflict of the rx page
    https://git.kernel.org/netdev/net-next/c/961045004b77

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


