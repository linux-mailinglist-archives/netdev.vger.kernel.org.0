Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7718D35B7AB
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 02:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbhDLAKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 20:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235761AbhDLAKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 20:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 28F2E6120A;
        Mon, 12 Apr 2021 00:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618186211;
        bh=9FDWp0iSF0FxkR1Yj9VYr88311CKUKoNrI8bvIXbk44=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rOVFWAJF4VyjK5NBbP6G2ieLVSgMjq3Qtkp9kc0AnANWgClJAWRMWPAv5ntpXlyEw
         m/ZUnZEqge3q3tKTmUrOkBPx4WKBySrsJjU31KJce47hwBTkR+HEAPHYeldMost0EW
         LfiPBX4bDl2bm5ucXyr4GhtA5SyGvMtDnWx0T7G5EaLA9dn06B6nzRDbc6909afCVT
         1Pd3j+lMbKIRfstOtUr5bzuCg9Yf5nwk/1krfhIsz5Q64uvPSpIHJdxjIECjHriElf
         YtDSZvNV+N+JStL8vHQRAhnKkdlZw3/OIz9MKdiGcHC/Cwreg586Z5HMWqQ+sLhEJL
         4ZGC89NsGZJhA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1AD5060A2B;
        Mon, 12 Apr 2021 00:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: ipa: support two more platforms
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161818621110.2274.1292487941066496014.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 00:10:11 +0000
References: <20210409204024.1255938-1-elder@linaro.org>
In-Reply-To: <20210409204024.1255938-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  9 Apr 2021 15:40:20 -0500 you wrote:
> This series adds IPA support for two more Qualcomm SoCs.
> 
> The first patch updates the DT binding to add compatible strings.
> 
> The second temporarily disables checksum offload support for IPA
> version 4.5 and above.  Changes are required to the RMNet driver
> to support the "inline" checksum offload used for IPA v4.5+, and
> once those are present this capability will be enabled for IPA.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] dt-bindings: net: qcom,ipa: add some compatible strings
    https://git.kernel.org/netdev/net-next/c/c3264fee72e7
  - [net-next,2/4] net: ipa: disable checksum offload for IPA v4.5+
    https://git.kernel.org/netdev/net-next/c/c88c34fcf8f5
  - [net-next,3/4] net: ipa: add IPA v4.5 configuration data
    https://git.kernel.org/netdev/net-next/c/fbb763e7e736
  - [net-next,4/4] net: ipa: add IPA v4.11 configuration data
    https://git.kernel.org/netdev/net-next/c/927c5043459e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


