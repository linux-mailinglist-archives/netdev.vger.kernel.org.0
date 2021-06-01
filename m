Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EE9397C47
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234964AbhFAWLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234950AbhFAWLp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 18:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9C902613CD;
        Tue,  1 Jun 2021 22:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622585403;
        bh=Xjq0JbqNS31xw+qPkNAjtjbfrXlHOk2D6DeDOTUxbiI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LpcP68UscfDdGPdIMsi8sLgIRDjUhUbiprzYrQJI4Tb/3pu1UJso0TRIrm+lzVDpg
         w3NYrJIc2B04/UR4Zsf17/+QpdG/69Lq7ZyUSVtMG6Q++hVYq6OBRXowOFtC8uDJBC
         AVLFSF96lmjDfnA3VS31aEcCaGREbl2EDPMh0Mj0pFFwUFdW3rr/jSaXiBxPCqbzua
         kvRrkVnESkWg2QymrpZkUSYZ+y7xo93OYpR6Q0bUGGj6+GHPcKsTFycvuNpaQWbVce
         cDdiyu18RRH1AJxCB+5nn5fiK85Fd1w38LKSxu3Q7wkisSmEU4oMILekH1jWR2xgV8
         mY0gT1B1py4xA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 970A960A6F;
        Tue,  1 Jun 2021 22:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: neterion: fix doc warnings in s2io.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162258540361.3374.10264933082153649257.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 22:10:03 +0000
References: <20210531124859.3847016-1-yangyingliang@huawei.com>
In-Reply-To: <20210531124859.3847016-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jdmason@kudzu.us, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 31 May 2021 20:48:59 +0800 you wrote:
> Add description for may_sleep to fix the W=1 warnings:
> 
>   drivers/net/ethernet/neterion/s2io.c:1110: warning: Function parameter or member 'may_sleep' not described in 'init_tti'
>   drivers/net/ethernet/neterion/s2io.c:3335: warning: Function parameter or member 'may_sleep' not described in 'wait_for_cmd_complete'
>   drivers/net/ethernet/neterion/s2io.c:4881: warning: Function parameter or member 'may_sleep' not described in 's2io_set_multicast'
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: neterion: fix doc warnings in s2io.c
    https://git.kernel.org/netdev/net-next/c/0bf4d9af2efe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


