Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B083F4931
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236367AbhHWLBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236254AbhHWLAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 07:00:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CF4036138B;
        Mon, 23 Aug 2021 11:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629716405;
        bh=Ikhc8tu0qcR9oQ+OhMO9QJXM01eNb0Fr+KVga4JK3Yc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aIolGCdNrhzyEe3SDJP9ymLwl6PCU0Vp1ib7BB40HQewFKfeQgerhjXeBKGqfFYzz
         ncGDWb8Bu+aOEHptpodfVSiyq2VYFoPcupKLJDDmQzqcsRrQoLIC08o2graRBlvWmK
         z4/IdHFwtwbI5sj0AvLF++aWOOlDPejGjqJ0BudRvqWwUQLUrkjg5qwCjkGzXjtmAF
         JVU2AVOomZxWAZjaPoY9Q+umSab/52HiqXZrBLYI+bMvW7Oy9AvtM7Ym8ZL4JKHxQq
         o0ZyDDziashoWfbWMKYQW/DBKRKYrnwJwyHVO1SReMfX2CU6JRvkC4f/UHIHR+ATta
         /kOi1Ot5MfuIg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C147C60075;
        Mon, 23 Aug 2021 11:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: fix kernel panic due to NULL pointer
 dereference of plat->est
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971640578.3591.684307191157307528.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 11:00:05 +0000
References: <20210820132622.4175839-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210820132622.4175839-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 20 Aug 2021 21:26:22 +0800 you wrote:
> In the case of taprio offload is not enabled, the error handling path
> causes a kernel crash due to kernel NULL pointer deference.
> 
> Fix this by adding check for NULL before attempt to access 'plat->est'
> on the mutex_lock() call.
> 
> The following kernel panic is observed without this patch:
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: fix kernel panic due to NULL pointer dereference of plat->est
    https://git.kernel.org/netdev/net/c/82a44ae113b7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


