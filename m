Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1D43AA45D
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbhFPTcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231202AbhFPTcK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:32:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D49FE613C7;
        Wed, 16 Jun 2021 19:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623871803;
        bh=w7zfAQFASiqAf7jfTYDA3LUwWovR5yuVV5cqlggX6AI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RUJf9yUdV6fUqFSzbXRAtcmrxztfwoFKzxZWroIxZcFvY8gIgp1LmPrxjugDaTI9f
         CiTusoCPB9q0vNVq+gNcbjFIxglUoZawrA3UGK0XKI6O1r8VdKvnFx18l8gAA9MtCg
         Mrx72XR+08JJtTr+/00jrwPzMgfS9GP/BMejKKH3lqcXah4xz+baT3PNZkedAag3Nn
         oJhcyJ8VJMbFRZgfqZJClY3y6SyUWy4sQm4HXP5n89t1T42Js+1SqWre0LfaVF2lRW
         mveaXbcso+7zXV7ZYXoh6boQ1tQF6koKLh7Ov9PVdyTdzEJToWVmR5vUql4aqnmxPU
         bXGs5pKvewDhA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CF44A60953;
        Wed, 16 Jun 2021 19:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: qualcomm: rmnet: Remove some unneeded casts
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387180384.2076.16521433575397558966.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 19:30:03 +0000
References: <1623830353-9236-1-git-send-email-subashab@codeaurora.org>
In-Reply-To: <1623830353-9236-1-git-send-email-subashab@codeaurora.org>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, stranche@codeaurora.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 16 Jun 2021 01:59:13 -0600 you wrote:
> Remove the explicit casts in the checksum complement functions
> and pass the actual protocol specific headers instead.
> 
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> ---
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net-next] net: qualcomm: rmnet: Remove some unneeded casts
    https://git.kernel.org/netdev/net-next/c/56a967c4f7e5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


