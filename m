Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6953E352363
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbhDAXUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235909AbhDAXUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D3D3861152;
        Thu,  1 Apr 2021 23:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617319209;
        bh=a4J8hSWn61N2uanLnkkW2W+XHIHI96a+n0os9TlOm8w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O7B4FQ9zLxHsKWBCGBoXUrWRvbETAoWq1BVcze/eEi78rujoiJzrqcwVwiAJZ1U2Q
         U+93+eBJeIjgFpDByOPxfwzAWU6omLQIekurDctYbdtUS0B4D/OfKi2y0KPlGMvHmj
         ob3KtjsO6rdu/XYTe/aQq2PMBa7rbR439iEuOa3UV8FxE6+U1K/jbXTHUX1TF84NET
         gqrMB++qa16uzFryWUhoQkbKQRmnRf6wwA3XELdXb87O6bJdVQ7v01EnS9sJlTpLst
         z8xc6hYcd89LT8OiEIRQhJGrAdEb9lR/e1K2LRJXRBfy5mCMO+szO9fThd+HVKC6cu
         SlXzaV2P1W7gQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C409D609D2;
        Thu,  1 Apr 2021 23:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] include: net: Remove repeated struct declaration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161731920979.16404.5049234780996551334.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 23:20:09 +0000
References: <20210401070823.994760-1-wanjiabing@vivo.com>
In-Reply-To: <20210401070823.994760-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  1 Apr 2021 15:08:22 +0800 you wrote:
> struct ctl_table_header is declared twice. One is declared
> at 46th line. The blew one is not needed. Remove the duplicate.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  include/net/net_namespace.h | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - include: net: Remove repeated struct declaration
    https://git.kernel.org/netdev/net-next/c/9fadafa46f48

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


