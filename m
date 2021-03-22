Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424323450CE
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhCVUa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231536AbhCVUaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1CAC8619A1;
        Mon, 22 Mar 2021 20:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616445009;
        bh=UgjhHVmm/hWdcOLyKN0kcIDMs7eBK4qgouDuxANgsLU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c49mC3Lp2zwzOKoziaJYyP7GHWg27pgTqcTNQJ4yYYu1E0uUNiSYaW/0nTs+krg62
         R7FhE9eeDelQEQIlGpDNhBAmRg+ouegdjyvYTPgjLpsAklxA1gT5vJBIlJasQtWrAc
         nMV+1ipTc0X1jLffz6iQrVKCl5tzlMKfY6tlT8fO6zIDt67YhXKIbf2vxS5CrsYhrg
         I+cTpV6xhiFAutKT1J5PylKbyqZM/21mOOvvpy/4ZUU9k48ApeJcOrQ7KU+wbEBvbM
         qgVVMmU49F7+MbOv3BMpNeQSkL9sequ+Hqfh4RaL1XLKEFRDjZIuJ+XxmpO2HLoQZ5
         NbodxD77qXEqA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0DCDA609F6;
        Mon, 22 Mar 2021 20:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] [v2] misdn: avoid -Wempty-body warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161644500905.31591.4373157960254531768.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 20:30:09 +0000
References: <20210322121453.653228-1-arnd@kernel.org>
In-Reply-To: <20210322121453.653228-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, isdn@linux-pingi.de, arnd@arndb.de,
        leon@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 13:14:47 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc warns about a pointless condition:
> 
> drivers/isdn/hardware/mISDN/hfcmulti.c: In function 'hfcmulti_interrupt':
> drivers/isdn/hardware/mISDN/hfcmulti.c:2752:17: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
>  2752 |                 ; /* external IRQ */
> 
> [...]

Here is the summary with links:
  - [net-next,v2] misdn: avoid -Wempty-body warning
    https://git.kernel.org/netdev/net-next/c/13e8c216d2ed

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


