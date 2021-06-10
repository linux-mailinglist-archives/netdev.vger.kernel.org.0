Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B1C3A35A6
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhFJVMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231270AbhFJVMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BAED561431;
        Thu, 10 Jun 2021 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623359404;
        bh=m6fNHg3pqR5yrubis6OTYhXnestF5ROcnkVag5Iyg5g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ieBfoY6z//+z/Ezv3PHLot1WdJKLnfY7i2bxzMJzhZ3sXbF3Rd/a5DgzZv+hs/8fo
         4NFakA4LfHaRjrxzKpLii+bwK0keAKcJrG39qywIgr8mEWzt981z6HVa9jWG+tS5lD
         FpOiUCkIhKZONMjXT6sT5tsS8Rgo0gH+++1vKIVPcYgYMPDzpjOkLK/lmmsgmVSPYI
         KGt9SwrFxjRIT6mNiMztA8QlWXY9TFn3I4x3nU4dbycXs4lFETSyZqmZoqEzt9wJpu
         srxOeH5j4jMBjNB2sztoHGXhqUPJcnXZZ2jjBpeEYlu0ChTi+TngqetgJGxc1Yj7KN
         Mt8KytKYi08lg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B12D660A6C;
        Thu, 10 Jun 2021 21:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mido: mdio-mux-bcm-iproc: Use
 devm_platform_get_and_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335940472.9889.16622785228018966409.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:10:04 +0000
References: <20210610091712.4146291-1-yangyingliang@huawei.com>
In-Reply-To: <20210610091712.4146291-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 10 Jun 2021 17:17:12 +0800 you wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code and avoid a null-ptr-deref by checking 'res' in it.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/mdio/mdio-mux-bcm-iproc.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] net: mido: mdio-mux-bcm-iproc: Use devm_platform_get_and_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/8a55a73433e7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


