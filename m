Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520C8476F5D
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 12:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236356AbhLPLAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 06:00:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53104 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236343AbhLPLAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 06:00:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BC76B82395
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 11:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50069C36AF9;
        Thu, 16 Dec 2021 11:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639652412;
        bh=kWl6zI2Nsp1TC1EeYNeTZbhYVSmGJxZ/tmvQejXHpag=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aK+UUdA19wgnbxmaapqmOs9bWkhXwVIgJ0u0U/GLrXHVXT22zQFBIcv/AoBhe5TN7
         yZszGF1uJPyL+sjSUsit901o5CmSJA470tzlR3Wk37kvaUL7C1IVo2dTj+Ki+aRmwk
         4ra8B1bYBMeekeZ3+kR5WPjkWIjEALWkq6rVyzJKkNK0PjTBJpnAvZy6p9pof0CBTL
         xhXtbV76Zd6jecbx6NYu1EyU3q+TKD4FLrB44uiUSPjnEsuV/BTuWQo66lRV0udFZB
         Cx01EmdoYVuIDd3EZzNJcpS8ZwuK6PAqAeugs5UI0RrjZweDVWxY9lUq/En6q9Il1g
         SXebPZ92l0/1g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3089060A3C;
        Thu, 16 Dec 2021 11:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: rtl8365mb: add GMII as user port mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163965241219.2516.15466995641807042179.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Dec 2021 11:00:12 +0000
References: <20211215034128.18199-1-luizluca@gmail.com>
In-Reply-To: <20211215034128.18199-1-luizluca@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, alsi@bang-olufsen.dk,
        linus.walleij@linaro.org, arinc.unal@arinc9.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Dec 2021 00:41:28 -0300 you wrote:
> From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> 
> Recent net-next fails to initialize ports with:
> 
>  realtek-smi switch: phy mode gmii is unsupported on port 0
>  realtek-smi switch lan5 (uninitialized): validation of gmii with
>  support 0000000,00000000,000062ef and advertisement
>  0000000,00000000,000062ef failed: -22
>  realtek-smi switch lan5 (uninitialized): failed to connect to PHY:
>  -EINVAL
>  realtek-smi switch lan5 (uninitialized): error -22 setting up PHY
>  for tree 1, switch 0, port 0
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: rtl8365mb: add GMII as user port mode
    https://git.kernel.org/netdev/net-next/c/a5dba0f207e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


