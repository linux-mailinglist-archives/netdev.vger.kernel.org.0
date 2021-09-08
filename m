Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B33B403805
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 12:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347176AbhIHKlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 06:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234672AbhIHKlQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 06:41:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 303E56113E;
        Wed,  8 Sep 2021 10:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631097608;
        bh=cwGwpyPgGjtx7N76e9aQnnpNpHqqVis1mt5jprqX9iU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K6NjXNn4YUQK9alkY5m/RmXF4/egz6y1fS1/BZg58O82ZvI0QPwtdUAc6//NFhSWd
         q/5uAFr0NgWLuhniY722XjUE5xHjk32ybHKy+8NF1kAx5eHto1Z4Kn8CGduAaL1tmb
         oOy8wo4edVNq13SKlr3696Ihb3W8LJ6BN/BISIh0Gkm/Yy70WRbQcJiJPaNG9fegsi
         J0ueU1p9lG7rOm93IbFy/AFcegZn7Twi3RIEqvdjvVdHrdPHNFbSW0u9KTRlFBT/nO
         pt0pOFkHvB9sgwZ5lm5FJi5OD16b/vuoH1LgzLZhS8jX8fM46j+FXnHFNLiGw5zsGr
         4hwVoJmdfMcCg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2A10860A6D;
        Wed,  8 Sep 2021 10:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: sun8i-emac: Add compatible for D1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163109760816.16056.7636731189140150415.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Sep 2021 10:40:08 +0000
References: <20210908030240.9007-1-samuel@sholland.org>
In-Reply-To: <20210908030240.9007-1-samuel@sholland.org>
To:     Samuel Holland <samuel@sholland.org>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        mripard@kernel.org, wens@csie.org, jernej.skrabec@gmail.com,
        guoren@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  7 Sep 2021 22:02:40 -0500 you wrote:
> The D1 SoC contains EMAC hardware which is compatible with the A64 EMAC.
> Add the new compatible string, with the A64 as a fallback.
> 
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> ---
>  .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml    | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - dt-bindings: net: sun8i-emac: Add compatible for D1
    https://git.kernel.org/netdev/net/c/0f31ab217dc5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


