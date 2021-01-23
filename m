Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87364301230
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 03:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbhAWCLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 21:11:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbhAWCKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 21:10:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1EEAC23B6B;
        Sat, 23 Jan 2021 02:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611367811;
        bh=j2maiTRuhEXfhvX1tZ6FlvXc5uCSziBJ6V0SPMSL+cQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k1rXjqDZtyAjOXvT//wL0d4lAZXo/m3dvT1kAbdV4JDPvQ9jl1vGOXq8i0dhokizP
         gJuoHlbjW8s3S6+DvNcRtsjO5SKrCPgN/gGDBL56DwDhjMz4BdibjOEwE5qv3avwFc
         DMY7S5IB9rkikW3dYVVtI+kib3Ar7nbjKpIHrJ9nJuAUr+AXjKQqQsovechoHCCDhC
         WuFIaTT/SrGP8i5z3wLJ/DfolhFqRskh77IwUKBMFfNAj6KxOWzc0stSo2bfa9t0qR
         qjCuEXGnzEorCcfp408D7JROtSvRhcp2eGIfGKH02dS47FevmSJ22EQNmZUbQwNuwN
         uPr9Zucmib3Xg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 146D5652DC;
        Sat, 23 Jan 2021 02:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/4] net: ipa: remove a build dependency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161136781107.1188.14482443015217936169.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 02:10:11 +0000
References: <20210120212606.12556-1-elder@linaro.org>
In-Reply-To: <20210120212606.12556-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        bjorn.andersson@linaro.org, agross@kernel.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, robh+dt@kernel.org, rdunlap@infradead.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 20 Jan 2021 15:26:02 -0600 you wrote:
> (David/Jakub, please take these all through net-next if they are
> acceptable to you, once Rob has acked the binding.  Rob, please ack
> if the binding looks OK to you.)
> 
> Version 3 removes the "Fixes" tag from the first patch, and updates
> the addressee list to include some people I apparently missed.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/4] net: ipa: remove a remoteproc dependency
    https://git.kernel.org/netdev/net-next/c/86fdf1fc60e9
  - [v3,net-next,2/4] dt-bindings: net: remove modem-remoteproc property
    https://git.kernel.org/netdev/net-next/c/27bb36ed7775
  - [v3,net-next,3/4] arm64: dts: qcom: sc7180: kill IPA modem-remoteproc property
    https://git.kernel.org/netdev/net-next/c/8535c8e30010
  - [v3,net-next,4/4] arm64: dts: qcom: sdm845: kill IPA modem-remoteproc property
    https://git.kernel.org/netdev/net-next/c/5da1fca9eb73

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


