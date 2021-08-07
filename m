Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B7B3E342D
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 10:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbhHGIuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 04:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229636AbhHGIuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 04:50:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 14991610A6;
        Sat,  7 Aug 2021 08:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628326207;
        bh=kRuLPyTTLNEJA93l6MCV3zc+aiO70ovcN1Fcy86tiHI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TfmzUH9zmF7FrnPOQaXDem1ecfdIT932F1J6xHtWZd+A92Mycf/ZsOB3ywfTkPZ0r
         5vJtv874YIQHmfDqYOjl7N56pmfTed0caYhvEKq09aigGAKd+8vh74l5bDxyRR7Nmg
         aZ+qhShTEoTfcTnFl+5Cu8z1/FIGhJbuPLUkEfKXkFdmeAmG0eZ2vhC1rxPuGOMs2q
         jPs5+TUhDTQNXQklSy4h9DPkMe8tCnKhz9XJqB/Aw6zkXSzqLyxhpaCn/bsqiegbZC
         96gWejRLjtNvyEwwQZSGdvI1nIqHL8cH7Vaaq1HrXhS1x7rAgVgZbfpIC42EkIVQo2
         hj3szk2olj6sg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F416A60A94;
        Sat,  7 Aug 2021 08:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] s390/qeth: Add bridge to switchdev LEARNING_SYNC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162832620699.3915.7166207623966266187.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Aug 2021 08:50:06 +0000
References: <20210806152603.375642-1-kgraul@linux.ibm.com>
In-Reply-To: <20210806152603.375642-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        guvenc@linux.ibm.com, jwi@linux.ibm.com, wenjia@linux.ibm.com,
        wintera@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  6 Aug 2021 17:26:00 +0200 you wrote:
> Please apply the following patch series for qeth to netdev's net-next tree.
> 
> The netlink bridgeport attribute LEARNING_SYNC can be used to enable
> qeth interfaces to report MAC addresses that are reachable via this
> qeth interface to the attached software bridge via switchdev
> notifiers SWITCHDEV_FDB_ADD_TO_BRIDGE and SWITCHDEV_FDB_DEL_TO_BRIDGE.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] s390/qeth: Register switchdev event handler
    https://git.kernel.org/netdev/net-next/c/60bb1089467d
  - [net-next,2/3] s390/qeth: Switchdev event handler
    https://git.kernel.org/netdev/net-next/c/4e20e73e631a
  - [net-next,3/3] s390/qeth: Update MACs of LEARNING_SYNC device
    https://git.kernel.org/netdev/net-next/c/f7936b7b2663

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


