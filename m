Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FFF49CEBF
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 16:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243015AbiAZPkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 10:40:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56292 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243006AbiAZPkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 10:40:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E12961948
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 15:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07FE5C340E6;
        Wed, 26 Jan 2022 15:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643211611;
        bh=05Im49QLC5nFuyc/nvFjXYHsTOzVPDun8WVom+P+fxY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ai4HjWT/Q3678iRckKfpFQgUrbDF/dbZ8EdSJ7vWX1b030ktEfuGlNdMeS30LVyFK
         H0czwocOfInB47TeW24KoXlcXzLGstRTLbSi/+NDBdvG0sZqsm4bIjESRNpDj3i4NF
         A3/RTcbX2wj3YvgC99JqIp9ZVDqm3WyxAV8etBl+V2mXE2wdgFUrmYw5i6ONCiav6S
         EWHdufvcOqMFKT73/JKRfBqQukq7FV69AXVSS+DE2yNmGZsxnlKUm8qeanJc8enx64
         afKeIYxcetrtiW9qyjNo1fSZ0frHxVOG5M6WuRrLv9oApMBIDW65TgRARJeqxO7r9V
         L6N7RLm573U9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0685F607B4;
        Wed, 26 Jan 2022 15:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] bnxt_en: Add RTC mode for PTP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164321161091.6609.18152210571384106386.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Jan 2022 15:40:10 +0000
References: <1643172013-31729-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1643172013-31729-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com, pavan.chebbi@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 25 Jan 2022 23:40:08 -0500 you wrote:
> This series adds Real Time Clock (RTC) mode for PTP timestamping.  In
> RTC mode, the 64-bit time value is programmed into the NIC's PTP
> hardware clock (PHC).  Prior to this, the PHC is running as a free
> counter.  For example, in multi-function environment, we need to run
> PTP in RTC mode.
> 
> Michael Chan (1):
>   bnxt_en: Update firmware interface to 1.10.2.73
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] bnxt_en: Update firmware interface to 1.10.2.73
    https://git.kernel.org/netdev/net-next/c/2895c1531056
  - [net-next,2/5] bnxt_en: PTP: Refactor PTP initialization functions
    https://git.kernel.org/netdev/net-next/c/740c342e3999
  - [net-next,3/5] bnxt_en: Add driver support to use Real Time Counter for PTP
    https://git.kernel.org/netdev/net-next/c/24ac1ecd5240
  - [net-next,4/5] bnxt_en: Implement .adjtime() for PTP RTC mode
    https://git.kernel.org/netdev/net-next/c/e7b0afb69083
  - [net-next,5/5] bnxt_en: Handle async event when the PHC is updated in RTC mode
    https://git.kernel.org/netdev/net-next/c/8bcf6f04d4a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


