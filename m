Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECF33A07F2
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbhFHXmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235564AbhFHXl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 19:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 20657613B1;
        Tue,  8 Jun 2021 23:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623195606;
        bh=q72ndriQuNhMctYxCvTjBCrXHEj/wsWqW4F77L8T5SU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lXOmg8ICwxh9fur1FIP/N+RsZqbJPD7mXlWwGYRUKa+Xv3mW5VWt5NaDdjpd+pqu+
         18kLfhelV9rrvFMbVaM77FvWJmcQPtUZ5pdKgcOXBSgoMNqpdVx1AFfo0KyF5PuhnC
         ptaykaMlpQlo1PO34FGOmtkGvIzdsrhBXmTUEkioDmnWU89qrzrkLyENPQcPS99pqG
         EfrUJ1BKzrik2yhgAlH8zhJJbmaNwPXHcKy3ZEeJj72xB4hscUH4/VmsXrp3yCBp22
         qKRBsHaOkp9eYyOSJcRfsLebx2AkUen7rc7Tc56YRenlz5j+TUN4hr3/rVzgZUFgtC
         hQs09SdEB09AA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 13C9C60CD8;
        Tue,  8 Jun 2021 23:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: qede: Use list_for_each_entry() to simplify
 code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162319560607.24693.65968810690397697.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 23:40:06 +0000
References: <20210608075737.52085-1-wanghai38@huawei.com>
In-Reply-To: <20210608075737.52085-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 8 Jun 2021 07:57:37 +0000 you wrote:
> Convert list_for_each() to list_for_each_entry() where
> applicable. This simplifies the code.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  drivers/net/ethernet/qlogic/qede/qede_rdma.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] net: qede: Use list_for_each_entry() to simplify code
    https://git.kernel.org/netdev/net-next/c/36861d1f0408

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


