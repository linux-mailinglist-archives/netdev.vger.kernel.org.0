Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C52362B9F
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhDPWui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhDPWuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 18:50:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C145661107;
        Fri, 16 Apr 2021 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618613409;
        bh=BcMfaqJUyRjPaFZGv5Tmm86/8509Gya+dkaWpiYkqes=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UGsKeNDduKuzCx4d81XNGj7TZk1v6wgogn8b8573ktbf/4+ZN7pImvl6nL228YZl4
         zFwLZZA00FW1E1FrQHt7M+6dsWAZn1acAJDeRZnzQ0jnTHKn2nQOok0i7C9RkK7ZCX
         NclnU0w/BgU5ZKh3gL/4Ap31wCbYZWuh57zPdfrOz7SrMQbU/4j2jhUvfKzeKyxHs+
         IOcmAGQZjrKgqme1Q4pjr7l2LuXBFb1nm0DqUaRPP0QubuqB4iaG7sSOGtp/A2bXBk
         FSWuXLw59N3kDbnshvdCTvcdF653gQ4yzrlaUd8qqfVike73OqsVh+ix5JMNZN5umc
         xouig0C1QE4/A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B354360CD6;
        Fri, 16 Apr 2021 22:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: ipa: allow different firmware names
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161861340973.29090.15022740870858243639.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Apr 2021 22:50:09 +0000
References: <20210416130850.1970247-1-elder@linaro.org>
In-Reply-To: <20210416130850.1970247-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        bjorn.andersson@linaro.org, agross@kernel.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Apr 2021 08:08:48 -0500 you wrote:
> Add the ability to define a "firmware-name" property in the IPA DT
> node, specifying an alternate name to use for the firmware file.
> Used only if the AP (Trust Zone) does early IPA initialization.
> 
> 					-Alex
> 
> Alex Elder (2):
>   dt-bindings: net: qcom,ipa: add firmware-name property
>   net: ipa: optionally define firmware name via DT
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] dt-bindings: net: qcom,ipa: add firmware-name property
    https://git.kernel.org/netdev/net-next/c/d8604b209e9b
  - [net-next,2/2] net: ipa: optionally define firmware name via DT
    https://git.kernel.org/netdev/net-next/c/9ce062ba6a8d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


