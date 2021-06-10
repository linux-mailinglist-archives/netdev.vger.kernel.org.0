Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008833A3522
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhFJUwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:52:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230301AbhFJUwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 16:52:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D8B7B61425;
        Thu, 10 Jun 2021 20:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623358206;
        bh=Kq6vS+dxuSOUD4aiQWVJAC6KNp37ohwY7Zwugu2VPEY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QpvaHMox5WNIN3JsNUDPyFyKt0kgk6tfHYQZVZCp8CM4xdIGgvNEY/0eNWNyITc6Q
         1SvZcc7/MqvTKTRsFBbF2mxqYTo5v8WRxAJLxGrU1p6Qu5cpUGgNiMtseqcTYbpsNn
         3nA1x1ToSU/QThbyG92Z/NBCdPp6E1QUhKPVPVS3Ul850VHbSPswD01EEMI2uudouT
         VeV6mZIdU7LN9ewcl6TpHrMkMVHO5QGkHpcm73N5VW3ZU6NELg3T2SsBCGN5bjHKEu
         afiLxl68FqF+QXSeMdXAvE90KMkgj6EtBQN0En/fX230CZ2W37RY9cnS8JLIJ+6CvT
         PObEivwMI+roQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D231C609E4;
        Thu, 10 Jun 2021 20:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] vsock/vmci: remove the repeated word "be"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335820685.975.745329193860983412.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 20:50:06 +0000
References: <20210610011159.34485-1-13145886936@163.com>
In-Reply-To: <20210610011159.34485-1-13145886936@163.com>
To:     None <13145886936@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  9 Jun 2021 18:11:59 -0700 you wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Remove the repeated word "be".
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  net/vmw_vsock/vmci_transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - vsock/vmci: remove the repeated word "be"
    https://git.kernel.org/netdev/net-next/c/268551503d66

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


