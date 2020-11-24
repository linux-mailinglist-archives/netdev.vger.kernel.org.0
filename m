Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CBD2C32E2
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 22:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732344AbgKXVaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 16:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727966AbgKXVaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 16:30:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606253405;
        bh=sBYDeMl+n5eapUPjWZI1ZlDIKrnysJy33TDpSf2kRD0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=wPIpP0/Nq3a50iW8j+rJWAZN+KxQLmkWg5r92zHjIRIXi6fwGjkO0nsnVgzHYpxio
         ZMAHhBT1iYuHW8nywxPhr+WEa934VD7O8dmq6CbETJ5wooLFcaeYIoBHqMljQqzOgK
         nDHyTPc7lkjkH5UACD4Q0aNwNbSDIgYi738TxNcA=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: hns3: fix spelling mistake "memroy" -> "memory"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160625340526.29621.15361139996997000498.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Nov 2020 21:30:05 +0000
References: <20201123103452.197708-1-colin.king@canonical.com>
In-Reply-To: <20201123103452.197708-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, tanhuazhong@huawei.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 23 Nov 2020 10:34:52 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are spelling mistakes in two dev_err messages. Fix them.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 2 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [next] net: hns3: fix spelling mistake "memroy" -> "memory"
    https://git.kernel.org/netdev/net-next/c/be419fcacf25

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


