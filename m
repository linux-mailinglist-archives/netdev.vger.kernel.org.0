Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D64F466470
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 14:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358237AbhLBNXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 08:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346690AbhLBNXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 08:23:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF86C06174A;
        Thu,  2 Dec 2021 05:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CB8E6CE22F3;
        Thu,  2 Dec 2021 13:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 089D6C53FD0;
        Thu,  2 Dec 2021 13:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638451209;
        bh=FumrJ/YM5Tmvh6PskMj7ULn7mzKvvTLOBYxmiIEYsfk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JcKzdo/En+3K3YyN611929yMqd+c3PBTyuaeZzOxpGy+WyFHShwp4YDmYTxzaZmti
         GwOs+nnsx0pT5yhILeDLSGui3lRrkbc9K6Nq1lhlH24198OZsQokmk+VbnnT7H3Lyj
         vM7s1peCmfaQCWzgUREBpdeMgxh1posGcthvwtXldBvHd70CF2qDs3cpatSrkafYRu
         Qwtes9Aq2VwMloSKw/yyelmFHbFR9fzJwI31JBmOfh0awV0aFalC/rinUO5RzA6PnX
         y6FtxlVJjFGgo1zt/EYgvdPO1QGQ+SNkv/vpbS7kxkZKHqdybTHsMCp5QdDNT7Exn8
         qH+C5CsPcWF6A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E508260A90;
        Thu,  2 Dec 2021 13:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mctp: Remove redundant if statements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163845120893.3424.12191746234187548358.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 13:20:08 +0000
References: <20211202075535.34383-1-vulab@iscas.ac.cn>
In-Reply-To: <20211202075535.34383-1-vulab@iscas.ac.cn>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     jk@codeconstruct.com.au, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  2 Dec 2021 07:55:35 +0000 you wrote:
> The 'if (dev)' statement already move into dev_{put , hold}, so remove
> redundant if statements.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---
>  net/mctp/route.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - mctp: Remove redundant if statements
    https://git.kernel.org/netdev/net-next/c/d9e56d1839fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


