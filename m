Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B9E479AC6
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 13:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbhLRMkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 07:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbhLRMkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 07:40:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C90C061574;
        Sat, 18 Dec 2021 04:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2ED560B6B;
        Sat, 18 Dec 2021 12:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39162C36AE5;
        Sat, 18 Dec 2021 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639831210;
        bh=8/JS9y+A7wxS2a8KpfXASGbE9esIzdcrj13WlXCo4K8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e3ULAXDzVNIktlAUZzgsaCuPY5wWmHg9QJjilnvIfHNUtWxNOOIWxtyKICGag9bTE
         tSnczPP58K2EDU04NUg5QrKfoe7rGPjuhIOhSiUy+q44RbYVDXcpEJ2MR5adthOljL
         qL7qLxzdkgApCQYL0VPcmf7x7cpq/JJBABkiuAO6Es1jDtpVIsTqKiPbqi+D+TyoZa
         g+mlr71bD/WQZA3DiBDfSSVa8dONTZb1YcNaCe9+ZM7x7NrDdbLhSzEAZkdxJAqRoe
         +vj7cOi4A9uJPxSqIixKRqaCXxmYwx+FNydBBN16UVaRjLzcSOFJfxEOw/MPTXoX/k
         vVl8tDO5V7yEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 21C0B60A4F;
        Sat, 18 Dec 2021 12:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qlcnic: potential dereference null pointer of
 rx_queue->page_ring
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163983121013.1461.6069159959481048405.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 12:40:10 +0000
References: <20211217093911.611537-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20211217093911.611537-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Dec 2021 17:39:11 +0800 you wrote:
> The return value of kcalloc() needs to be checked.
> To avoid dereference of null pointer in case of the failure of alloc.
> Therefore, it might be better to change the return type of
> qlcnic_sriov_alloc_vlans() and return -ENOMEM when alloc fails and
> return 0 the others.
> Also, qlcnic_sriov_set_guest_vlan_mode() and __qlcnic_pci_sriov_enable()
> should deal with the return value of qlcnic_sriov_alloc_vlans().
> 
> [...]

Here is the summary with links:
  - qlcnic: potential dereference null pointer of rx_queue->page_ring
    https://git.kernel.org/netdev/net/c/60ec7fcfe768

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


