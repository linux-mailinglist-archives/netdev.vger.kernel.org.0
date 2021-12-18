Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900CA479872
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 04:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhLRDa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 22:30:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56448 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbhLRDaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 22:30:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CC1EB82B7F;
        Sat, 18 Dec 2021 03:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8A3CC36AE1;
        Sat, 18 Dec 2021 03:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639798214;
        bh=xrZ0IYl2uuYAgYqCCFXTCyMYOvziT+KCoxg11VRsNKI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DEQ1/UBDTzFDY50A2L0kfRZ5Lr5gP0oC4hE9re47bMqR3eNPI7YuRI+XgLS+HBmTH
         saSO4wUhTqiFIdaoaHdKH7qCztq0wpnsyhJeLX860GvceqGfDt7/olJ8gCBiEf4xrg
         RCgQxjfj+Bm2rdbmWMtCzgzVuDW0rVUV1ZBqg7k9ltcyd8wcyg9tRc7WYt1+9zztea
         MEhO0/v4uVE6joUHrlG6JfXzCCnjg8qdUbLhAf6/X+3remCdNz+0xHK8WJtQxwyDIJ
         Cxevg3AHK872P0Kq0wIxaeTmsS2YxVNZL6/bVrHRdhG335/zQIjfgf4vLqe4h0iLkU
         6QcG+9sAUc3DQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A6C2660A25;
        Sat, 18 Dec 2021 03:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/1] net: lantiq_xrx200: increase buffer reservation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163979821467.17814.14848229230070411043.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 03:30:14 +0000
References: <20211217000740.683089-1-olek2@wp.pl>
In-Reply-To: <20211217000740.683089-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 17 Dec 2021 01:07:39 +0100 you wrote:
> Changes in v3:
>  - Removed -1 from the buffer size calculation
>  - Removed ETH_FCS_LEN from the buffer size calculation
>  - Writing rounded buffer size to descriptor
> 
> Changes in v2:
>  - Removed the inline keyword
> 
> [...]

Here is the summary with links:
  - [1/1] net: lantiq_xrx200: increase buffer reservation
    https://git.kernel.org/netdev/net/c/1488fc204568

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


