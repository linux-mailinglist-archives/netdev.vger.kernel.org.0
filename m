Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557172CE564
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 02:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgLDBsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 20:48:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgLDBsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 20:48:15 -0500
Date:   Thu, 3 Dec 2020 17:47:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607046454;
        bh=AQY5BJplhCDksrT33MEXaYA1EyaNTY3zCy0uFg/tcz0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=OnCMDOMSrPaTlkMdba/HRsMweAcTaLG4ccwWhKeGjWPtgyjaxFlwg36eOyY6KgELK
         PeZflppySeUpxi4Gpj0b6F/IlTlYA9t7lldUKUgq2hPWPMukNomQP58PhcF23JmUny
         ttrPu+qfhfsZS1Zpjng7eAG3okWgL7nNB1dAMl74zO30EtUJsoKJedYm6vbkgB11wo
         MsXb4Y23zlHDcYKyedkx+sJdMfDgYxg8cSShDtFyO1rAlp3HUEvNuWvsZS7L2I8KYb
         3TRTkGCHiWTjZpwe59RPLdRX8sALdCik/tico1CjZReGH8L/4gqzijX+su1txnm2Ve
         7mg7NMVFvRmwg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Arnd Bergmann <arnd@kernel.org>, saeedm@nvidia.com,
        leon@kernel.org, davem@davemloft.net, tariqt@mellanox.com,
        maximmi@mellanox.com, arnd@arndb.de, borisp@nvidia.com,
        efremov@linux.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: fix non-IPV6 build
Message-ID: <20201203174732.798cf160@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <160704481592.10454.9610234423431543181.git-patchwork-notify@kernel.org>
References: <20201203231314.1483198-1-arnd@kernel.org>
        <160704481592.10454.9610234423431543181.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Dec 2020 01:20:15 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (refs/heads/master):
> 
> On Fri,  4 Dec 2020 00:12:59 +0100 you wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > When IPv6 is disabled, the flow steering code causes a build failure:
> > 
> > drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:55:14: error: no member named 'skc_v6_daddr' in 'struct sock_common'; did you mean 'skc_daddr'?
> >                &sk->sk_v6_daddr, 16);
> >                     ^
> > include/net/sock.h:380:34: note: expanded from macro 'sk_v6_daddr'
> >  #define sk_v6_daddr             __sk_common.skc_v6_daddr
> > 
> > [...]  
> 
> Here is the summary with links:
>   - net/mlx5e: fix non-IPV6 build
>     https://git.kernel.org/netdev/net-next/c/8a78a440108e
> 
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html

Heh, it appears you managed to create a similar enough patch for the
patchwork bot to confuse the two :)

So to be clear this was not applied :)
