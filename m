Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656BA35FD00
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 23:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhDNVKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 17:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229849AbhDNVKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 17:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ABE3C61242;
        Wed, 14 Apr 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618434610;
        bh=HcRxDeZajNQMGip7ZMeWw6+pp2sK72YQ/LG/rNula1g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rSFOffOOYwHZ9Ni/3SbikpTQrF2UswU3lrggWhWRF2Pc7mvz8sNmXWF8ZI1hiZYbU
         WtZ2R0bZ9GM00rW8NCk3GjXNBzIyw3Z9sz2+OtMGC/T9xoOyVWI6xUyXAjTbgGvj0r
         7wmL81UCfrDWBMtHlhffAB3HnxUrX2bkS9ftCfIKYPTRFvH3OKL2Ht2JGXWQLrozgZ
         eiEEcqob2/AGl+4mc6j7DFYuU2vBF++7VM5Q0tPbVb9r/L4lNBo5MhkdESEc67juFt
         rZcYDZpK1bQuAtVuMkGR+YEk8qJEdCKtwm/dle22EexQn9a0pDqWvhWgR+yt7mlaBP
         JSc4Cb4SSeO2Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A541660CD4;
        Wed, 14 Apr 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sfc: Remove duplicate argument
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843461067.4219.1523873245637476439.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 21:10:10 +0000
References: <20210414110645.8128-1-wanjiabing@vivo.com>
In-Reply-To: <20210414110645.8128-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 14 Apr 2021 19:06:45 +0800 you wrote:
> Fix the following coccicheck warning:
> 
> ./drivers/net/ethernet/sfc/enum.h:80:7-28: duplicated argument to |
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  drivers/net/ethernet/sfc/enum.h | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - sfc: Remove duplicate argument
    https://git.kernel.org/netdev/net-next/c/ace8d281aa71

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


