Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAF92B2919
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 00:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgKMXUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 18:20:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgKMXUG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 18:20:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605309605;
        bh=1wPxdQtcO1y7mum/CRJlcuVgCjzzO8A61DR4CRV6PtU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WQwlkdttwnoAomuWh3n0HdD1CU43OBf34lVgn+D3rbPC51akN+JByc9FRrpRdghjY
         SagThOylcpt30g5PC8fFL4xfxE9YrM6rCfOvpYTfS27uMRnnCwjHsMT0qEYkSkziYw
         Cssy77IpN18eUH6kXCrRc/IM7Tpm1EyPemTT0tUY=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: ipa: GSI register consolidation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160530960571.2715.16368912876962329757.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Nov 2020 23:20:05 +0000
References: <20201110215922.23514-1-elder@linaro.org>
In-Reply-To: <20201110215922.23514-1-elder@linaro.org>
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

On Tue, 10 Nov 2020 15:59:16 -0600 you wrote:
> This series rearranges and consolidates some GSI register
> definitions.  Its general aim is to make things more
> consistent, by:
>   - Using enumerated types to define the values held in GSI register
>     fields
>   - Defining field values in "gsi_reg.h", together with the
>     definition of the register (and field) that holds them
>   - Format enumerated type members consistently, with hexidecimal
>     numeric values, and assignments aligned on the same column
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: ipa: define GSI interrupt types with enums
    https://git.kernel.org/netdev/net-next/c/6c6358cca6fd
  - [net-next,2/6] net: ipa: use common value for channel type and protocol
    https://git.kernel.org/netdev/net-next/c/46dda53ef7de
  - [net-next,3/6] net: ipa: move channel type values into "gsi_reg.h"
    https://git.kernel.org/netdev/net-next/c/9ed8c2a92d01
  - [net-next,4/6] net: ipa: move GSI error values into "gsi_reg.h"
    https://git.kernel.org/netdev/net-next/c/7b0ac8f65116
  - [net-next,5/6] net: ipa: move GSI command opcode values into "gsi_reg.h"
    https://git.kernel.org/netdev/net-next/c/cec2076e432e
  - [net-next,6/6] net: ipa: use enumerated types for GSI field values
    https://git.kernel.org/netdev/net-next/c/4730ab1c1d27

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


