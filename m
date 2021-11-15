Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55264450543
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhKONXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:23:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:47014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231911AbhKONXF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 08:23:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8E403630EF;
        Mon, 15 Nov 2021 13:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636982410;
        bh=jNZKOF1BukGdVNvKRa3XEBVb7Jd2No45/uTZbD1e97c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L6SX15RfCr9kVqQ8vsvFxmZBUg1FpgYsdEr1QGdGn0WkP9AAmerYRXCwEFJMi4JMu
         LnM2ehf+5/aAyj+V5lVrnwfKLcoSQhgCtrFVUp/fhgy7K4OcavPXnZKAKXBKyPw5Hs
         575GkvcN1ivawvJa9JsN/a+ip+pK7w9AYr66w2i3KnBYI+Vf5ji9Qn2acIBVIOC/+7
         ZqQFGuww6QAqreLTmMAJs5VwFL89S9R9yK5y1kr6NEJRbxZdkH0/mHXQ0A0qUVLevV
         sXaN14Pfxb/NTX2cHumjJL4UfSB9rR3R+WKsEqRLC/50EZsgBlk9Y+f30SA/ILGMtk
         gnmV906c4Hm5w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 88298609E2;
        Mon, 15 Nov 2021 13:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: vsc73xxx: Make vsc73xx_remove() return
 void
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698241055.21342.7578236006011520924.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 13:20:10 +0000
References: <20211112145352.1125971-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20211112145352.1125971-1-u.kleine-koenig@pengutronix.de>
To:     =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cu=2Ekleine-koenig=40pengutronix=2Ede=3E?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, kuba@kernel.org, davem@davemloft.net,
        kernel@pengutronix.de, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 12 Nov 2021 15:53:52 +0100 you wrote:
> vsc73xx_remove() returns zero unconditionally and no caller checks the
> returned value. So convert the function to return no value.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: vsc73xxx: Make vsc73xx_remove() return void
    https://git.kernel.org/netdev/net-next/c/e99fa4230fa8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


