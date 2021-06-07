Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5072139E8E1
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhFGVL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230329AbhFGVL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 17:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8EE9A61208;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623100205;
        bh=Im2mwC841YMSc8Q0wkND31y4nly9YA1BpL2LMKF9cJc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LT7FSMDlXzGiJNxbERDAfzWxFdV1BBzq3COoTqz9afgNyNkhZKCIilqnpbbUyQiIf
         oTvozRfV+riZ3eWhV7O2MN7kF1wdpW0p93aBzLou1AiP9iqxu2SZEtVDNkRNgUzwsD
         Vqw1V0d7qzNhXim2AsudX+cIMZ8Z3/WbCMfRWSAt1UOvqEG1UtzxP7iWSD1qY35ezA
         O+m/FgU9D5Z1CXOzCqUxdIrGsHGZaOG4xIS5vhokw9NmZ02F4qw0fhIp8pF0TdZGLD
         +/ce64494Gbgha+ohwOur4/3jV/dXVADlWs4ZhWVHUcNdCqmkSGfRi/tkphLJaYbkI
         BxerkbCzHhIVA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 828C4609F1;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: bgmac: Use
 devm_platform_ioremap_resource_byname
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162310020552.31357.11345830124155367221.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 21:10:05 +0000
References: <20210607142109.3992446-1-yangyingliang@huawei.com>
In-Reply-To: <20210607142109.3992446-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rafal@milecki.pl, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 7 Jun 2021 22:21:09 +0800 you wrote:
> Use the devm_platform_ioremap_resource_byname() helper instead of
> calling platform_get_resource_byname() and devm_ioremap_resource()
> separately.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  .../net/ethernet/broadcom/bgmac-platform.c    | 21 +++++++------------
>  1 file changed, 7 insertions(+), 14 deletions(-)

Here is the summary with links:
  - [net-next] net: ethernet: bgmac: Use devm_platform_ioremap_resource_byname
    https://git.kernel.org/netdev/net-next/c/3710e80952cf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


