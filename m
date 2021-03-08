Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002743317FD
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 21:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhCHUAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 15:00:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231617AbhCHUAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 15:00:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3A1C565290;
        Mon,  8 Mar 2021 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615233609;
        bh=XqpBxlhRJTBhMT4v5QQ4xn98x+oyKH+32MYaniIe98o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DAwAf9FK3AFyc1P0vmdtubrfdUGZHxcJD94oMkIUd51RbqLTjgDRE+hmQduMh/R71
         KosB35HTFPbh+D1g/NaBz+KsFPSsrmOsw8/pKLInAsRTc/3dkyJ7fxzYGUg4SkrQMH
         DK5BOrOscFecwEbnTZrGYp/qpJtfuxcif9Q/ChcWPh0v/GrtAxeibcot5mEXA2iySW
         WNJsZsmkshUavnGNRrCBAve00fQA8wXo9moLqJyjVAlxfJXDbR1HijCuNMJ2+IeHzL
         Zc9IQioyf4N2hAHs5wy9qsqOk77UXtAmEyq/9MZxT9B6mArUv/6T9H9GBpOaXjlGlt
         dakCcPJ5CQlJQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 33DA46098E;
        Mon,  8 Mar 2021 20:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hisilicon: hns: fix error return code of
 hns_nic_clear_all_rx_fetch()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161523360920.22994.6884927954646956227.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Mar 2021 20:00:09 +0000
References: <20210307084012.21584-1-baijiaju1990@gmail.com>
In-Reply-To: <20210307084012.21584-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, tariqt@mellanox.com,
        jesse.brandeburg@intel.com, dinghao.liu@zju.edu.cn,
        trix@redhat.com, song.bao.hua@hisilicon.com, Jason@zx2c4.com,
        wanghai38@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun,  7 Mar 2021 00:40:12 -0800 you wrote:
> When hns_assemble_skb() returns NULL to skb, no error return code of
> hns_nic_clear_all_rx_fetch() is assigned.
> To fix this bug, ret is assigned with -ENOMEM in this case.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: hisilicon: hns: fix error return code of hns_nic_clear_all_rx_fetch()
    https://git.kernel.org/netdev/net/c/143c253f42ba

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


