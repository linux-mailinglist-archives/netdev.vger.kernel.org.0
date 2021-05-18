Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6ED3881A9
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 22:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352287AbhERUvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 16:51:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351951AbhERUvb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 16:51:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 08BD561364;
        Tue, 18 May 2021 20:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621371013;
        bh=LUI863nS3Idz6VPoGrycKJQx5zp73PfebopfaSBVehc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XuumOzvu9ldYzeMw5zJ3gtf5wTwhua0Djds7oVNW6qFwChip+W0iQmsud8Bo3GsVO
         VrxE2GnhkYu1hXrOpfpGgrlB/Qqu/8WzdJg7E8b1dCRZXC8z4idD6Vh5vmWWnhT9Mn
         UbU6IO6RpLznDl1FIgK9Ds44o+3Msvw0Yud4bI4aBEylImbz1CSHQvm0qH2jA74uhg
         P7utW3Awo+NxLqqDUXpCqSevxEmorTRHff984xuborq/p8iZl9mmFZ+Geu4eE/yymy
         5eWq5UEsw54wqyy4zi2Becg1icQjG6lVthF8TosFc7nsZ5JV/9tIJCfGAVZMbOg0kS
         88r4nkT2o4ssA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 01FEA60CE2;
        Tue, 18 May 2021 20:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: wan: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162137101300.13244.1757831101374937648.git-patchwork-notify@kernel.org>
Date:   Tue, 18 May 2021 20:50:13 +0000
References: <1621340994-20760-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1621340994-20760-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        tanhuazhong@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 18 May 2021 20:29:49 +0800 you wrote:
> This patchset clean up some code style issues.
> 
> Peng Li (5):
>   net: wan: remove redundant blank lines
>   net: wan: add some required spaces
>   net: wan: remove redundant braces {}
>   net: wan: remove redundant space
>   net: wan: fix variable definition style
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: wan: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/78524c01edb2
  - [net-next,2/5] net: wan: add some required spaces
    https://git.kernel.org/netdev/net-next/c/23c235412411
  - [net-next,3/5] net: wan: remove redundant braces {}
    https://git.kernel.org/netdev/net-next/c/a4e591477611
  - [net-next,4/5] net: wan: remove redundant space
    https://git.kernel.org/netdev/net-next/c/da8e6fddbae3
  - [net-next,5/5] net: wan: fix variable definition style
    https://git.kernel.org/netdev/net-next/c/a3f3e831dc2a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


