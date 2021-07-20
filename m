Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7CC3CFC06
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239419AbhGTNoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239976AbhGTNj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:39:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 450AD611F2;
        Tue, 20 Jul 2021 14:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626790805;
        bh=p+br29W5ktmzN2KC833uxKVEE2/+qI9VEz23Jm+x70Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EtaGiMmrLJqeBbbKF2gWpWBFVYX7Rra+LOrgyhoqmyXi+tHuxQBEy7DJmabvMgdR6
         iy1nmQdpla8x4eJdd+utDxNZPYWrivFPo0FwUxsUN4ZZpa5zMqcLleqzv2ZraCfD9E
         IGmDu91WjqaimoAygxsfUs6buZ4lrfbgkjOhjxSS2BMm09qer9G4pXrFOFTKNSHxr/
         y7O2n9oQSxmuzIX6qTRbGed9Az3nRc+IjxRT11g2hZxOUPwyfVcHNAdJqLuTOeCcAx
         PV2a5PTM9I2dLNIUHJFCIxkt+EDaLcBJyCZfwETa7rJWnLd3osw+zEev4cPQHcCvOX
         ejPeCFQIG1TmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3DF4560CCF;
        Tue, 20 Jul 2021 14:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] arm64: dts: qcom: DTS updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162679080524.18101.16626774349145809936.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 14:20:05 +0000
References: <20210719212456.3176086-1-elder@linaro.org>
In-Reply-To: <20210719212456.3176086-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, robh+dt@kernel.org,
        davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Jul 2021 16:24:53 -0500 you wrote:
> This series updates some IPA-related DT nodes.
> 
> Newer versions of IPA do not require an interconnect between IPA
> and SoC internal memory.  The first patch updates the DT binding
> to reflect this.
> 
> The second patch adds IPA information to "sc7280.dtsi", using only
> two interconnects.  It includes the definition of the reserved
> memory area used to hold IPA firmware.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] dt-bindings: net: qcom,ipa: make imem interconnect optional
    https://git.kernel.org/netdev/net-next/c/6a0eb6c9d934
  - [net-next,2/3] arm64: dts: qcom: sc7280: add IPA information
    https://git.kernel.org/netdev/net-next/c/f8bd3c82bf7d
  - [net-next,3/3] arm64: dts: qcom: sc7180: define ipa_fw_mem node
    https://git.kernel.org/netdev/net-next/c/fd0f72c34bd9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


