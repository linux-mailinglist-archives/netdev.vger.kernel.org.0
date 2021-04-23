Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DE4369BB7
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243797AbhDWVAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232657AbhDWVAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 17:00:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2546261075;
        Fri, 23 Apr 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619211613;
        bh=V70RhErbBzFuXbKLEaoLK/tys5yhalQiMWbd0AiSmME=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QBM6+3/yDP3zOzmdVEvo3M87/E5m/wvOMcsQ/HBUHAO652ePLi+oLfTvM7GLmmkVx
         MyF/I1fbXBWg2kOLJynQ7fmetq/1837OOq0WQ3/pgHvsbf2QdLWOove7Rcch8HWPAG
         wkYLZ63KJYCaroZDHXiWirOpvG+Zs04fEd4Y3Zv/P7zaclBdTgZtRgB5AwWTkttwD1
         A6MJsGkcNBIeTcxKW9DYxl0NAqmgY0fPymQuVdmNzCJa3jCNVEuzpKv46O6ESA374U
         ZMcNijZQPLlwyFHx/nBfZGjqaxDZnDzpl5du69SSHEaOrGr5kERTVecwIResZvVHNm
         DkXgcuLdfwa5g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1C4CA608FB;
        Fri, 23 Apr 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request (net-next): ipsec-next 2021-04-23
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161921161311.19917.1849606365072790152.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 21:00:13 +0000
References: <20210423081409.729557-1-steffen.klassert@secunet.com>
In-Reply-To: <20210423081409.729557-1-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Apr 2021 10:14:05 +0200 you wrote:
> 1) The SPI flow key in struct flowi has no consumers,
>    so remove it. From Florian Westphal.
> 
> 2) Remove stray synchronize_rcu from xfrm_init.
>    From Florian Westphal.
> 
> 3) Use the new exit_pre hook to reset the netlink socket
>    on net namespace destruction. From Florian Westphal.
> 
> [...]

Here is the summary with links:
  - pull request (net-next): ipsec-next 2021-04-23
    https://git.kernel.org/netdev/net-next/c/7679f864a0b1
  - [2/4] xfrm: remove stray synchronize_rcu from xfrm_init
    https://git.kernel.org/netdev/net-next/c/7baf867fef7c
  - [3/4] xfrm: avoid synchronize_rcu during netns destruction
    https://git.kernel.org/netdev/net-next/c/6218fe186109
  - [4/4] xfrm: ipcomp: remove unnecessary get_cpu()
    https://git.kernel.org/netdev/net-next/c/747b67088f8d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


