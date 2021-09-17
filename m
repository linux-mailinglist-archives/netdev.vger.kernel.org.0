Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18F140F922
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239861AbhIQNbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232579AbhIQNb3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 09:31:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6E19561019;
        Fri, 17 Sep 2021 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631885407;
        bh=qnIIqWOmKutzY1XX628/2eCqZHLEwUMBR1qnwxU+1v4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lwC5pnXwYiXiKC8o6Mk4Lto+PJwi8D5EKtnYgB6mdWIRYHiIG2p4TUz3tgOQ7Xboc
         1GFRxtTDWnw5s1v0HFpoD4zSRxzeqiPVhxcGIOjQd5PW4tM91gZAk+HNobAniw8Se7
         6uvKq1JzZqg+ZgC6EM6EODa+C4hVS4Y997e2Mzi+pFzjXpSR0qCHBz/lqMrdaycEV1
         zcUkTiZqwJzDfgXBZ6E0O6ErJBWD1OP+Afy8gUqffSz3ztYygzjmWkfcWrD/0eUSha
         8dEHVxSYR+SvW/9rZ6xDSmvjRi9tQ94LwcbLuJ8RSildmpjua9nmJck+6O5m7rwkEi
         p4vhSckNjYY1w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 629CA60726;
        Fri, 17 Sep 2021 13:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Fix array overrun in
 bcm_sf2_num_active_ports()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163188540739.4005.9639402799182516075.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Sep 2021 13:30:07 +0000
References: <20210916213336.1710044-1-f.fainelli@gmail.com>
In-Reply-To: <20210916213336.1710044-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        rafal@milecki.pl, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 16 Sep 2021 14:33:35 -0700 you wrote:
> After d12e1c464988 ("net: dsa: b53: Set correct number of ports in the
> DSA struct") we stopped setting dsa_switch::num_ports to DSA_MAX_PORTS,
> which created an off by one error between the statically allocated
> bcm_sf2_priv::port_sts array (of size DSA_MAX_PORTS). When
> dsa_is_cpu_port() is used, we end-up accessing an out of bounds member
> and causing a NPD.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: bcm_sf2: Fix array overrun in bcm_sf2_num_active_ports()
    https://git.kernel.org/netdev/net/c/02319bf15acf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


