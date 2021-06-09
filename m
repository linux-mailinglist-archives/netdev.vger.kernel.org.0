Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A253A200D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhFIWcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229823AbhFIWcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:32:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D587D613E7;
        Wed,  9 Jun 2021 22:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623277805;
        bh=QWCKAHO0CNrjgOo0eReymPCujh1c4oAWYleJbtocMKs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qV706oLhbXkHMohHXsIY5TrzNXaRuEjvV/d/65qB+T4oh/hZ5au6mzt9E0gQR12qe
         1h3E8I+fZThB9K8hQuCFiE+78nFRT1khRStiBothGgAaRkcuWiOtp835Ksm6SPpYcs
         w1wuBWl0gErN4IjmTl83cfUaUQinMU4jj2JUgTYzZPCAVXE6vlIGelENJ6B1IL8OQx
         nSJX1D1+eHHk9UBYu/bF5sK98KdSacZoPJvJQZTcWwSk5cmAShH/vfVoIuIcy0RvIX
         4bsY1h97kzS5qd9S6ACDpz8tSPYlNoyBEHg7kSRnDJbfB0rby42k0BYeb4CXUGyKru
         9+9bBW7PoEqlQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C581C60A53;
        Wed,  9 Jun 2021 22:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: Use
 devm_platform_ioremap_resource_byname()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327780580.20375.14239563650513959933.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 22:30:05 +0000
References: <20210609133655.2710031-1-yangyingliang@huawei.com>
In-Reply-To: <20210609133655.2710031-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 9 Jun 2021 21:36:55 +0800 you wrote:
> Use the devm_platform_ioremap_resource_byname() helper instead of
> calling platform_get_resource_byname() and devm_ioremap_resource()
> separately.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: stmmac: Use devm_platform_ioremap_resource_byname()
    https://git.kernel.org/netdev/net-next/c/3a5a32b5f2c1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


