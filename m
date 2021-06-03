Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA3C39ADD9
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhFCWV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230421AbhFCWVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4E1476140F;
        Thu,  3 Jun 2021 22:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622758806;
        bh=oPNw3E9r5BFowe59dXKDbegiVJw5GRLneavQSPLKQDI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JBlqh31VucnzJ4myXmKvhC5Up6TBsUtyowPlRDChsORAHyHX2iQNdsnwCQF6UFHOb
         AjERfxDL+v7BNMOsz5sKYMyBvQWGHpP1iOt6TFUNZS0vptg8nNY/g6Za4S2DgRgw/P
         vOaGbEhb4b1QoNeZxn+OLg651ISpsiX+0PJKXDyB690pUNbMaAmUShjXtLFEOCpLNn
         NhCC3Nac1rjHiReQ/UUHaDBYytkdTOUpBwGKiNVNxBbXogu0OeSFkrf1qOme/hT4wV
         5iahXZbWMupQ5Rjr4PfMHePBGGwxeGfWT1CGpIzCAIzoNKyRJ6Zb+SQacn+80YgtKl
         VYu2s5E4NBwjw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 41B8F60CD2;
        Thu,  3 Jun 2021 22:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: Return the correct errno code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275880626.4249.10779943987704215297.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:20:06 +0000
References: <20210602140640.486273-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210602140640.486273-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 2 Jun 2021 22:06:40 +0800 you wrote:
> When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/compat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: Return the correct errno code
    https://git.kernel.org/netdev/net/c/49251cd00228

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


