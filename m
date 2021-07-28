Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DC63D960C
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 21:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbhG1TaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 15:30:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhG1TaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 15:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 219D661042;
        Wed, 28 Jul 2021 19:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627500607;
        bh=prIO4QbYTzrxc7aWDrcBwfz7s4A4uomn1aXT9oRIuvw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HM+hhaILUERDwmhYZN6dzi15ZtsOwdUPiFIumtNBQfftE3AEXHJq+KV4zPErMLTpN
         M0yPcP8UOS1yoMoDTTX4jnJTdLki9KFHkzkLeFnRYsc36ibRY09pSUVHsuGI9eBrCd
         jP6E18uPO+IDjUj4C3ExxderrALLRGpSNDc/MeCHFbAGUYuQpklXW9zaaq1wfni9vR
         KRbobdgTTOSvSn3XWuWjjKg8ocyNmSe/pnh46AjZV0xWwP1j9fTogGGFa8KygyjNOT
         cXMywXmxbU4dzmfzgbziOcTSLqpLtxc4Ls4LM07pxIRxz0YDvT/Okn9EPbEYMlWHqF
         lPrESgkHlid2Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1482260A6C;
        Wed, 28 Jul 2021 19:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] bnxt_en: PTP enhancements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162750060707.2664.5673070357115104721.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Jul 2021 19:30:07 +0000
References: <1627495905-17396-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1627495905-17396-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com, richardcochran@gmail.com,
        pavan.chebbi@broadcom.com, edwin.peer@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 28 Jul 2021 14:11:39 -0400 you wrote:
> This series adds two PTP enhancements.  This first one is to register
> the PHC during probe time and keep it registered whether it is in
> ifup or ifdown state.  It will get unregistered and possibly
> reregistered if the firmware PTP capability changes after firmware
> reset.  The second one is to add the 1PPS (one pulse per second)
> feature to support input/output of the 1PPS signal.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] bnxt_en: Move bnxt_ptp_init() from bnxt_open() back to bnxt_init_one()
    https://git.kernel.org/netdev/net-next/c/a521c8a01d26
  - [net-next,2/6] bnxt_en: Do not read the PTP PHC during chip reset
    https://git.kernel.org/netdev/net-next/c/30e96f487f64
  - [net-next,3/6] bnxt_en: 1PPS support for 5750X family chips
    https://git.kernel.org/netdev/net-next/c/caf3eedbcd8d
  - [net-next,4/6] bnxt_en: 1PPS functions to configure TSIO pins
    https://git.kernel.org/netdev/net-next/c/9e518f25802c
  - [net-next,5/6] bnxt_en: Event handler for PPS events
    https://git.kernel.org/netdev/net-next/c/099fdeda659d
  - [net-next,6/6] bnxt_en: Log if an invalid signal detected on TSIO pin
    https://git.kernel.org/netdev/net-next/c/abf90ac2c292

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


