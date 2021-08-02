Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBBB3DDABC
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbhHBOU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236819AbhHBOUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8CF3E60FC1;
        Mon,  2 Aug 2021 14:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627914006;
        bh=Ux1wOkkO5tl1aqogtRNYul9ihyMy8hIi2RREzDZCQXg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cVCRVg2SGsRdPh9bfwsXSKFSiiyhW5RU58QvH0lsxRNDbhY+0XmT1kLTcbmFh6hKf
         EeF0pOCiW6Kt42ZL57DCKogfZIOaUsupKIQlM9N7BdEM4cnsc1xszzaowVc51sYUah
         uR2OlLRoOh+tLIzC7iaBmrBGJ9SelDYLxwYffjN0ok1mR8sZSxRDsI+e3hW4mCnQno
         Qb65jv1Q2o/gbuJrXCVLWA/ZyewxrJ3sq6uVW5satM7DULqhPUk35DD4RD60rfy79d
         /z4/Siv1LncLqisFgWlYhWnyyWPs6jmyebj0kyl+NYpXntUrbjjdgPNY00ojMBaq2B
         5ZlBLBwfPZJAw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 884CE609D2;
        Mon,  2 Aug 2021 14:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: natsemi: Fix missing pci_disable_device() in probe
 and remove
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162791400655.18419.9265191885576909997.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 14:20:06 +0000
References: <20210731063801.818658-1-wanghai38@huawei.com>
In-Reply-To: <20210731063801.818658-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 31 Jul 2021 14:38:01 +0800 you wrote:
> Replace pci_enable_device() with pcim_enable_device(),
> pci_disable_device() and pci_release_regions() will be
> called in release automatically.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: natsemi: Fix missing pci_disable_device() in probe and remove
    https://git.kernel.org/netdev/net/c/7fe74dfd41c4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


