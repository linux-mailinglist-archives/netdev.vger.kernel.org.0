Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574DE2E03F2
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 02:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgLVBkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 20:40:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbgLVBkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 20:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1011022B43;
        Tue, 22 Dec 2020 01:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608601207;
        bh=2oUzh4p0gvyOP8stSMDkqxV7zbrW/pY2ITzYPOKUKl4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kmPgwcsJ0r+UWvNiHxtMPKiyA3JlL8EZAdJYXFdLywJoR1ItkFAO0uIfWQ3v5ch7n
         HwuocjPokrrsuWO+aq2WmTNA+RtQjT0+aRR9R559n7cjGg9mbxcH7HriLS2IZHSDwI
         b7UUkOKpg2nbkjq/l6GjYlyz1cImLGIaG5TIbe8spxD6Zt/uk+KUFYr6StNJ2bR9Ls
         8qbPUDDicl5Fmcul4xJNYGmwIFmjl1ZNkHxtje1Ht4vyu33pqeBpoDhVv0c6BEN+sj
         f5GBrWkxGtaheCdakTy5B+MRvoPVH5Rr3qWjnf0gdWnLvl9RhkngpMbP8OPuZzaKw1
         ZNSw9ghvufJ/A==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 0079260259;
        Tue, 22 Dec 2020 01:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] atm: idt77252: call pci_disable_device() on error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160860120699.2677.5928345202899803037.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Dec 2020 01:40:06 +0000
References: <X93dmC4NX0vbTpGp@mwanda>
In-Reply-To: <X93dmC4NX0vbTpGp@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     3chas3@gmail.com, chas@cmf.nrl.navy.mil, davem@davemloft.net,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 19 Dec 2020 14:01:44 +0300 you wrote:
> This error path needs to disable the pci device before returning.
> 
> Fixes: ede58ef28e10 ("atm: remove deprecated use of pci api")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/atm/idt77252.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] atm: idt77252: call pci_disable_device() on error path
    https://git.kernel.org/netdev/net/c/8df66af5c1e5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


