Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0371B472C9A
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 13:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbhLMMuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 07:50:17 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:53248 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbhLMMuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 07:50:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E052ECE0FFC;
        Mon, 13 Dec 2021 12:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 145D9C34604;
        Mon, 13 Dec 2021 12:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639399810;
        bh=IkIPZYonsJrPkJsvdsaXOjan0FkyBQOEN9tyVjgrePY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mJgt1mcJoa1JhZsWsgT/COClnMIeql9OrHcucwsi+qy6kCWdcrgAbNZXTIMGvDljs
         MB+t7kR+WEoGz8lMRLWI1D7oKDqofFQZrzL+GFwqmFr6mgFsOb/G372xxiiAAwP9UM
         Pbd0k2cHcI/03S/6NcaAro13KH/JbEJhy5/s+WYnvueHNDR7CP+2b+iLEKDf1v48oP
         1IPTTwD9KPgxopjPKvEMrcWJL8z7OovrsndMf1y1+9s2JHVa+qkSVGXTNyDXW6P1Fh
         XDK5hIY6E3fd4psTARWYZwiROh8eFpRlf9Yhr2LhPLDiLez3eDZIqFaAaAA9r4xU6Z
         H2072T+NZ6E8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E6DDA609CD;
        Mon, 13 Dec 2021 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] net: ipa: fix SDX55 interconnects
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163939980994.30215.13765984961619992251.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 12:50:09 +0000
References: <20211210223123.98586-1-elder@linaro.org>
In-Reply-To: <20211210223123.98586-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, david@ixit.cz,
        manivannan.sadhasivam@linaro.org, jponduru@codeaurora.org,
        avuyyuru@codeaurora.org, bjorn.andersson@linaro.org,
        agross@kernel.org, robh+dt@kernel.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, mka@chromium.org, evgreen@chromium.org,
        elder@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Dec 2021 16:31:21 -0600 you wrote:
> The SDX55 SoC has IPA v4.5.  It currently represents the path
> between IPA and main memory using two consecutive interconnects.
> This was an optimization--not required for correct operation--and
> complicates things unnecessarily.  It also does not conform to the
> IPA binding (as pointed out by David Heidelberg).
> 
> This series fixes this by combining the two interconnects into one.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] ARM: dts: qcom: sdx55: fix IPA interconnect definitions
    https://git.kernel.org/netdev/net-next/c/c0d6316c238b
  - [net-next,v2,2/2] net: ipa: fix IPA v4.5 interconnect data
    https://git.kernel.org/netdev/net-next/c/97884b07122a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


