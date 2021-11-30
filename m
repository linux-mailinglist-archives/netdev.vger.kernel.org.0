Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3E4463447
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241628AbhK3Mdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:33:46 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42250 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241588AbhK3Mde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:33:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E3DC8CE19CE;
        Tue, 30 Nov 2021 12:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1553BC56748;
        Tue, 30 Nov 2021 12:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638275412;
        bh=UUTw0oy7HwvjSPYQW51LGs2Hm3K17yDrHTmdO4PH71w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ld+AAzu4Co9TweI4koDb18iF0NT8ff1yZ2FNnOpXxYVPfIPU77dcrfYazM25mSO/h
         nvCVMFzVgtbF9/iYJ8imHUyyaqGUlh5NgnxNjvB9RzBHD9PTw3LCyp7VgTzfMmWh8v
         q5kx7mN5trksZhxNMQD5quVVRnvog3y8EHQGVE6V7Js37qK82bFi3zfu4WNxaUpMLZ
         2D3qeYC5PONflcRENtWbnh2RhywRZOaFmydOeiJKRYRCoQQjjbx/JL3LCN/i97TDww
         fq48iN2ePypRUU1jnAeHMLc7ouJIurHNT+Ah+3T/tcVRBs0m0R30cMj3VzEZMmw5OJ
         sR3RIhyejEhiQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F3DC460A94;
        Tue, 30 Nov 2021 12:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: hns3: make symbol 'hclge_mac_speed_map_to_fw'
 static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827541199.1181.7236143870277791794.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:30:11 +0000
References: <20211130113437.1770221-1-weiyongjun1@huawei.com>
In-Reply-To: <20211130113437.1770221-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, tanhuazhong@huawei.com,
        huangguangbin2@huawei.com, shenjian15@huawei.com,
        moyufeng@huawei.com, zhangjiaran@huawei.com, liaoguojia@huawei.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Nov 2021 11:34:37 +0000 you wrote:
> The sparse tool complains as follows:
> 
> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c:2656:28: warning:
>  symbol 'hclge_mac_speed_map_to_fw' was not declared. Should it be static?
> 
> This symbol is not used outside of hclge_main.c, so marks it static.
> 
> [...]

Here is the summary with links:
  - [net-next] net: hns3: make symbol 'hclge_mac_speed_map_to_fw' static
    https://git.kernel.org/netdev/net-next/c/c0190879323f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


