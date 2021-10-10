Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D6B428088
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 12:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbhJJKmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 06:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231466AbhJJKmF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 06:42:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ED23F60F43;
        Sun, 10 Oct 2021 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633862407;
        bh=Njz24tDrGGLBjNrmKhZwPlnlCzn14JIrYewDsz1RoeI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RaBMknVLyS1o0q7oK+YWh3Mg6xUsjkEwGnATnzxNqhVCrcZUthg36zQYNx1Juqva8
         JitrpmFxwwq7ZZqg4Dp4J9Wouo1iX0oXQ5uKa0bFo5kxQfy+IQBAOM41Uz5CB6EhAS
         s7y1t/7zpWZ3/5+rjVqoaHLEMTLWwYY3Uh3G+HAg9BQaUdy1AOZYBe9x5lj5Nh8i4X
         tE4432ChVKqeYczfM6sdnAMiJo0kl+eXU5NJx3UVenhCc7uoFgGkeqprrfPmTMppbO
         VvtilAw4gvHaSr8wiJOi1PQ3XC6GF4DwWKeTgpJIbW8KmCENB5TOJ/RyYWaWiiSUiQ
         p/WBnd+YIXmHQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DC67060A88;
        Sun, 10 Oct 2021 10:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: make dev_get_port_parent_id slightly more
 readable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163386240689.21532.11221462758627770247.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Oct 2021 10:40:06 +0000
References: <20211008142103.732398-1-atenart@kernel.org>
In-Reply-To: <20211008142103.732398-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Oct 2021 16:21:03 +0200 you wrote:
> Cosmetic commit making dev_get_port_parent_id slightly more readable.
> There is no need to split the condition to return after calling
> devlink_compat_switch_id_get and after that 'recurse' is always true.
> 
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  net/core/dev.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [net-next] net: make dev_get_port_parent_id slightly more readable
    https://git.kernel.org/netdev/net-next/c/c0288ae8e6bd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


