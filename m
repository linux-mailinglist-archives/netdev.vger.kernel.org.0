Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C95B43AA37
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 04:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbhJZCWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 22:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233880AbhJZCW3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 22:22:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DD92660FC2;
        Tue, 26 Oct 2021 02:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635214806;
        bh=lakr3UPFv2mnE2bnA96cA7slg3fFBxPWqEavUDsQrBA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gg88KcBfONZdxW+iT+VIZyNCNZ/DuutEghxZomLjtrIW3o8QrnW8wqc2BjaVe/Yoo
         CH/f4nBs2uPWE8jRUJlVsi4EyYSxBLxCLEWinu5t79jaf5x8ciyxcC5//Xetw4d+Xu
         qrsG5wN/p7ypD9ycYXsIL7g+yaaQZsD49q67jLXvmNnyalTYSouCD+Y5wctDnuPLgv
         +64K4q/SEY9OzJTScxQc5U8se5OyaHWNL2G/iXC3kh9g4DZOIXO8iZK5N5zriQxzTH
         fAQdTdfNRCN7ug4uon95C+gCK+cZcaxkcxwx80LZYLlMGCb8Tpd2WFq9WTj+kROTIL
         Pm7rsV5bKhBTg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C9FB460A25;
        Tue, 26 Oct 2021 02:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mlxsw: pci: Recycle received packet upon allocation
 failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163521480682.2466.13347022600495507115.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 02:20:06 +0000
References: <20211024064014.1060919-1-idosch@idosch.org>
In-Reply-To: <20211024064014.1060919-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 24 Oct 2021 09:40:14 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> When the driver fails to allocate a new Rx buffer, it passes an empty Rx
> descriptor (contains zero address and size) to the device and marks it
> as invalid by setting the skb pointer in the descriptor's metadata to
> NULL.
> 
> [...]

Here is the summary with links:
  - [net] mlxsw: pci: Recycle received packet upon allocation failure
    https://git.kernel.org/netdev/net/c/759635760a80

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


