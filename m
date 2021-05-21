Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CB538D06C
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 00:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhEUWBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 18:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhEUWBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 18:01:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E797661403;
        Fri, 21 May 2021 22:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621634410;
        bh=NLooJCnU/ogHeqpVY1kxno9RvmRMeumqF1+wXXaiWTY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hVFGV0NZldOeUL6dwa46FRUBlOABWVhxbe4goOAQwdAt5MgRpgsnfbLi6QtZQDFsW
         n1zwjIJTHACCUNBao0D9vGxzLesJMUPGj1ebh4ruUOYHyWkYvmyA4fR189UCAPhnNw
         CHXahoqKCI5AlQZFHwmOj/8MfbDnoajuD2uaMNH74KIFfmIWDqCUi+rzZd8KhvOZwr
         eqCodKIgu/pzhv0rpxw+RsKDVrsf/0jSHbpUB1RcQ+j5wmMBBp1UaHF64UjW1kIsfa
         pq9B0gM4w5g8UxkcO70HkrpwYvVRzxkTGtKhdCk3/geNF20I18lkknSB0eptbGvbU3
         hXmrr4Tv47l2g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E261560A56;
        Fri, 21 May 2021 22:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] dpaa2-eth: don't print error from dpaa2_mac_connect
 if that's EPROBE_DEFER
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162163441092.19398.4970465819381081436.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 22:00:10 +0000
References: <20210521141220.4057221-1-olteanv@gmail.com>
In-Reply-To: <20210521141220.4057221-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        ioana.ciornei@nxp.com, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 21 May 2021 17:12:20 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When booting a board with DPAA2 interfaces defined statically via DPL
> (as opposed to creating them dynamically using restool), the driver will
> print an unspecific error message.
> 
> This change adds the error code to the message, and avoids printing
> altogether if the error code is EPROBE_DEFER, because that is not a
> cause of alarm.
> 
> [...]

Here is the summary with links:
  - [net-next] dpaa2-eth: don't print error from dpaa2_mac_connect if that's EPROBE_DEFER
    https://git.kernel.org/netdev/net-next/c/f5120f599880

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


