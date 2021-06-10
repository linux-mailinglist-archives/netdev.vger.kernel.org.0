Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084D63A359F
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhFJVMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231251AbhFJVMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 905C461410;
        Thu, 10 Jun 2021 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623359404;
        bh=Xf/Mser0Wt8vmZfOibipy93iub3FShlAnjgArrrZeVo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dPF8AVT5TtbEdRp4qP/lr6xDSf8McmOFWGSEpsYnMqXSglEqusYWY75Kk64KFmfx7
         JtY1mtioMvSbTlJMkm7WnmHb/+z6vFLawTc2JOLzZwZA98F+/DNWg3GmNw/AzzxBLV
         4VCxdWiw7T3YbDkbDPNlEKozve2RsQFeLuTn/UiudjxPAp2/nUyCtLWZHps3pq18cd
         Y6oBbqDpjWXhEbg8pDhk7rS//V6XtU/lPY3l9X0Ixxz5s7NXK6ZmASxfmFWphGrDFM
         KNk7Ot77srqk8c2AEDUFfN1efJ31sOj/KG0wgxFFeY9ERAYJJR8R/j1ElbJIbt/DC0
         ZTwH2T0wxjYtQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8059660A6C;
        Thu, 10 Jun 2021 21:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ibmvnic: Use list_for_each_entry() to simplify code
 in ibmvnic.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335940452.9889.14454091571299464148.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:10:04 +0000
References: <20210610125417.3834300-1-wanghai38@huawei.com>
In-Reply-To: <20210610125417.3834300-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, drt@linux.ibm.com,
        sukadev@linux.ibm.com, tlfalcon@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 10 Jun 2021 20:54:17 +0800 you wrote:
> Convert list_for_each() to list_for_each_entry() where
> applicable. This simplifies the code.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] ibmvnic: Use list_for_each_entry() to simplify code in ibmvnic.c
    https://git.kernel.org/netdev/net-next/c/3e98ae0014cb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


