Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513F63A3501
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhFJUmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230197AbhFJUmE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 16:42:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9805461428;
        Thu, 10 Jun 2021 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623357607;
        bh=GkW3FMSRebVwG0VXHh5XXOrSk5k9aOCWIBDa5A7gmbM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EKKSpmw36pEfZtx/4MCi+RLJh3BcAfmCU1FYPYTq/O3tQRht76tOcsHjVQPqegvUE
         2YtBUX452KUdfYdN8qWgEtfeoSYbDMygmy/yb362TtPJSJhBEQzJlbT34YqmmqOxoc
         4M6QzwXhlz75mhzfv5t6Zb3DX8T3DjuqBcxgu2R22eUn9Gr2s1DCSENCr7dRkRPAbl
         XiO2aY2bxXmVNjLKVtvUQevtQIpYBtLA9POvIMeupJUY9W05/mHPa16WNmGJXUtnbi
         I4Jm1zcQoXsBz6g2jdOC3kvR01EhWBfsaOvPqxuMDXdqLcoTcgpBWsgGxj2AqX+BI1
         e6V6XfT9NwA+w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8B52A60A6C;
        Thu, 10 Jun 2021 20:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ti: cpsw: Use
 devm_platform_get_and_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335760756.27474.14371403331301411538.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 20:40:07 +0000
References: <20210609140152.3198309-1-yangyingliang@huawei.com>
In-Reply-To: <20210609140152.3198309-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, grygorii.strashko@ti.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 9 Jun 2021 22:01:52 +0800 you wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/ti/cpsw.c     | 3 +--
>  drivers/net/ethernet/ti/cpsw_new.c | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] net: ethernet: ti: cpsw: Use devm_platform_get_and_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/aced6d37df79

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


