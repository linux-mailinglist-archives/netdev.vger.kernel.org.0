Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295D7425313
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 14:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241348AbhJGMcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 08:32:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241261AbhJGMcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 08:32:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5BDCC61038;
        Thu,  7 Oct 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633609808;
        bh=IggZNe7cG734J2xCo3rRvC+d8qUmLLj4xDRZqp30MEM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dKMfwTBKzV0tnerAYzPo1m97/86v7MqnKSTkCAh1lT9DWZE3HXCEv/SI8tkjJIcB+
         1JjY9337+UEoFSXfoItUrMGrv2ioCSDpyR8SwHmN1aXZeLJRV9SDHGuPZjuTyYWF2C
         w23l5ms8JEimGvVVv4jqHhIIUb8T+YQFkDCKweYT3/WE+QWg/9tH8hHG+ApvrpOPTU
         44gI3WQvbih8FSMlfhyuWdX0caDzqQbzegbxFqqM0DnO80MbgkoHIbq+4UIBZ5VT2s
         4j89S2/CEEMomcxiHLhFSIgVeCt+jg63E7tvhmpUE5HPOU7bd2CjjhYBvffLPUYtE+
         x1ObNGWSoGI7Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4E85560A39;
        Thu,  7 Oct 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request (net): ipsec 2021-10-07
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163360980831.17389.11427415950468586520.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Oct 2021 12:30:08 +0000
References: <20211007055524.319785-1-steffen.klassert@secunet.com>
In-Reply-To: <20211007055524.319785-1-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Thu, 7 Oct 2021 07:55:19 +0200 you wrote:
> 1) Fix a sysbot reported shift-out-of-bounds in xfrm_get_default.
>    From Pavel Skripkin.
> 
> 2) Fix XFRM_MSG_MAPPING ABI breakage. The new XFRM_MSG_MAPPING
>    messages were accidentally not paced at the end.
>    Fix by Eugene Syromiatnikov.
> 
> [...]

Here is the summary with links:
  - pull request (net): ipsec 2021-10-07
    https://git.kernel.org/netdev/net/c/578f3932273f
  - [2/5] include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI breakage
    https://git.kernel.org/netdev/net/c/844f7eaaed92
  - [3/5] xfrm: make user policy API complete
    https://git.kernel.org/netdev/net/c/f8d858e607b2
  - [4/5] xfrm: notify default policy on update
    https://git.kernel.org/netdev/net/c/88d0adb5f13b
  - [5/5] xfrm: fix rcu lock in xfrm_notify_userpolicy()
    https://git.kernel.org/netdev/net/c/93ec1320b017

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


