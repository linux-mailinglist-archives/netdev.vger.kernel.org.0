Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC39C2F9030
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 03:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbhAQCUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 21:20:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:42640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbhAQCUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 21:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1EA7322CB8;
        Sun, 17 Jan 2021 02:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610850010;
        bh=ORQl1ZFd11tXszy9IjdFFuITzpen0YjySzTPviRMEh4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LBqHqoWJucjw3HIAcEiRHddbHmZGc/5C4egWd3sUP+8sDHxa0OHsmth8puPy2dWsd
         vJf/Az2S4ocZDZmHYbQpKNneAnc7At1mKvWjmrEKToq8hnJUu+CC/nInGc6WyDKBnm
         6flzMGPOoSjiTeJ7IdgNQxCWlVJq89w4IZ1zYBJwfcyYwvI2ZkFbBrdcXpKDv5bc9f
         u5XeQNfe553p0wxKpQdtZ4GsQ2j9pfNxFoKQ+nkvsfP40Zm5XNxD6Eq9fbmg81j/Cn
         LVtRvh1kHLuzhYc5Oi6POmY2Wmb/cwHx6OShdHvNAftGN6hzRB/nAnHQi0kD7hOPwu
         sVtsfh7ba/xzw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 0AEBD60658;
        Sun, 17 Jan 2021 02:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND v2 0/7] Rid W=1 warnings in Ethernet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161085001003.18239.10975020699076928503.git-patchwork-notify@kernel.org>
Date:   Sun, 17 Jan 2021 02:20:10 +0000
References: <20210115200905.3470941-1-lee.jones@linaro.org>
In-Reply-To: <20210115200905.3470941-1-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, ast@kernel.org,
        benh@kernel.crashing.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, drt@linux.ibm.com, dnevil@snmc.com,
        davem@davemloft.net, erik@vt.edu, geoff@infradead.org,
        grygorii.strashko@ti.com, gustavoars@kernel.org,
        kou.ishizaki@toshiba.co.jp, ivan.khoronzhuk@linaro.org,
        kuba@kernel.org, Jens.Osterkamp@de.ibm.com, hawk@kernel.org,
        jallen@linux.vnet.ibm.com, john.fastabend@gmail.com,
        kurt@linutronix.de, ljp@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        netdev@vger.kernel.org, nico@fluxnic.net, paul@xen.org,
        paulus@samba.org, pc@denkart.be, rmk@arm.linux.org.uk,
        rusty@rustcorp.com.au, santi_leon@yahoo.com, sukadev@linux.ibm.com,
        tlfalcon@linux.vnet.ibm.com, utz.bacher@de.ibm.com,
        wei.liu@kernel.org, xen-devel@lists.xenproject.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 15 Jan 2021 20:08:58 +0000 you wrote:
> Resending the stragglers again.
> This set is part of a larger effort attempting to clean-up W=1
> kernel builds, which are currently overwhelmingly riddled with
> niggly little warnings.
> 
> No changes since v2, just a rebase onto net-next.
> 
> [...]

Here is the summary with links:
  - [1/7] net: ethernet: smsc: smc91x: Fix function name in kernel-doc header
    https://git.kernel.org/netdev/net-next/c/7d2a92445e3f
  - [2/7] net: xen-netback: xenbus: Demote nonconformant kernel-doc headers
    https://git.kernel.org/netdev/net-next/c/090c7ae8e0d0
  - [3/7] net: ethernet: ti: am65-cpsw-qos: Demote non-conformant function header
    https://git.kernel.org/netdev/net-next/c/935888cda820
  - [4/7] net: ethernet: ti: am65-cpts: Document am65_cpts_rx_enable()'s 'en' parameter
    https://git.kernel.org/netdev/net-next/c/e49e4647f3e2
  - [5/7] net: ethernet: ibm: ibmvnic: Fix some kernel-doc misdemeanours
    https://git.kernel.org/netdev/net-next/c/807086021bf5
  - [6/7] net: ethernet: toshiba: ps3_gelic_net: Fix some kernel-doc misdemeanours
    https://git.kernel.org/netdev/net-next/c/b51036321461
  - [7/7] net: ethernet: toshiba: spider_net: Document a whole bunch of function parameters
    https://git.kernel.org/netdev/net-next/c/e242d5989965

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


