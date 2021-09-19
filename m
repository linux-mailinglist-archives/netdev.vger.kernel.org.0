Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7E3410B40
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 13:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhISLVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 07:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230402AbhISLVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 07:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 225796127B;
        Sun, 19 Sep 2021 11:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632050409;
        bh=aeIkJIXEmm7B9ae1/L3fQukM4/3iDBnYEE5trTfm2lw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JX4ERWr29jpQnFwg3r1vJ7veJvdCVp0NuPDRR3XinTEdmF6R44aou82z3U1GOMbni
         41EWBQzqeUT6LpsezQbNQmZeK4YXDjJwQkB81K4cL2nLC/kEDM6m7KZLfcTIpZaDCZ
         VhOswQuuvv204YYXp2/dJco3nZdWnZbWkJd2zppNTAw1B25eGAXlUTkjgDfVggaB/j
         1+82hMAi61gsxUYRgY1iBbYpUC35n1KaaliGSgBQJAwCDA7pjgtr1yFjSx4JCQCXAa
         W2f278Z+vKuS1GDKYlKBk//3ubFp7rgC15y0XgGirkXTT2kbrsSRnMVb5F7n+M1/gV
         dbd9cQFTY/RaQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1120E60A37;
        Sun, 19 Sep 2021 11:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] enetc: Fix illegal access when reading affinity_hint
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205040906.14261.2098100374293719653.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 11:20:09 +0000
References: <20210917102206.20616-1-claudiu.manoil@nxp.com>
In-Reply-To: <20210917102206.20616-1-claudiu.manoil@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 17 Sep 2021 13:22:05 +0300 you wrote:
> irq_set_affinity_hit() stores a reference to the cpumask_t
> parameter in the irq descriptor, and that reference can be
> accessed later from irq_affinity_hint_proc_show(). Since
> the cpu_mask parameter passed to irq_set_affinity_hit() has
> only temporary storage (it's on the stack memory), later
> accesses to it are illegal. Thus reads from the corresponding
> procfs affinity_hint file can result in paging request oops.
> 
> [...]

Here is the summary with links:
  - [net] enetc: Fix illegal access when reading affinity_hint
    https://git.kernel.org/netdev/net/c/7237a494decf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


