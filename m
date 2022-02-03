Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270024A7F1D
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 06:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236581AbiBCFaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 00:30:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40618 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiBCFaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 00:30:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D08CF61518;
        Thu,  3 Feb 2022 05:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A5BCC340ED;
        Thu,  3 Feb 2022 05:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643866209;
        bh=L9vBEUjwBOia/wbBGPnSEDGQZPDW1csQNMlCjD1v4EI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ul1JF4w1TzQ1bB7pRAfhiI/u7YnHa5zXeVB3pb2Cle+Dr6L4NwrtVIfb78wcF/lJd
         yVCtTEY+vcQsHLcGNLvaAqaIceoC25RmTsbt12FsTzi0U0zYPY9vpTYBPMXLdxZGhQ
         RQ+gGKhZvhq1Sx43nUGY74rW7kjLUj0gxnJK1EOkKFTeGaEadHpCaqbsr/mJEh8i1h
         oowaFzEhRJLFH8FJ8+b4KKP8v9HctQk2vD+cat4zlbVpdOmURP52H4qHG77fnVVeuA
         7xjAALb5WS5Yvm+VNlPf87t90mETZcNMRWmTaVvYPHl5Qy0y7SfTtM+oqIJp7zXiFo
         3a+lTa02+xBbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 249DEE6BB3D;
        Thu,  3 Feb 2022 05:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: ipa: support variable RX buffer size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164386620914.2374.12939383239153154522.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Feb 2022 05:30:09 +0000
References: <20220201153737.601149-1-elder@linaro.org>
In-Reply-To: <20220201153737.601149-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        agross@kernel.org, mka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  1 Feb 2022 09:37:35 -0600 you wrote:
> Specify the size of receive buffers used for RX endpoints in the
> configuration data, rather than using 8192 bytes for all of them.
> Increase the size of the AP receive buffer for the modem to 32KB.
> 
> 					-Alex
> 
> Alex Elder (2):
>   net: ipa: define per-endpoint receive buffer size
>   net: ipa: set IPA v4.11 AP<-modem RX buffer size to 32KB
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: ipa: define per-endpoint receive buffer size
    https://git.kernel.org/netdev/net-next/c/ed23f02680ca
  - [net-next,2/2] net: ipa: set IPA v4.11 AP<-modem RX buffer size to 32KB
    https://git.kernel.org/netdev/net-next/c/33230aeb2ef4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


