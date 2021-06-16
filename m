Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B893AA46F
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbhFPTmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231262AbhFPTmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 02AE761351;
        Wed, 16 Jun 2021 19:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623872404;
        bh=YELWwO2vUJcOTx9spYjfhggty36Lse67QBILhvwvA/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DkbiiFEqkQ6P5/GQO3n0568Ms07sl/OZdnYmGYN25FKN5Z79gVANjBNAWsfxWm6n7
         B9OvJLRzD/SDw5C96biCqpbz7yjXyrPzUFB/BXjkzBYMmPs1Ug+l/9kqwPTuZqyUzw
         87TgEC1C/iHb6NLtV1umGj3aaHYJrdjwytWgrVZZo+WgVGpSLmDUBGoR1ns3l7dawC
         MQ4f9kun/zFjUAe9KNqYxI3b274NAcxGvg0D/H9hVaChaEN7CMF4wn3kJS0dHihwnS
         7N/W1pGPvjONapBbFO/boyXQP26vOWJ3xAQOrZQWcAAzGaqm/KeqXT/fxbNoUJENjw
         hPGjv8IHuC5gQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EA3E660A54;
        Wed, 16 Jun 2021 19:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: usb: fix possible use-after-free in smsc75xx_bind
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387240395.6512.4732760148089343108.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 19:40:03 +0000
References: <20210616024833.2761919-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210616024833.2761919-1-mudongliangabcd@gmail.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     steve.glendinning@shawell.net, davem@davemloft.net,
        kuba@kernel.org, paskripkin@gmail.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 16 Jun 2021 10:48:33 +0800 you wrote:
> The commit 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> fails to clean up the work scheduled in smsc75xx_reset->
> smsc75xx_set_multicast, which leads to use-after-free if the work is
> scheduled to start after the deallocation. In addition, this patch
> also removes a dangling pointer - dev->data[0].
> 
> This patch calls cancel_work_sync to cancel the scheduled work and set
> the dangling pointer to NULL.
> 
> [...]

Here is the summary with links:
  - [v2] net: usb: fix possible use-after-free in smsc75xx_bind
    https://git.kernel.org/netdev/net/c/56b786d86694

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


