Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC891397D7A
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbhFBALv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235227AbhFBALu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 08108613BD;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622592608;
        bh=C1bHIjOsce3moUr9AU5OrvDMU78bOQydXsXi1ezxIzY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hwRblHkrZIteVkOrXjzg6Q8gjudjz1aYuDKo0Rp7qxzEJW4Czg4SsTE/C6gz1Vxnw
         xaNZkam5fmWkjjQm3n8dclGvOW08i17pBUCcMjpL0DjNTuN/Vx3U/5wyLFubSdXBam
         e1QXiTGeZJEckiVCP23kd0ELd3IO0rd1B3mJf6h2Gm42Ot2cFHlZRe+IiiR56tqLL1
         5on7F/oWOOav595QgPJeqPrTR+GWxZRlJzER+UCSPDCzO2tYfHZcuH0J0AD5SQ7y2/
         y//UPPUZUgbIb++XZy1dG8kLdjF9i+I+Y0C4bvalHB6DKh8SGWdZQ8bwiwuqvcdReL
         Jj7Z8zwGkIUbg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EA248609EA;
        Wed,  2 Jun 2021 00:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] cxgb4: Fix -Wunused-const-variable warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259260795.22595.15856434703843544094.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:10:07 +0000
References: <20210601140148.27968-1-yuehaibing@huawei.com>
In-Reply-To: <20210601140148.27968-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 1 Jun 2021 22:01:48 +0800 you wrote:
> If CONFIG_PCI_IOV is n, make W=1 warns:
> 
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3909:33:
>  warning: ‘cxgb4_mgmt_ethtool_ops’ defined but not used [-Wunused-const-variable=]
>  static const struct ethtool_ops cxgb4_mgmt_ethtool_ops = {
>                                  ^~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - [net-next] cxgb4: Fix -Wunused-const-variable warning
    https://git.kernel.org/netdev/net-next/c/6990c7f44c0d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


