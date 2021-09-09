Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA03140489B
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 12:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbhIIKlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 06:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229980AbhIIKlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 06:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 25F976115A;
        Thu,  9 Sep 2021 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631184006;
        bh=r1AotUpmZiFC/bmXCaB1Q+D/THLHiQoIH8gZ+gjQ/as=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HUmO1lDqUtnKogFEh0Qvo4fMddTwfwDwJ9WueYDZs5kI8APRXfKQ1gI3FcHbeXFuB
         G/Dvo/CdflRXfa00dd6PmNsED0c03B+7kCQ/EhfvQyaHHU5W0nxax68otbwy71V058
         zYaLM+3fIWA/E+C4cSKV3gxx5lVi6awhS3VYkLrrj5uHsfy5RRicQqfpjIHKWYkPhd
         TbN1hlpI3k9QvlZyI/fRAT0tWmU3sGFhqY3CvCc4isjH4rcZy0tbGH/AhdrbgPhIqX
         DmWAJddoA3a8Fn2iMI7BccZI8nfrH16yp9DKH2/fPfzbZeUN7mt6NsXgwesoIbVJAP
         X97WLwQZIaOfQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1428C609CC;
        Thu,  9 Sep 2021 10:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ni65: Avoid typecast of pointer to u32
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163118400607.20005.10171091198714542576.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Sep 2021 10:40:06 +0000
References: <20210909044953.1564070-1-linux@roeck-us.net>
In-Reply-To: <20210909044953.1564070-1-linux@roeck-us.net>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  8 Sep 2021 21:49:53 -0700 you wrote:
> Building alpha:allmodconfig results in the following error.
> 
> drivers/net/ethernet/amd/ni65.c: In function 'ni65_stop_start':
> drivers/net/ethernet/amd/ni65.c:751:37: error:
> 	cast from pointer to integer of different size
> 		buffer[i] = (u32) isa_bus_to_virt(tmdp->u.buffer);
> 
> [...]

Here is the summary with links:
  - net: ni65: Avoid typecast of pointer to u32
    https://git.kernel.org/netdev/net/c/e011912651bd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


