Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57C631E1B5
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 23:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhBQWAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 17:00:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhBQWAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 17:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E129064E5F;
        Wed, 17 Feb 2021 22:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613599208;
        bh=1yR4LhceZjlz5TE1boDBw4thA7rxHiTlnFY807j5q2M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m2tGvN+cBfZtc3WBRIC62BAHMRiCC+v/3EiBu2KKfltTjJe7KfoIzdmbfGcXqQFrP
         82+grzBN6y6UONkIrDePRRErdK3zXVtFVwPcNUW0ZlNUpjOrv19HehTWutILd8JS5O
         rH04D3/Dn8ALzujYZf3BCuDgL+HEQyYVRXdUTYFH3zzkLmxjfU+pCoQrjhjBb6V43C
         w31wpfwQPq+lfJGL2b7Xr5vQq+OhdDi8g/DwPEARrvj5g4k9XguJVOYf4HVKWwB7t2
         r95wuDPQKa91Y5b0vKymyveNlYNdvyKA02sX4fHEJONSAJiMLhVsJXPheas2/XNN7f
         vJECQ0N4R/lfA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CEAE260A21;
        Wed, 17 Feb 2021 22:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/7] ptp: ptp_clockmatrix: Fix output 1 PPS
 alignment.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161359920884.16194.18416847721041834914.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Feb 2021 22:00:08 +0000
References: <1613540538-23792-1-git-send-email-vincent.cheng.xh@renesas.com>
In-Reply-To: <1613540538-23792-1-git-send-email-vincent.cheng.xh@renesas.com>
To:     Vincent Cheng <vincent.cheng.xh@renesas.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Feb 2021 00:42:11 -0500 you wrote:
> From: Vincent Cheng <vincent.cheng.xh@renesas.com>
> 
> This series fixes a race condition that may result in the output clock
> not aligned to internal 1 PPS clock.
> 
> Part of device initialization is to align the rising edge of output
> clocks to the internal rising edge of the 1 PPS clock.  If the system
> APLL and DPLL are not locked when this alignment occurs, the alignment
> fails and a fixed offset between the internal 1 PPS clock and the
> output clock occurs.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/7] ptp: ptp_clockmatrix: Add wait_for_sys_apll_dpll_lock.
    https://git.kernel.org/netdev/net-next/c/797d3186544f
  - [v3,net-next,2/7] ptp: ptp_clockmatrix: Add alignment of 1 PPS to idtcm_perout_enable.
    https://git.kernel.org/netdev/net-next/c/e8b4d8b542b1
  - [v3,net-next,3/7] ptp: ptp_clockmatrix: Remove unused header declarations.
    https://git.kernel.org/netdev/net-next/c/10c270cf25bd
  - [v3,net-next,4/7] ptp: ptp_clockmatrix: Clean-up dev_*() messages.
    https://git.kernel.org/netdev/net-next/c/1c49d3e94778
  - [v3,net-next,5/7] ptp: ptp_clockmatrix: Coding style - tighten vertical spacing.
    https://git.kernel.org/netdev/net-next/c/fcfd37573a09
  - [v3,net-next,6/7] ptp: ptp_clockmatrix: Simplify code - remove unnecessary `err` variable.
    https://git.kernel.org/netdev/net-next/c/fde3b3a7069e
  - [v3,net-next,7/7] ptp: ptp_clockmatrix: clean-up - parenthesis around a == b are unnecessary
    https://git.kernel.org/netdev/net-next/c/77fdb168a3e2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


