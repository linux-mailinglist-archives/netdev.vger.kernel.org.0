Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4992E2CE4F7
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 02:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731967AbgLDBU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 20:20:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728404AbgLDBU4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 20:20:56 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607044816;
        bh=NrM2b2fa9q1KZ4FNw4yAH1tlKNOWkBTa+qMCGztsvVI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P84HmlTQRDGhZy0eS/32aqtbPqcF3nOpBI74pgHHBSaBWg3kQkl97TBgBx/AcDplT
         X2ea9NSbCd6XZBz+gdMri7Gn6k0EY21m3PrgAso8W2Ip0J2m6kQpCbnmmexrX+UUWm
         gX6dp++PeVDNcDvhycDafuvQqs4DnN5HrlYPeKIZQw5Huuh76LxW9Hyete+ejuzFQe
         /INkIZ7kbdvUUhPlV/+Asgehw1qRJAI8yZGnQCJwidoyUzbYGINyZtafET1amqSHTK
         BNsDVcV637eO0GLOEU2P7sVopJFH75PnDD5KBEGy4tHeICUYS34tJbxnTpAf0naiSe
         KPK0sai2oryMA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/mlx5e: fix non-IPV6 build
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160704481592.10454.9610234423431543181.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Dec 2020 01:20:15 +0000
References: <20201203231314.1483198-1-arnd@kernel.org>
In-Reply-To: <20201203231314.1483198-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org, tariqt@mellanox.com, maximmi@mellanox.com,
        arnd@arndb.de, borisp@nvidia.com, efremov@linux.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  4 Dec 2020 00:12:59 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When IPv6 is disabled, the flow steering code causes a build failure:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:55:14: error: no member named 'skc_v6_daddr' in 'struct sock_common'; did you mean 'skc_daddr'?
>                &sk->sk_v6_daddr, 16);
>                     ^
> include/net/sock.h:380:34: note: expanded from macro 'sk_v6_daddr'
>  #define sk_v6_daddr             __sk_common.skc_v6_daddr
> 
> [...]

Here is the summary with links:
  - net/mlx5e: fix non-IPV6 build
    https://git.kernel.org/netdev/net-next/c/8a78a440108e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


