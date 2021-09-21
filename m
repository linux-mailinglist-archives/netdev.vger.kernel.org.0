Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B2A413146
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 12:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhIUKLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 06:11:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhIUKLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 06:11:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A83BA61100;
        Tue, 21 Sep 2021 10:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632219007;
        bh=PMAeaicUTYi6o6ZXUcVCInx3d/yovPLk9nPu80nClUY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EYhDnY6DJaMDdqbLWqNDaJay2MrSQ3eESIGJJn01YzRSDpMaDQyj7iFA4PQUqi17+
         /pLVBYoTGaM7ltR2IMe7LumDyYqK2D2+DjzRMtHR+vK1bSZwkJ8b2vTQ8OcJDSPnSk
         tBAbkl4NN9nBgvAiPfKhd6NsJ6Jlvye+2c0Get1qVkTvkTLyzrKSKvoqCm3dylE2fO
         vME1vct1T5ClGzm1QMobPnohSgX85vGCcq5yVk8CdeUbc35d40D9hBHw1NOVxnKQJK
         yO/6qQoZT7kxBdfbXBWxQQc12LRoitAmprFpQOPkosg/yV4n9y6+etQUAPNHzI+atN
         z8jRaV/oHmmVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9935D60A5B;
        Tue, 21 Sep 2021 10:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net/smc: fixes 2021-09-20
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163221900762.14288.11996039064069209042.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Sep 2021 10:10:07 +0000
References: <20210920191815.2919121-1-kgraul@linux.ibm.com>
In-Reply-To: <20210920191815.2919121-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        guvenc@linux.ibm.com, jwi@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 20 Sep 2021 21:18:13 +0200 you wrote:
> Please apply the following patches for smc to netdev's net tree.
> 
> The first patch adds a missing error check, and the second patch
> fixes a possible leak of a lock in a worker.
> 
> Karsten Graul (2):
>   net/smc: add missing error check in smc_clc_prfx_set()
>   net/smc: fix 'workqueue leaked lock' in smc_conn_abort_work
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/smc: add missing error check in smc_clc_prfx_set()
    https://git.kernel.org/netdev/net/c/6c9073198065
  - [net,2/2] net/smc: fix 'workqueue leaked lock' in smc_conn_abort_work
    https://git.kernel.org/netdev/net/c/a18cee4791b1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


