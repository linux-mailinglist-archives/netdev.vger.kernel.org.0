Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A633688E2
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 00:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239667AbhDVWKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 18:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236877AbhDVWKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 18:10:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 791F46143B;
        Thu, 22 Apr 2021 22:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619129410;
        bh=j5/03LAUos2Czq6mNAYoi+CmTfpJcF+6c8XNEkPXF7c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BzbgH8vao/nDq5jOjXXnHBPtUX72W8dU6dWZ7ICnfr4zpU/wt+K7qnFTSioIzlQup
         ea0GLzKCz8b/Kg7xPcn9C0jbOlFKpA7/zAePwAHwhkdwD8DkVKl63GE48QQ5WPoKGX
         Ha31bEaGCPY3Fe6azZGS13pxZbqmzsdgf2Dss4NF7rcLpSgMD31k4MlEzHS5sN3pRX
         Nel8WpE6D5Hw1gJ9nYglL2tsVfU4b5VxHjE8YfEwvf1DDuG6SEJEHbgB8FA4hrQ5uA
         N+Dz8u4UTd+mHYFOeSM5pnMvHmvXhC4Rce4KRcaA5Sqv1KjI5g5UlRXbTpL6a2MvtN
         GiT2nK0n83y1A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7199660A53;
        Thu, 22 Apr 2021 22:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Enable DWMAC HW descriptor prefetch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161912941046.2979.7304318952227636688.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Apr 2021 22:10:10 +0000
References: <20210422075501.20207-1-mohammad.athari.ismail@intel.com>
In-Reply-To: <20210422075501.20207-1-mohammad.athari.ismail@intel.com>
To:     Ismail@ci.codeaurora.org,
        Mohammad Athari <mohammad.athari.ismail@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, Chuah@vger.kernel.org,
        kim.tatt.chuah@intel.com, boon.leong.ong@intel.com,
        weifeng.voon@intel.com, vee.khee.wong@intel.com,
        tee.min.tan@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Apr 2021 15:54:59 +0800 you wrote:
> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> 
> This patch series to add setting for HW descriptor prefetch for DWMAC version 5.20 onwards. For Intel platform, enable the capability by default.
> 
> Mohammad Athari Bin Ismail (2):
>   net: stmmac: Add HW descriptor prefetch setting for DWMAC Core 5.20
>     onwards
>   stmmac: intel: Enable HW descriptor prefetch by default
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: stmmac: Add HW descriptor prefetch setting for DWMAC Core 5.20 onwards
    https://git.kernel.org/netdev/net-next/c/96874c619c20
  - [net-next,2/2] stmmac: intel: Enable HW descriptor prefetch by default
    https://git.kernel.org/netdev/net-next/c/676b7ec67d79

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


