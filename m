Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCCB456E06
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 12:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235008AbhKSLNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 06:13:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235001AbhKSLN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 06:13:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 078A461AEC;
        Fri, 19 Nov 2021 11:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637320228;
        bh=cKzHm1Xaa4sT3HbFAGLvhxMORqDc7ht6K9yaETFdVfE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BUohdBd1v2pzL3tY8VxHV6xfTgHwmZ4QjaiMMafjxUKg3zcCqugTjb2IBbv0oj3Nj
         XoQSuOcP7Eo4kGpwNgkazuVor5aaxv00aJtxfT/+6/NvP6NG7rTLc8AdPaI+fGZ6FA
         Ikx5R8JaOQqayejNyk9WOlIccsV38bXHuaxqDb5CTmNOdgEwIcTkTJd9HC0ERRlAW6
         Z0YGjhfabZ6LjE4mAwmOXLYaUKTO8mOptb7osTUcfc8PXUjpIhUze1mG96Pgi3kBt0
         TWgLBOEaresQ6tbehr3JdnTGuroqFPkm4O/3ganrELYk36dIxQMygIP8uGTbOpyTt/
         7idWPkH8ljhFw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 026F9600E8;
        Fri, 19 Nov 2021 11:10:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: constify netdev->dev_addr - x86 changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732022800.23424.1843947489268600941.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 11:10:28 +0000
References: <20211118142720.3176980-1-kuba@kernel.org>
In-Reply-To: <20211118142720.3176980-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 06:27:16 -0800 you wrote:
> Resending these so they can get merged while I battle random cross builds.
> 
> Jakub Kicinski (4):
>   net: ax88796c: don't write to netdev->dev_addr directly
>   mlxsw: constify address in mlxsw_sp_port_dev_addr_set
>   wilc1000: copy address before calling wilc_set_mac_address
>   ipw2200: constify address in ipw_send_adapter_address
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: ax88796c: don't write to netdev->dev_addr directly
    https://git.kernel.org/netdev/net-next/c/e291422c8f00
  - [net-next,2/4] mlxsw: constify address in mlxsw_sp_port_dev_addr_set
    https://git.kernel.org/netdev/net-next/c/54612b4a8bc7
  - [net-next,3/4] wilc1000: copy address before calling wilc_set_mac_address
    https://git.kernel.org/netdev/net-next/c/b09d58025e3c
  - [net-next,4/4] ipw2200: constify address in ipw_send_adapter_address
    https://git.kernel.org/netdev/net-next/c/a608e6794b08

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


