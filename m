Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A554360CD
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 13:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhJULwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 07:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230283AbhJULwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 07:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CEADF6120F;
        Thu, 21 Oct 2021 11:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634817018;
        bh=JP1quhkdEzHDL4xb+/DDyPpSrWE+O2f4WUT2c/+zgNA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jojah4LLiHqhdaZpK7+zILD3Evj+wZNR8M4DuJoExoD8iZamY5IsxU3YCxVBjlz1r
         b85KToxip75M7KWaK3OXBoHeF7rY4w1KoklpeD25CJdYkpHmEjsUAs2+J1+Wwb8uRB
         qAEST/stcswrOssNwDMqi9bRHoH4ye/R1ZNF9mhWy8yDP/oVNkcIDT4Kv8TVP8Kcjf
         zVHf5CeFhTPkJzfjGCFu4pm1GsHCPWwS5lAi7+BoytlmH5x1rf0hdYnLRFHBpTFot+
         ISMsQaNr4faq3F7gKIVmlaFqyXKq7z8eDr9v1iIISyJ7ugJxtTG81sXuJXSnc+4tpP
         SaIKon1JMQIiw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C330E60A44;
        Thu, 21 Oct 2021 11:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH linux-next] net/core: Remove unused assignment operations and
 variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163481701879.17414.1936555049952735789.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Oct 2021 11:50:18 +0000
References: <20211021064020.1047324-1-luo.penghao@zte.com.cn>
In-Reply-To: <20211021064020.1047324-1-luo.penghao@zte.com.cn>
To:     luo penghao <cgel.zte@gmail.com>
Cc:     horms@kernel.org, davem@davemloft.net, kuba@kernel.org,
        sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo.penghao@zte.com.cn,
        zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 21 Oct 2021 06:40:20 +0000 you wrote:
> Although if_info_size is assigned, it has not been used. And the variable
> should also be deleted.
> 
> The clang_analyzer complains as follows:
> 
> net/core/rtnetlink.c:3806: warning:
> 
> [...]

Here is the summary with links:
  - [linux-next] net/core: Remove unused assignment operations and variable
    https://git.kernel.org/netdev/net-next/c/50af5969bb22

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


