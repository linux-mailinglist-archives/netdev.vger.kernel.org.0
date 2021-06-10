Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457E23A351A
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhFJUwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhFJUwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 16:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BB77D61404;
        Thu, 10 Jun 2021 20:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623358205;
        bh=Yxv20FOrE9GCpRb8oyBZtkqqu4NNEJ90h5jYQ7mB7AM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CaYrNgUhPjIFc6y85SAaPcowgnmpVpOJpihdfhiFFv8r4guebLSRNn6xOkDsrxZhN
         LeawfW/z2ysif2+JQkmIbAQmgoOYStiWdMJQQKQHQ8qUslinmR8hNqPXiA0kiZtVb6
         v6RsZd1nborn+e/m5GfBXufMp/lKfeO8xuQSNM1MRK+dtMxMuNq6ndf0X0MbOBVDXY
         DmASstNrrnJFgAaIvhPyy/DT7sT1G9YhtkjdmS4fd9eYp7fonQJytiyiNz7+MVzygi
         yVHcw2yM3UmtufKNDfCPrOem0SkVdN5SC45mH62TcqPdJI3keLdOOGHrpx0G0nQT4J
         y411/yIj4GSdQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B009160A6C;
        Thu, 10 Jun 2021 20:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] skbuff: fix incorrect msg_zerocopy copy notifications
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335820571.975.15227157032394954898.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 20:50:05 +0000
References: <20210609224157.1800831-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20210609224157.1800831-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        soheil@google.com, jonathan.lemon@gmail.com, willemb@google.com,
        talalahmad@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  9 Jun 2021 18:41:57 -0400 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> msg_zerocopy signals if a send operation required copying with a flag
> in serr->ee.ee_code.
> 
> This field can be incorrect as of the below commit, as a result of
> both structs uarg and serr pointing into the same skb->cb[].
> 
> [...]

Here is the summary with links:
  - [net] skbuff: fix incorrect msg_zerocopy copy notifications
    https://git.kernel.org/netdev/net/c/3bdd5ee0ec8c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


