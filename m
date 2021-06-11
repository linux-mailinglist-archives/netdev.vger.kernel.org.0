Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40103A4A09
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhFKUWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229951AbhFKUWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 16:22:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7787C610F8;
        Fri, 11 Jun 2021 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623442808;
        bh=pVS9xlrEg0zVzKIXcPSj83xXtf8S5iW20XhqZRC3q5E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CjWFaqchQI913uhKgOlQ0EJl31WfkghY/oRK0GY4OfdCng9bwbOduoA95arl+S8uV
         1/u+FHY7NG4FpKsR2VjDtOariIL94YGhKB7MpDk/qTncYwgeC0jmeJi+ET+mJiwrEN
         gnUusFPfWhfNzaVT0fEoigbZMxispKn0YVFV37K5AX6Lr44CJ0pXtZmJuhZ6BJqbzb
         DXBoKgqHf1YtK5m8pmlQDqsS8pZ38IICTtfRD5n7UjkDTNZy4SlCxcRRYlnSD9AxB6
         +haR2MnhQIKhw3m12wkmNccPy/wk0wuT7HMTTxXVCidxK81CZNgQ8txRAqabQzVZ6O
         HsdQlTmpvXshg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 66F2960A49;
        Fri, 11 Jun 2021 20:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: stmmac: Fix potential integer overflow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162344280841.13501.12129405164687324305.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 20:20:08 +0000
References: <20210611090238.1157557-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210611090238.1157557-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 17:02:38 +0800 you wrote:
> The commit d96febedfde2 ("net: stmmac: arrange Tx tail pointer update
> to stmmac_flush_tx_descriptors") introduced the following coverity
> warning:-
> 
>   1. Unintentional integer overflow (OVERFLOW_BEFORE_WIDEN)
>      overflow_before_widen: Potentially overflowing expression
>      'tx_q->cur_tx * desc_size' with type 'unsigned int' (32 bits,
>      unsigned) is evaluated using 32-bit arithmetic, and then used in a
>      context that expects an expression of type dma_addr_t (64 bits,
>      unsigned).
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/1] net: stmmac: Fix potential integer overflow
    https://git.kernel.org/netdev/net-next/c/52e597d3e2e6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


