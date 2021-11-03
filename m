Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7AD444392
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhKCOco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:32:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231464AbhKCOco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 10:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A6C6561053;
        Wed,  3 Nov 2021 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635949807;
        bh=E21pwJW18RO2gou05dCYN+YaAY7hMj8ZKh7YBzvQLXY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=krlQrCe+4GOvV5iH9PeG01rfFK0DssAFMFtKbnoQtHS4o4I05+AfU2HlDrTC3j5Iz
         BRII87IgpazApgoEV9XuwkDgdCBBXOOpgoR3MDmxv+792Lre1ob9ShFSzilo1tDkTD
         k8tAK9ALy5iEQY1JNT7q7wETwYsTE6ntYkE7ChfGfdwpDGwJeUwwBsk4j2RmIoDdWe
         YZjN1UdHkUHZWJmhsQGzhhslf6IKyGeTLaujACfyOBdKbhnNkIhUxHyMI35sLVW4C4
         vBrYfDo734rMJl3ViOxQxuwCRfZuELN5iv2O3b8/iGfQYCEXIGsH+RNZby5+bZyz4j
         KeK4X59cNzF4g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9DC3F60A39;
        Wed,  3 Nov 2021 14:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: vlan: fix a UAF in vlan_dev_real_dev()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163594980764.8310.6832272093505307449.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 14:30:07 +0000
References: <20211102021218.955277-1-william.xuanziyang@huawei.com>
In-Reply-To: <20211102021218.955277-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jgg@nvidia.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 2 Nov 2021 10:12:18 +0800 you wrote:
> The real_dev of a vlan net_device may be freed after
> unregister_vlan_dev(). Access the real_dev continually by
> vlan_dev_real_dev() will trigger the UAF problem for the
> real_dev like following:
> 
> ==================================================================
> BUG: KASAN: use-after-free in vlan_dev_real_dev+0xf9/0x120
> Call Trace:
>  kasan_report.cold+0x83/0xdf
>  vlan_dev_real_dev+0xf9/0x120
>  is_eth_port_of_netdev_filter.part.0+0xb1/0x2c0
>  is_eth_port_of_netdev_filter+0x28/0x40
>  ib_enum_roce_netdev+0x1a3/0x300
>  ib_enum_all_roce_netdevs+0xc7/0x140
>  netdevice_event_work_handler+0x9d/0x210
> ...
> 
> [...]

Here is the summary with links:
  - [net,v2] net: vlan: fix a UAF in vlan_dev_real_dev()
    https://git.kernel.org/netdev/net/c/563bcbae3ba2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


