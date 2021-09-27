Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A02B41943D
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 14:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbhI0Mbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 08:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234293AbhI0Mbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 08:31:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2D814611BD;
        Mon, 27 Sep 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632745808;
        bh=S7Qf+eY+3sMPl8OAdZulqtSlPcsoZZspMj6T5mrlZRg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ThDLPtDE9nJ4y7Ggv10uu1J/VQwBm28dlI6ifPjmX4GX6TuoMxrBC7LWnE4n9mrVN
         qfaTA7BrpvEZrkIbXXpU9nV3CYB65gNdH8CVZXYeVc/rI95mUquwBEYRS2cR90zX9y
         YABNtTlgJaeqBchKZ5xmpWTsldPy4juT1KoGrIQ7YUbLdNLMPSxjrNDPmS/G/AelXS
         qVDLrVSVOdZnSZvzym47+MQZL5J/QDNNZJc6pwOE7RSZejhpZ32vXrQZX0R0fE7efz
         Wb8+HBctMptpZ3l1/AD5kMizRVrWXWe9YXmz372LK73uFD1LQfqDXAL3FujBhgPatu
         Xfc1Ykb0bv6/A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2328A609CF;
        Mon, 27 Sep 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] net: ethernet: emac: utilize of_net's
 of_get_mac_address()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274580813.1790.3965607855360646825.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 12:30:08 +0000
References: <20210926095648.244445-1-chunkeey@gmail.com>
In-Reply-To: <20210926095648.244445-1-chunkeey@gmail.com>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 26 Sep 2021 11:56:48 +0200 you wrote:
> of_get_mac_address() reads the same "local-mac-address" property.
> ... But goes above and beyond by checking the MAC value properly.
> 
> printk+message seems outdated too,
> so let's put dev_err in the queue.
> 
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v1] net: ethernet: emac: utilize of_net's of_get_mac_address()
    https://git.kernel.org/netdev/net-next/c/584351c31d19

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


