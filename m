Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EE1331AD6
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 00:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhCHXKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 18:10:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231749AbhCHXKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 18:10:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BA5B46521F;
        Mon,  8 Mar 2021 23:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615245007;
        bh=eZsbgmhSp1ZE6xyK39CROnAgKsXeSv0RyunU8E0yTrU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aZXITx5/C/IkquvkM5fE44yHwDjovy+tu+xFMEzlbfxxABjq0OzRUNGYjA9e+NBdb
         VCYFkR7y+GmqHVADsyrRGI7lDtfOfKBKIC+DFcka6OBnkFeQE52cex0G+3cE/8SCZB
         3GW4wpqNMl7nmKSOE3mly9d19qGDQfN1k1lyVNOZjK7BtK2MwPqn/RXIKBGWPQomHY
         0GgvACan/4JuXVndYM8KB/V7aXa2zRjgy0teCCFoH/5JYRuGpDP9Hkr/Dzx+jUPQ4t
         Lq0XNG3GciLFKRkW2xaGpSHsbjbNxf4AeFuxtrDOGJ3oOiKbs5xGmH/ockaecwlx0f
         sbKJYrpTqE0vQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A8213609E6;
        Mon,  8 Mar 2021 23:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: qrtr: fix error return code of qrtr_sendmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161524500768.8251.10623370492041781396.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Mar 2021 23:10:07 +0000
References: <20210308091355.8726-1-baijiaju1990@gmail.com>
In-Reply-To: <20210308091355.8726-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, loic.poulain@linaro.org,
        bjorn.andersson@linaro.org, mani@kernel.org,
        cjhuang@codeaurora.org, necip@google.com, edumazet@google.com,
        miaoqinglang@huawei.com, dan.carpenter@oracle.com,
        wenhu.wang@vivo.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  8 Mar 2021 01:13:55 -0800 you wrote:
> When sock_alloc_send_skb() returns NULL to skb, no error return code of
> qrtr_sendmsg() is assigned.
> To fix this bug, rc is assigned with -ENOMEM in this case.
> 
> Fixes: 194ccc88297a ("net: qrtr: Support decoding incoming v2 packets")
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: qrtr: fix error return code of qrtr_sendmsg()
    https://git.kernel.org/netdev/net/c/179d0ba0c454

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


