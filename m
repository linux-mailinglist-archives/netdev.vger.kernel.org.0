Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0EA247E77A
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 19:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349711AbhLWSKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 13:10:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42730 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349630AbhLWSKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 13:10:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0B5FB82178;
        Thu, 23 Dec 2021 18:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E470C36AEB;
        Thu, 23 Dec 2021 18:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640283010;
        bh=MWyr+/8DkSUp50EADqaPK84yt2Ap7lAJ075v3g3tDEc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W4si7fO8cakKm6xSn2qgB+FyXjceMb5qRhWRtGo5YEdPLjKiSWPrc9hv3/fffVaxz
         PMxrNOa+0/nJisc4cUxcRYqYpIW+meIQRqgOQDE0z0labXVReCV2jjYOnqw3jcayR1
         SylEqvCG01ewc1G+yAKGupmpaeGbOVSZm0OwoV4R1jBI/GIOcBELLGXGvb+Jmtw+Fe
         jMqiUBYWROy/22neE0kJlLSHqOShJw3ZZOuzG94RsTbYPdZJgis460GlFwM/9glQPz
         OjR4EkkvoD0piTvPxlRAPSB38dTiK64Kf9JLuFCRwq52Oc7Xf5pXb36dgCLGKVxkzi
         fxDrUhnGKI9FQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 772B1EAC068;
        Thu, 23 Dec 2021 18:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: dwmac-visconti: Fix value of
 ETHER_CLK_SEL_FREQ_SEL_2P5M
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164028301048.27483.16899697963949845934.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Dec 2021 18:10:10 +0000
References: <20211223073633.101306-1-nobuhiro1.iwamatsu@toshiba.co.jp>
In-Reply-To: <20211223073633.101306-1-nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        netdev@vger.kernel.org, yuji2.ishikawa@toshiba.co.jp,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Dec 2021 16:36:33 +0900 you wrote:
> ETHER_CLK_SEL_FREQ_SEL_2P5M is not 0 bit of the register. This is a
> value, which is 0. Fix from BIT(0) to 0.
> 
> Reported-by: Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: stmmac: dwmac-visconti: Fix value of ETHER_CLK_SEL_FREQ_SEL_2P5M
    https://git.kernel.org/netdev/net/c/391e5975c020

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


