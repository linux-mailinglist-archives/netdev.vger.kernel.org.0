Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F8747678A
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 02:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbhLPBuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 20:50:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59192 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhLPBuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 20:50:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7754AB82270;
        Thu, 16 Dec 2021 01:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19147C36AE3;
        Thu, 16 Dec 2021 01:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639619412;
        bh=xRCi2BjmOz49Fn05BPlL8EHRVcVN25KewWgzQ2EVIvI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GMwpnzryTgq93dYa4GbaXRYIKVmBCeIoa2V/K8p5sh8kiyQUX+9GUYFZXwzQJyGQq
         BXjZWvrv4qUF4/GZF675R+9LI6gy11ton0cCphhLbD9zX7e8UiMfJNoif+DoghY9yQ
         RdSk7abImJEMkRIkIQul4JuhYwpJMzXpWYA5bn+ROgr02GB5w5Z1G/limHfVYCoTrP
         C2CRS+MdLmnOXIqRmky8Kv3i8Uf5t9V3uKf7ToJuBYsMEp3wJPEFfn7N+cMJ2SSr/D
         owPwo+sR78ZioWXk0e+tyEaSQwhrCnjNuROrOtylAtw/1JTKIDvVdffJiqXb9I7Syf
         rk6NVZjoWjXOw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E311E609F5;
        Thu, 16 Dec 2021 01:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH nf-next 1/7] ipvs: remove unused variable for ip_vs_new_dest
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163961941192.15023.123221288094192092.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Dec 2021 01:50:11 +0000
References: <20211215234911.170741-2-pablo@netfilter.org>
In-Reply-To: <20211215234911.170741-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 16 Dec 2021 00:49:05 +0100 you wrote:
> From: GuoYong Zheng <zhenggy@chinatelecom.cn>
> 
> The dest variable is not used after ip_vs_new_dest anymore in
> ip_vs_add_dest, do not need pass it to ip_vs_new_dest, remove it.
> 
> Signed-off-by: GuoYong Zheng <zhenggy@chinatelecom.cn>
> Acked-by: Julian Anastasov <ja@ssi.bg>
> Acked-by: Simon Horman <horms@verge.net.au>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [nf-next,1/7] ipvs: remove unused variable for ip_vs_new_dest
    https://git.kernel.org/netdev/net-next/c/fc5e0352ccb5
  - [nf-next,2/7] netfilter: conntrack: Use memset_startat() to zero struct nf_conn
    https://git.kernel.org/netdev/net-next/c/4be1dbb75c3d
  - [nf-next,3/7] netfilter: nf_queue: remove leftover synchronize_rcu
    https://git.kernel.org/netdev/net-next/c/c5fc837bf934
  - [nf-next,4/7] netfilter: ctnetlink: remove useless type conversion to bool
    https://git.kernel.org/netdev/net-next/c/632cb151ca53
  - [nf-next,5/7] netfilter: nft_fwd_netdev: Support egress hook
    https://git.kernel.org/netdev/net-next/c/f87b9464d152
  - [nf-next,6/7] netfilter: bridge: add support for pppoe filtering
    https://git.kernel.org/netdev/net-next/c/28b78ecffea8
  - [nf-next,7/7] netfilter: conntrack: Remove useless assignment statements
    https://git.kernel.org/netdev/net-next/c/284ca7647c67

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


