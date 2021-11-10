Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2244244C327
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 15:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhKJOnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:43:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232269AbhKJOm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 09:42:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9029561264;
        Wed, 10 Nov 2021 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636555208;
        bh=ERa8z50UzvcG4hoR2G8XB2JonjF2th8Q8cVgfCVS+Ek=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YVD3Hlqwf9ikZ4n1AxK7NU9zWluRyDZ7Z5C2+8Ae/i/BLVKz7/Hqj38qV1mRO4rtZ
         b+GQ3H3mJMxEWTcjOxC6vbPAgbOF43GwRubeMooTxGiuKfHRFkOBG/b4KrzuPp1iL3
         rCtLA1dvc8roBgIpEYB5ZeREjbfyIaWhjtE98M6Fq/so3bflO1Y0QwvUz8qyLMA68K
         L3hxJFaoX2J0kUw5J7UcFc3SQJjLD9DoI0d+ofI8o2BSG8Yb03mQCa+mUqv2XHLVZe
         T+G8SwVzCL5EQDgoniUnhkI9ic4ISH1Mh3MeCryzqqnV4kER6MXsBVoJaQn75yxZLw
         CwNTkI87/gCkg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7F89A60A5A;
        Wed, 10 Nov 2021 14:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: allow a tc-taprio base-time of zero
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163655520851.19242.2773768133414182756.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Nov 2021 14:40:08 +0000
References: <20211108202854.1740995-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211108202854.1740995-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        xiaoliang.yang_1@nxp.com, yannick.vignon@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  8 Nov 2021 22:28:54 +0200 you wrote:
> Commit fe28c53ed71d ("net: stmmac: fix taprio configuration when
> base_time is in the past") allowed some base time values in the past,
> but apparently not all, the base-time value of 0 (Jan 1st 1970) is still
> explicitly denied by the driver.
> 
> Remove the bogus check.
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: allow a tc-taprio base-time of zero
    https://git.kernel.org/netdev/net/c/f64ab8e4f368

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


