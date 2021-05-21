Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1801738D06A
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 00:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhEUWBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 18:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhEUWBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 18:01:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 855B0613F6;
        Fri, 21 May 2021 22:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621634410;
        bh=qCxXG1VtJn1SejcQ+BZ/vL/wn9WnZmbHxD+IN/U7rSI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TJxHWYAGi0BZWW6yH1kv64+Fm6KVakqMZ97KP0460/61gtys4ZFarjUv2lA1doAnE
         uh0CDx3svjxPzQgNt4HSUvmkcLXg8Xsa5D/NGvseVSXD1rnGsXwUDBPNP76UFGYwq+
         zwtUeNuDpwJG1rXMgh36+fxd2ehWrEODFgGqPk/ZUM4yTT0VWRtAmdFv99mJi0jq1F
         YEd+Dq9+Cz+YZdvInTVc4NOgPfHnyZPzbXXQwNRffdWC3+9FfOcII3oDsyucGsK69C
         06Uo36et2Pl7psEubohpr76xxvAlubzsjU8XJcJW/AYx/nYPA1Pn1edcyOtL81L/GI
         yebxg/D3PiLMQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7AF8E609FE;
        Fri, 21 May 2021 22:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net:sfc: fix non-freed irq in legacy irq mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162163441049.19398.11630581913954509996.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 22:00:10 +0000
References: <20210521143834.26561-1-ihuguet@redhat.com>
In-Reply-To: <20210521143834.26561-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ivecera@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 21 May 2021 16:38:35 +0200 you wrote:
> SFC driver can be configured via modparam to work using MSI-X, MSI or
> legacy IRQ interrupts. In the last one, the interrupt was not properly
> released on module remove.
> 
> It was not freed because the flag irqs_hooked was not set during
> initialization in the case of using legacy IRQ.
> 
> [...]

Here is the summary with links:
  - net:sfc: fix non-freed irq in legacy irq mode
    https://git.kernel.org/netdev/net/c/8f03eeb6e0a0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


