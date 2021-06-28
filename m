Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30B63B69E4
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 22:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbhF1Uwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 16:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236264AbhF1Uwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 16:52:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 81FFD61CF1;
        Mon, 28 Jun 2021 20:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624913404;
        bh=HilnqKRlIRB0CVdZ5ZXPD04RmF+1vwQkPqMBuXQQVBE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iXPHEt45pKixPGIAvUrdV74hRHjPUmnSS968RjWwOccYjMfW2bFR/T/WLgDS4+nky
         34lT2u9wk2uGaXbjKzT59qOYX30/V2IBAHoM2lntsM9WUEC5DzrJZ9vwldUfGq5sX4
         l/CxSi9CfaJoSY/xKAoygQNgsR3zA105pvGWsl1BSbrxvEatcb/1VNGuAfLgM+JN+7
         g+2dYkkIhmflClCub6uOzz1TYQk1N6DpkgTSFQsktT2R7qE17/c+jb7blHhrKzZ2of
         qZxpPi32s1SJ84NyypRkjab+sfqkjvZgH72NjDC7lGffOhebvsfzda28xtoy1nTXI2
         mgupfJ1PS1+PA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 754BE60C09;
        Mon, 28 Jun 2021 20:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/7] bnxt_en: Add hardware PTP timestamping
 support on 575XX devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162491340447.24399.7662066111966364643.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 20:50:04 +0000
References: <1624814390-1300-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1624814390-1300-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com, richardcochran@gmail.com,
        pavan.chebbi@broadcom.com, edwin.peer@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 27 Jun 2021 13:19:43 -0400 you wrote:
> Add PTP RX and TX hardware timestamp support on 575XX devices.  These
> devices use the two-step method to implement the IEEE-1588 timestamping
> support.
> 
> v2: Add spinlock to serialize access to the timecounter.
>     Use .do_aux_work() for the periodic timer reading and to get the TX
>     timestamp from the firmware.
>     Propagate error code from ptp_clock_register().
>     Make the 64-bit timer access safe on 32-bit CPUs.
>     Read PHC using direct register access.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/7] bnxt_en: Update firmware interface to 1.10.2.47
    https://git.kernel.org/netdev/net-next/c/78eeadb8fea6
  - [net-next,v2,2/7] bnxt_en: Get PTP hardware capability from firmware
    https://git.kernel.org/netdev/net-next/c/ae5c42f0b92c
  - [net-next,v2,3/7] bnxt_en: Add PTP clock APIs, ioctls, and ethtool methods
    https://git.kernel.org/netdev/net-next/c/118612d519d8
  - [net-next,v2,4/7] bnxt_en: Get the full 48-bit hardware timestamp periodically
    https://git.kernel.org/netdev/net-next/c/390862f45c85
  - [net-next,v2,5/7] bnxt_en: Get the RX packet timestamp
    https://git.kernel.org/netdev/net-next/c/7f5515d19cd7
  - [net-next,v2,6/7] bnxt_en: Transmit and retrieve packet timestamps
    https://git.kernel.org/netdev/net-next/c/83bb623c968e
  - [net-next,v2,7/7] bnxt_en: Enable hardware PTP support
    https://git.kernel.org/netdev/net-next/c/93cb62d98e9c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


