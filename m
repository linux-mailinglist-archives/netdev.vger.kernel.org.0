Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9929F354881
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 00:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242719AbhDEWKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 18:10:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242661AbhDEWKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 18:10:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BAB3B613DB;
        Mon,  5 Apr 2021 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617660609;
        bh=b8E5F2uI+ocb1JEnAxXaFV65R3Uq7rf0HaDvcqfzn6g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OQbXd2bJNmKQTiGl7Ipy/ikbSc+qSNGP/XHeRRI9Xtmw27weNlP6c9PIhpkbsbVK3
         Agy22M88XhO10TLD0EZATTQp9iIVdjIjVBMYVR/Ev5ugHTjTh/PI71tSDdn54XdqZu
         8U34UgkjZ6Ejz3akaZt4IgwBj91JG0pB1SZLCygOa1gqs729lJ6AIpnvZL65fbvf3g
         c0It4a3KvZIRKf71lQuFBUuB2b1zGvly7Sm89/eD0ryFsrzOIjZL2TK94uxLPKWUDb
         tYYvdXWQSzfDhw7uAtiLb5Ig+fVBokN41NAt9jXusRoUv2zgKnbY0GnyoaB/NgFuZs
         2EoQJZSixu71g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B590C60A2A;
        Mon,  5 Apr 2021 22:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: hns3: Limiting the scope of vector_ring_chain
 variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161766060973.24414.1256394756703505340.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Apr 2021 22:10:09 +0000
References: <20210405172825.28380-1-salil.mehta@huawei.com>
In-Reply-To: <20210405172825.28380-1-salil.mehta@huawei.com>
To:     Salil Mehta <salil.mehta@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        linuxarm@openeuler.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 5 Apr 2021 18:28:25 +0100 you wrote:
> Limiting the scope of the variable vector_ring_chain to the block where it
> is used.
> 
> Fixes: 424eb834a9be ("net: hns3: Unified HNS3 {VF|PF} Ethernet Driver for hip08 SoC")
> Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: hns3: Limiting the scope of vector_ring_chain variable
    https://git.kernel.org/netdev/net-next/c/d392ecd1bc29

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


