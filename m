Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FB4301895
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 22:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbhAWVk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 16:40:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbhAWVku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 16:40:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E415C225AB;
        Sat, 23 Jan 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611438009;
        bh=ONvjq+UjX4anQ1tPM9isMfz7qcgIk0uLz88ecngJZf0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uzgt6R+Pa0OhnhH96TA6ztSy8BcSYr7JYHSp8b4CS2ulDljCBzzgT58ACs/XySiC3
         ppAqpU6PTKLs+IGM6luXuL1AbuZb/05Hz67Q+M6YyJ5AVEfR0x5eeu6FjpQEfHphVE
         po+5hEaT8Q8lHqNw5wle4mvBBL+vPHWl0Rij+M/BSxAfWsnu+KodYP271Kq5ochmwf
         rLqYGVqCM4qn3WmGKzP7i8wA2uZ6ANlBK/cTntAClXZOmGP1TODr7EqEuqw4qQO8p+
         xQG7DwRw/WVWAEH9AuFAhO83xLvy/l/VA3XLA9uSGjp3/5wvWqfIwidr0wFqNVe5HD
         Sm6Q40HdDonpw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D6837652E7;
        Sat, 23 Jan 2021 21:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] NFC: fix resource leak when target index is invalid
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161143800987.9404.16584498835961654532.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 21:40:09 +0000
References: <20210121152748.98409-1-bianpan2016@163.com>
In-Reply-To: <20210121152748.98409-1-bianpan2016@163.com>
To:     Pan Bian <bianpan2016@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mkl@pengutronix.de,
        ieatmuttonchuan@gmail.com, sameo@linux.intel.com,
        linville@tuxdriver.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 21 Jan 2021 07:27:48 -0800 you wrote:
> Goto to the label put_dev instead of the label error to fix potential
> resource leak on path that the target index is invalid.
> 
> Fixes: c4fbb6515a4d ("NFC: The core part should generate the target index")
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  net/nfc/rawsock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - NFC: fix resource leak when target index is invalid
    https://git.kernel.org/netdev/net/c/3a30537cee23

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


