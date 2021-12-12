Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C374E471B90
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 17:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhLLQaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 11:30:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41996 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhLLQaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 11:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25C17B80CC9;
        Sun, 12 Dec 2021 16:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8BFBC341C8;
        Sun, 12 Dec 2021 16:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639326609;
        bh=fxvB5pNQtvtjyrGDzo57OSUsf7bnkNWzHY8g9ucR43s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B8MG++iAZcdunMr//TApuwjQJTa7Lh8Uglz90NtbGzd4hHO8ExswsTzXICYaSazXs
         /h1PilwZnbbcsM/FDpwaBxrUBQftQachfdYd+orGDKNHUqjgwYX60nzJs567lMl+j4
         tcr5xGIw4TTGK9lQ08zr6zcBaJMsy9qBRM2n/YVPfBK1I/FGlIvVDAj7AlsZK/FE42
         CISD4N9/GBbcl9srMvPIp6A3mm4wQNord8Um0pwJa87Y3iM3XqAnV2Lkb9bzstX+d0
         HRrcHzAP33W/JXZNZu7w+h/2MrTk50TpkECrz6Vkt1QaPJjiGiQPJtPQoodbCVinuq
         qx7mjfrqr6unQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BC58B60C78;
        Sun, 12 Dec 2021 16:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: hns3: add some fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163932660976.2571.4152316250430591107.git-patchwork-notify@kernel.org>
Date:   Sun, 12 Dec 2021 16:30:09 +0000
References: <20211210130934.36278-1-huangguangbin2@huawei.com>
In-Reply-To: <20211210130934.36278-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangjie125@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Dec 2021 21:09:32 +0800 you wrote:
> This series adds some fixes for the HNS3 ethernet driver.
> 
> Jie Wang (1):
>   net: hns3: fix use-after-free bug in hclgevf_send_mbx_msg
> 
> Yufeng Mo (1):
>   net: hns3: fix race condition in debugfs
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: hns3: fix use-after-free bug in hclgevf_send_mbx_msg
    https://git.kernel.org/netdev/net/c/27cbf64a766e
  - [net,2/2] net: hns3: fix race condition in debugfs
    https://git.kernel.org/netdev/net/c/6dde452bceca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


