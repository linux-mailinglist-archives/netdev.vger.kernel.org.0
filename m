Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793A33EACDB
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 00:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238016AbhHLWAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 18:00:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhHLWAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 18:00:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ACC406109D;
        Thu, 12 Aug 2021 22:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628805605;
        bh=ir2ziQf4X6qDh9jTfNwp22IWE02AbTPs8Q589G/b37E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EUaiUVF6p04UBK+HwmlNRqJJenaRS6Jrs5Aa0J9omWCoeDqsyU8R2kZv/7fhbPgLG
         OmVzhk42xjEuPV7V+jwisbzdaGtQsL7H1CbIH06VzBCSB+WUDDcmGLM1y7w68SS9Rh
         WaJiRGe9IZ+147dxm2M6FykmnTDR38t17cnfgTXQQMGofIEQMYv2ewL7s81uEhjcI4
         hBWGRO7knhLxKCN2R6QICECJsfqQFAqhE5AhzsMIgmdNE+Mi8YcYFHvbcuzyiFVazS
         7Ux80P56zm6EOjEYqPM2eMWb7EUeCOwpcY5M+U+cAJoDmfwxNp6Xo1+MmquSfDd1eU
         RZxfrb/8cvK6A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9E48F608FA;
        Thu, 12 Aug 2021 22:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4] dt-bindings: net: qcom,ipa: make imem
 interconnect optional
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162880560564.30992.9102429132123805717.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Aug 2021 22:00:05 +0000
References: <20210811141802.2635424-1-elder@linaro.org>
In-Reply-To: <20210811141802.2635424-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        bjorn.andersson@linaro.org, agross@kernel.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 11 Aug 2021 09:18:02 -0500 you wrote:
> On some newer SoCs, the interconnect between IPA and SoC internal
> memory (imem) is not used.  Update the binding to indicate that
> having just the memory and config interconnects is another allowed
> configuration.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> 
> [...]

Here is the summary with links:
  - [net-next,v4] dt-bindings: net: qcom,ipa: make imem interconnect optional
    https://git.kernel.org/netdev/net-next/c/b769cf44ed55

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


