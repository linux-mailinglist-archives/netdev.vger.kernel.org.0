Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1648D3687F8
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 22:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239661AbhDVUay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 16:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239524AbhDVUap (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 16:30:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7B5FE61460;
        Thu, 22 Apr 2021 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619123410;
        bh=1GrLGfllxrIYWHEidiMPJ4vU3uHx4TqfeNnxDpQqDWQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QclfcXYkBVlFZ/XPJ1+Di/LAo07hY2O6Yh/Z6iWh/ATERQsyy65gmrVbBevO631uU
         a9UbaQGZckov7OKze42xsA63qgUKgvJkoucqnN1y4e3qnjKp7zAKsZOMixUyUW6ABT
         GJJPb4ON7A6LM5TLirmsLA2mAqG8dtVxRlyJKZJh326zoWrBZNRFer/oDkKB5gZ6EL
         +8Bo1xPnkiKucr3e6aVpGqGI9tNRNCucPkhTbE7ZoHiSIvYgeXq6n7whRZ/QhkH0qn
         pQ3D0ScJDNGkY37jaJZIxb5SqV9T/Dc/2jyZdaF4PyZfCaFCgi0lwbIiHWDakZbkpj
         /vJUIXS+x67XA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7491D60A37;
        Thu, 22 Apr 2021 20:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netdevsim: Only use sampling truncation length when
 valid
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161912341047.26269.9573948771834553762.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Apr 2021 20:30:10 +0000
References: <20210422135050.2429936-1-idosch@idosch.org>
In-Reply-To: <20210422135050.2429936-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Apr 2021 16:50:50 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> When the sampling truncation length is invalid (zero), pass the length
> of the packet. Without the fix, no payload is reported to user space
> when the truncation length is zero.
> 
> Fixes: a8700c3dd0a4 ("netdevsim: Add dummy psample implementation")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] netdevsim: Only use sampling truncation length when valid
    https://git.kernel.org/netdev/net-next/c/a9b5d871abc4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


