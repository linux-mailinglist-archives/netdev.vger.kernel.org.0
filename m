Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8ACF3A9498
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 10:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhFPICP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 04:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231835AbhFPICM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 04:02:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7C906613C7;
        Wed, 16 Jun 2021 08:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623830406;
        bh=IfFDpeq28XU38KPKjWaJIyhVohB/j8Ylu+d6shIHvmM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E7ct8s0tmUZWumw+mNbtd/Q8u/M6fbum5VrFrR+s2yK/lur09Bypn6AhoxDXfrmPI
         qLzWjTWF0PXxEKx5esQK99ipGGpd5T57xl/fbJbwt4TRbajQ/kSMf4HQKii0/u7pBr
         fyeY6kCQCO64ufu6sIAwvYx30H/U1VZ6EBzFV21s+EFzFv/AEEcsHmJCqhkfnXIeK8
         ARDsKEoirEhsSciwDUj3BZVFKzLc4ZHw1rcw7Whlv7dYHUKzd7N5T7ZGSkVgBIyvd2
         3Be9BRigCihFIiwbI5Z3GwfST3+CqN4GWEfUsJl9SWGNXFDMe8fOeaJxLPg29NRqHX
         HHC+x0cnAoctw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 710D160A71;
        Wed, 16 Jun 2021 08:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: chelsio: cxgb4: use eth_zero_addr() to assign
 zero address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162383040645.10821.7127786257248286174.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 08:00:06 +0000
References: <20210616064318.2236712-1-yangyingliang@huawei.com>
In-Reply-To: <20210616064318.2236712-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 16 Jun 2021 14:43:18 +0800 you wrote:
> Using eth_zero_addr() to assign zero address insetad of
> inefficient copy from an array.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: chelsio: cxgb4: use eth_zero_addr() to assign zero address
    https://git.kernel.org/netdev/net-next/c/c7654495916e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


