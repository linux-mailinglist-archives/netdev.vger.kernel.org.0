Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0EE3A4A0C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhFKUWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhFKUWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 16:22:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 83376613D9;
        Fri, 11 Jun 2021 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623442808;
        bh=wWir08b0LlSAZ4C72jb5917xWZicSQZop+VlTO+oGEs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sHy1MnaDauFsILhxLiE1s+OvB+OX2QGZZJLLPJz2MBjsKachSr+ZSGtcabgj7G07k
         okxmtXH5nBVtWioBj6MlQY+6FSmGyhkCEkjyv/r9g/KP3IsfsAK0P3mU53W5uGQ50S
         B+Ih0VwxnZ3hcvbDBNZ8IzT7aqKU8pL4ZijO11X8l1zdgI2tIQOj6IO2BtQoem9SYT
         2mSkVx9pvMG4c9C1F2PlabgRR/ayJeKWGaziRJgBVzs/cS7Eca9ZCfSxfhMOuwEzsV
         VBdE8lViA4ApLKdZ0g9ZwnIqKrgBYp1+jRRI2gJSAjnzx5pvgGCv4ew/wUVIlMo82s
         Z0CLBmmXOJ3hQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 71EB060D07;
        Fri, 11 Jun 2021 20:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: mdio: mscc-miim: Use
 devm_platform_get_and_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162344280846.13501.13059691757740080841.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 20:20:08 +0000
References: <20210611080409.3647459-1-yangyingliang@huawei.com>
In-Reply-To: <20210611080409.3647459-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        weiyongjun1@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 16:04:09 +0800 you wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v3:
>   no need use 'res'
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: mdio: mscc-miim: Use devm_platform_get_and_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/8ee1a0eed16a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


