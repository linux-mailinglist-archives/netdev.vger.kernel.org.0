Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36C82AA875
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 00:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgKGXuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 18:50:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:35946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgKGXuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 18:50:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604793006;
        bh=5sF692wkYCEbQT8uoZJLeucOvp6DZ6XU77hGL4jfO40=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CoxxMcGOOfcL0kdtNzI9SlqC71oSAEVg6SQC/tZDAbkfSzbC4axvRVcEkwtouXPIz
         X0nG51rTh34OeP8gwMGDBtPx1/Dunc+b+aOQd1Fb6BYJSEhivuRHMvz/FZP/pmZwH0
         SAkCX1WdYM6SLRkMosg2r3U3yD9hnzsAmtZupl68=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/13] net: ipa: constrain GSI interrupts
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160479300600.31517.12429482938836124184.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Nov 2020 23:50:06 +0000
References: <20201105181407.8006-1-elder@linaro.org>
In-Reply-To: <20201105181407.8006-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        subashab@codeaurora.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu,  5 Nov 2020 12:13:54 -0600 you wrote:
> The goal of this series is to more tightly control when GSI
> interrupts are enabled.  This is a long-ish series, so I'll
> describe it in parts.
> 
> The first patch is actually unrelated...  I forgot to include
> it in my previous series (which exposed the GSI layer to the
> IPA version).  It is a trivial comments-only update patch.
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] net: ipa: refer to IPA versions, not GSI
    https://git.kernel.org/netdev/net-next/c/4a04d65c964e
  - [net-next,02/13] net: ipa: request GSI IRQ later
    https://git.kernel.org/netdev/net-next/c/0b8d67610845
  - [net-next,03/13] net: ipa: rename gsi->event_enable_bitmap
    https://git.kernel.org/netdev/net-next/c/a054539db196
  - [net-next,04/13] net: ipa: define GSI interrupt types with an enum
    https://git.kernel.org/netdev/net-next/c/f9b28804ab50
  - [net-next,05/13] net: ipa: disable all GSI interrupt types initially
    https://git.kernel.org/netdev/net-next/c/97eb94c8c790
  - [net-next,06/13] net: ipa: cache last-saved GSI IRQ enabled type
    https://git.kernel.org/netdev/net-next/c/3ca97ffd984c
  - [net-next,07/13] net: ipa: only enable GSI channel control IRQs when needed
    https://git.kernel.org/netdev/net-next/c/b054d4f9eb4b
  - [net-next,08/13] net: ipa: only enable GSI event control IRQs when needed
    https://git.kernel.org/netdev/net-next/c/b4175f8731f7
  - [net-next,09/13] net: ipa: only enable generic command completion IRQ when needed
    https://git.kernel.org/netdev/net-next/c/d6c9e3f506ae
  - [net-next,10/13] net: ipa: only enable GSI IEOB IRQs when needed
    https://git.kernel.org/netdev/net-next/c/06c8632833c2
  - [net-next,11/13] net: ipa: explicitly disallow inter-EE interrupts
    https://git.kernel.org/netdev/net-next/c/46f748ccaf01
  - [net-next,12/13] net: ipa: only enable GSI general IRQs when needed
    https://git.kernel.org/netdev/net-next/c/352f26a886d8
  - [net-next,13/13] net: ipa: pass a value to gsi_irq_type_update()
    https://git.kernel.org/netdev/net-next/c/8194be79fbbc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


