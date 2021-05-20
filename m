Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FB138B9E8
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 01:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhETXBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 19:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232267AbhETXBd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 19:01:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2AFE2613BB;
        Thu, 20 May 2021 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621551611;
        bh=XyirkTi/RcI5wGGdpc/v8gmTxE5WpH9MVyLQm2sgizc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sgoKXlNTrOKRPnz8ZHGTploMEghpU7VENrhY357aSY90w179zw/O6x3T5lQvrCZlT
         kirrWxzrwu8Teo92pnno51y/CVN9OyjXM8Vw91X0oIW0baH6+WOmc0EbsJFutqTy+S
         IjnfM5beze96yYGOGBkN+IMBGw5dsuLfw4pDdfKY41YiwaBkzZC2OcApin+Wi1+d4j
         Ph6GIGQAxm+X19L+0qwfZ6pLbmnQOdJ2SsRMUAQh3AefDPJ0WCL8nltVq1YsouJc/6
         7UGa8KJNYNPyk5Ra7LjdJy8XH44I7DggiLjoRQ15rh14ZYRhylW3GwJipDG66etNVU
         ivKwcsx6LEaxw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1DCA860A56;
        Thu, 20 May 2021 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: cdc_ncm: use DEVICE_ATTR_RW macro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162155161111.31527.18414710877042247470.git-patchwork-notify@kernel.org>
Date:   Thu, 20 May 2021 23:00:11 +0000
References: <20210520134619.36356-1-yuehaibing@huawei.com>
In-Reply-To: <20210520134619.36356-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     oliver@neukum.org, davem@davemloft.net, kuba@kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 20 May 2021 21:46:19 +0800 you wrote:
> Use DEVICE_ATTR_RW helper instead of plain DEVICE_ATTR,
> which makes the code a bit shorter and easier to read.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/usb/cdc_ncm.c | 36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)

Here is the summary with links:
  - [net-next] net: cdc_ncm: use DEVICE_ATTR_RW macro
    https://git.kernel.org/netdev/net-next/c/86fe2f8aa14f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


