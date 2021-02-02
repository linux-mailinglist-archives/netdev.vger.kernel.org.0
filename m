Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B12830B55D
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 03:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhBBCks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 21:40:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhBBCkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 21:40:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 610C964DDD;
        Tue,  2 Feb 2021 02:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612233606;
        bh=yfntcXcoqe1wusH7Htycob0bwFGVAVcT1tMwYbfHg9c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hQ65JZUalJB0jfM5k5T9biYh7Et52VefVKV34QjHDQcj+ldO8D3N2Tjdv8YW/AFkd
         aCrAcxLe+zyJhz9Hp4iqalfYH3sypFQ7445Ldb2nIfSkGhrk9vPDvLnmDaaBh+AynS
         t2CG8IwZpRYlVKnMsRqbiFLbOQXNGfcsJcwL2slchSfWZenLv9GRk+UhIrVtx5jxyM
         +/JID5c6afjzdZsr3jaR3T7vCc8NkSXDELofChNboYy+/nYYZjrjJgd9MUvFjud3uh
         VXPrIOsL7GTMoFrfnmIDatZo+xD4FYGNnhnsIwb76xF7be3lYDG+/mizELMXe3t6xp
         BUbrmkX183iwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5170A609D7;
        Tue,  2 Feb 2021 02:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ibmvnic: device remove has higher precedence over
 reset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161223360632.28374.6957431077646560509.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 02:40:06 +0000
References: <20210129043402.95744-1-ljp@linux.ibm.com>
In-Reply-To: <20210129043402.95744-1-ljp@linux.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        drt@linux.ibm.com, sukadev@linux.ibm.com, mpe@ellerman.id.au,
        julietk@linux.vnet.ibm.com, benh@kernel.crashing.org,
        paulus@samba.org, davem@davemloft.net, kuba@kernel.org,
        gregkh@linuxfoundation.org, kernel@pengutronix.de,
        u.kleine-koenig@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 28 Jan 2021 22:34:01 -0600 you wrote:
> Returning -EBUSY in ibmvnic_remove() does not actually hold the
> removal procedure since driver core doesn't care for the return
> value (see __device_release_driver() in drivers/base/dd.c
> calling dev->bus->remove()) though vio_bus_remove
> (in arch/powerpc/platforms/pseries/vio.c) records the
> return value and passes it on. [1]
> 
> [...]

Here is the summary with links:
  - [net,v2] ibmvnic: device remove has higher precedence over reset
    https://git.kernel.org/netdev/net/c/5e9eff5dfa46

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


