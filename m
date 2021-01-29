Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFEB30853B
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 06:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhA2FbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 00:31:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:56120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230367AbhA2Fav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 00:30:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A463564E03;
        Fri, 29 Jan 2021 05:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611898210;
        bh=sJbJyDuXG+KD95hXZRIFRBsNV57FMPgIzkwIBQnmf/E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FI2gMyoikjrotKRz7DittbAp7D9KaPdg2mLjWloL00ZuMQlUF37X8RbKFwdASoxH+
         mOqIgM1/woFaq2U231k9o5bZK/SojeG3IZM95eaB/QgizFFeTto/SqsP4F4K3UIi3O
         4qd1cGYcDDRMsxOUmBM4emaweEmg1ekSFwoDrXyAEdlJsQ+EdzlEay9hEv6WYyWnVU
         758w1HuMp1S6Iq/+aohQUpWsikF3XA3UEZO5PTdnjSlWbNvcGtiIRlMqjyiYO9HGgz
         1l86p+ghGsKAwo56sTX77iNIX6hwqdkwo3iU+Yl4DlsOXhkb87fcvyQ7hoqxqa+rP8
         m0NSZGHY+/zGw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8F2F561E39;
        Fri, 29 Jan 2021 05:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] linux/qed: fix spelling typo in qed_chain.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161189821058.14150.16474323318775061741.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jan 2021 05:30:10 +0000
References: <20210127022801.8028-1-dingsenjie@163.com>
In-Reply-To: <20210127022801.8028-1-dingsenjie@163.com>
To:     None <dingsenjie@163.com>
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 27 Jan 2021 10:28:01 +0800 you wrote:
> From: dingsenjie <dingsenjie@yulong.com>
> 
> allocted -> allocated
> 
> Signed-off-by: dingsenjie <dingsenjie@yulong.com>
> ---
>  include/linux/qed/qed_chain.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - linux/qed: fix spelling typo in qed_chain.h
    https://git.kernel.org/netdev/net-next/c/1d3f9bb1be85

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


