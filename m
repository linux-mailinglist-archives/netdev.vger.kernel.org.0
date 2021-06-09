Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC75C3A1E77
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhFIVCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:02:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229797AbhFIVB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 17:01:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1ACAA613FF;
        Wed,  9 Jun 2021 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623272404;
        bh=KRaEHOeIFt3A2bYCD1PITT917hPEVETuksrXRWEf5Fo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uwx0eXL4F/k28a3XjoLdn4zFKry57GOl+m0c0peVUjL2z+OdK7EYqrthBnxWljoPC
         IgGDEAD4JSLWjEAkp/ss4b8oHSa/nGcwkTC5w90wT1G5K3qzq3oM0lNgY138fJL0Qx
         DfExudh2N6rjWD753osOsjk/Un6wJ4c/XfxcOv4SMq6UmOVdqu0VwNvVybwz7net00
         ugBjsonChQmBZ5ozeu3nlPATSg+2EUkjE7Eycf79dnhtBaWl1s71VAFVUxe1+Cgy/z
         xki/zRGYuimGlc4+Hm9t/OgJVvw6xgRhZWZ9A565WBU83fcfrCZ7Mb1vlovVmk6T1L
         rwvSgZKk8irhg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1132E609E3;
        Wed,  9 Jun 2021 21:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/x25: fix a mistake in grammar
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327240406.12172.17093746293428659261.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 21:00:04 +0000
References: <20210609030317.17687-1-13145886936@163.com>
In-Reply-To: <20210609030317.17687-1-13145886936@163.com>
To:     None <13145886936@163.com>
Cc:     ms@dev.tdt.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  8 Jun 2021 20:03:17 -0700 you wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Fix a mistake in grammar.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  net/x25/af_x25.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net/x25: fix a mistake in grammar
    https://git.kernel.org/netdev/net-next/c/db67f2493431

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


