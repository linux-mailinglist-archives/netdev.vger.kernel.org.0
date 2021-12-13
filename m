Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D861472FEA
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239652AbhLMPAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:00:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57820 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234277AbhLMPAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:00:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 799046113D
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 15:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D19AEC34605;
        Mon, 13 Dec 2021 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639407609;
        bh=PARl/2itXtWkl7H6+ADVKMm1UFj6CSvJnEGasS6PREE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PBJlssb9zYlHcDvigMRx7SEat2HrXdzFZPTZu5XGw5NVzRH/RudQuLtaMlclfkRgZ
         ePGCaQYi8W7ZIe6z+RH1TBBywYlFaJYsRNpN6z1ysD7rZ4WBvzrO4N87WKZ7wO7jLS
         tT9fphPJhK7I5bCx6Tebvsv7NlR0at6QfqOhAlTeo49aoAPLw15CbxeuUYuphlSs7D
         G6b25p1MOJSJPSUCacjSWxEUWJqd0ZWjGr1w5usseaYKn569uOlNJc3d2LHhZ5VE8n
         se58d2Ha9T3vKwOuVcDeAI/15L7RXR2rLz+U9kRXJJocSECxbQ+M5XWtZSc6kss0Hg
         AQvkGFIIO90wQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AA921609F5;
        Mon, 13 Dec 2021 15:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftest/net/forwarding: declare NETIFS p9 p10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940760969.26947.7675700664864499679.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 15:00:09 +0000
References: <20211213083600.2117824-1-liuhangbin@gmail.com>
In-Reply-To: <20211213083600.2117824-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, ssuryaextr@gmail.com, idosch@mellanox.com,
        davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Dec 2021 16:36:00 +0800 you wrote:
> The resent GRE selftests defined NUM_NETIFS=10. If the users copy
> forwarding.config.sample to forwarding.config directly, they will get
> error "Command line is not complete" when run the GRE tests, because
> create_netif_veth() failed with no interface name defined.
> 
> Fix it by extending the NETIFS with p9 and p10.
> 
> [...]

Here is the summary with links:
  - [net] selftest/net/forwarding: declare NETIFS p9 p10
    https://git.kernel.org/netdev/net/c/71da1aec2152

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


