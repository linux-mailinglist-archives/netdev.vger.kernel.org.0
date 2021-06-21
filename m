Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BCD3AF675
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 21:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhFUTwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 15:52:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231451AbhFUTwV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 15:52:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2DC236128E;
        Mon, 21 Jun 2021 19:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624305006;
        bh=vi58ZeC1mPpcFZS9+h8JoazVvcQ6pUWOP+xVi2AASrw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=clW7MkMHzJ+t/kEFanzfykya+Fn3O5dfjeo+V1IsYIMhcJuKL/o1wIvIl932iIV6B
         NYh1GGCeJxQnrSGlqpp44JWLxyEB/oUtWtxeQ14GeHYr3Tku28X+di9HUVWCd5XEPI
         648FKGyT+iJcYLYi2RS2RJcoBAOindatb+wP7cssJPRmfZ7FpnGWMF5pOLrRgeMjvu
         ydvOPx5GT3mrwrgB1+gW28W98rdpEET2j/7V5b0ZJ0qLRJAlBtkIcTDI8LZMp5kxqy
         t05FojUaKOV5WBEX3QPcm8JgjBoIOOaymgCo7VRutAGQEANgupPfIqcHVSLQvh1ptf
         0PvF82MVbyxSA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 26E36609E3;
        Mon, 21 Jun 2021 19:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: ipa: add support for IPA v3.1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162430500615.22375.2806295239957510179.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 19:50:06 +0000
References: <20210621175627.238474-1-elder@linaro.org>
In-Reply-To: <20210621175627.238474-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        angelogioacchino.delregno@somainline.org, jamipkettunen@gmail.com,
        bjorn.andersson@linaro.org, agross@kernel.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 21 Jun 2021 12:56:21 -0500 you wrote:
> This series adds support for IPA v3.1, used by the Qualcomm
> Snapdragon 835 (MSM8998).
> 
> The first patch adds "qcom,msm8998-ipa" to the DT binding.
> 
> The next four patches add code to ensure correct operation on
> IPA v3.1:
>   - Avoid touching unsupported inter-EE interrupt mask registers
>   - Set the proper flags in the clock configuration register
>   - Work around the lack of an IPA FLAVOR_0 register
>   - Work around the lack of a GSI PARAM_2 register
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] dt-bindings: net: qcom,ipa: add support for MSM8998
    https://git.kernel.org/netdev/net-next/c/2afd6c8b43c1
  - [net-next,2/6] net: ipa: inter-EE interrupts aren't always available
    https://git.kernel.org/netdev/net-next/c/c31d73494fa5
  - [net-next,3/6] net: ipa: disable misc clock gating for IPA v3.1
    https://git.kernel.org/netdev/net-next/c/3833d0abd2c5
  - [net-next,4/6] net: ipa: FLAVOR_0 register doesn't exist until IPA v3.5
    https://git.kernel.org/netdev/net-next/c/110971d1ee4d
  - [net-next,5/6] net: ipa: introduce gsi_ring_setup()
    https://git.kernel.org/netdev/net-next/c/bae70a803a77
  - [net-next,6/6] net: ipa: add IPA v3.1 configuration data
    https://git.kernel.org/netdev/net-next/c/1bb1a117878b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


