Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106863E342F
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 10:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhHGIu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 04:50:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229803AbhHGIuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 04:50:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2F7D461158;
        Sat,  7 Aug 2021 08:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628326207;
        bh=b8UP5Ma1JomgKGZV0zJ9URLk3du+sZGMfZq8vCcYvrs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B7cGAojsqBCaUmVaBk4MMAPwv/DdTkf/CHg7flV1SGK1xit1TOw7him7WCqanbdGN
         J+Q8VkHql2rS1ixim5j6WC17o76ZKKuL1EZkmunmrDh/fjdYd3uK9vNMmuxIKw8mMR
         Uc82beyzZe6VcY1V5leXWqASS5zrohqEqqUc6BQjgoj/lFVxt0x7+K18G8xm7tKgzO
         4sfzIjO8DCNWelhtU+/ekGKSrWZATiWMVwIRsHod3QVW7Yaa0e+/Vzr8TEGNBFzP4B
         sbl8C8x8k1+8SqwsQfFg8v+BdfGPoYXwHY9sd1K/1+90MbDnoHmDeKvNSBZWOiKFJF
         exQqHFgs9hRBQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1C7C760A9D;
        Sat,  7 Aug 2021 08:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bonding: bond_alb: Remove the dependency on ipx network
 layer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162832620711.3915.3761135941956470283.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Aug 2021 08:50:07 +0000
References: <20210807054336.1684-1-caihuoqing@baidu.com>
In-Reply-To: <20210807054336.1684-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 7 Aug 2021 13:43:36 +0800 you wrote:
> commit <47595e32869f> ("<MAINTAINERS: Mark some staging directories>")
> indicated the ipx network layer as obsolete in Jan 2018,
> updated in the MAINTAINERS file
> 
> now, after being exposed for 3 years to refactoring,
> so to delete the ipx net layer related code for good.
> 
> [...]

Here is the summary with links:
  - net: bonding: bond_alb: Remove the dependency on ipx network layer
    https://git.kernel.org/netdev/net-next/c/f9be84db09d2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


