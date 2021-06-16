Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7903A9467
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbhFPHwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:52:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231425AbhFPHwK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 03:52:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 786296128C;
        Wed, 16 Jun 2021 07:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623829804;
        bh=Etdq7Jh8Yf5xfGX/dXOr0VpJlHQqo8VNxgwcO/LLi1U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZZ9MCvnoK6zHw1kHFtkKe8wCojkhtStVgzOHiMW7RBK+RqG2g+v1BRyVihvgGxO99
         AQqa+mIpcNoYgBjxZLlBnOiYyegGz41yFbvOsFkqzVwT9Fv05t18LHUYDVI8hKCSEi
         bIu3wsqx1CZRWu9JIfOQq1g6Afu4CSo2EWhcoDNSD/m3cRXbvL8g3rR8aajkozYkow
         4XIWkowCQjirHh5w3HQCIF6K1eS1tUOQY79jLwW37k04T5QjAU7IwauRR4wNKdtG7Z
         bXXGfmzGXXuOB7acWY8RHe6aNGG66/ggzoLH2xpBy/QXUM3HsdelQuJ6/QTdIqmsyY
         0P0SRQqAzbO9Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6BE8E60A6F;
        Wed, 16 Jun 2021 07:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] qlcnic: Use list_for_each_entry() to simplify code
 in qlcnic_main.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162382980443.6206.9562672833104579304.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 07:50:04 +0000
References: <20210616042106.314433-1-wanghai38@huawei.com>
In-Reply-To: <20210616042106.314433-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shshaikh@marvell.com,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 16 Jun 2021 12:21:06 +0800 you wrote:
> Convert list_for_each() to list_for_each_entry() where
> applicable. This simplifies the code.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] qlcnic: Use list_for_each_entry() to simplify code in qlcnic_main.c
    https://git.kernel.org/netdev/net-next/c/56b57b809f9c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


