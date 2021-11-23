Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E66845A267
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237078AbhKWMXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:23:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236398AbhKWMXS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:23:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 36A5C60F26;
        Tue, 23 Nov 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637670010;
        bh=z9dH0TpzbCpmOCIect515irX5TkvjKzCa+8Dby5rmYk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DnlZqbKxjjOSFdRVUla7hlSbktd0un1fVaAdTdHfglVBJdp2+9lzWt+xhhicFCr1B
         emvg2ZsZAhnqZnQZ++QN3zrrEMUY5uJ1k9m26p/EIR9hvZRvtL+9PlbWUKgGHkLAGY
         kMjmdYRbDuVMTHhsvL6zZjxz7Qbh61iDv+d3FfVbGJuzDAiDCpVsm2ihqNrlDxA6rQ
         A/oLTCehXmY40VYs/NTVctbZa9m7Bt6JBaDSgp2cphXgfqBvtPgwXqPmoyiKXO6Fua
         kjC6tiI47IN5RoKOrASwwbK3bYYxJlTXiB7uDLjuJbUL4uuOIwoe97kRfQxqOwVEux
         xqh9HBV2TPH0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 31A0760A4E;
        Tue, 23 Nov 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: chelsio: cxgb4vf: Fix an error code in
 cxgb4vf_pci_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163767001019.10565.13818126388186379629.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 12:20:10 +0000
References: <1637634110-3013-1-git-send-email-zheyuma97@gmail.com>
In-Reply-To: <1637634110-3013-1-git-send-email-zheyuma97@gmail.com>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 23 Nov 2021 02:21:50 +0000 you wrote:
> During the process of driver probing, probe function should return < 0
> for failure, otherwise kernel will treat value == 0 as success.
> 
> Therefore, we should set err to -EINVAL when
> adapter->registered_device_map is NULL. Otherwise kernel will assume
> that driver has been successfully probed and will cause unexpected
> errors.
> 
> [...]

Here is the summary with links:
  - net: chelsio: cxgb4vf: Fix an error code in cxgb4vf_pci_probe()
    https://git.kernel.org/netdev/net/c/b82d71c0f84a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


