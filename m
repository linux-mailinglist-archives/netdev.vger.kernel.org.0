Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FE03D11D1
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239428AbhGUOWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239444AbhGUOTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 10:19:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A89216124B;
        Wed, 21 Jul 2021 15:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626879604;
        bh=YUBv7790juyn2lxQWUWQ/DzcSzpURc+T9lVjz/9WBrc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FPAP3bMUTo1TQCNma3Sejc8VLNFKWhL90ZcZZPUaKg4dhR5IKJAjCyGvHM+XiM5Jg
         /DEsdnogAH3th8R33o/YdkvQkThRwe4Wv41c0OxddXGwYQ3HzFW1r9seguCJo6xr4w
         oLroLwazd5gTyRL1U3brgbGvhXWlcWjUPv153P7dy+Ox55WGcR2hBrlvldDAY2yxXh
         n1HzZUhO1JryN8W7hR9kh996txOQ0NaM/oPBHTA9yjgwfVkvcnvag9X8QcsLzb3ei5
         G2xnXoJzmqkMqk/CdmZgPr3+WSxA2LW2/bFZ4/vp7RlKMeYJXmOunH7Ka6QdBthlJY
         3L2Xa6n2lcblA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9D7F460CD3;
        Wed, 21 Jul 2021 15:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: at803x: finish the phy id checking
 simplification
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162687960464.27043.4996934551369498081.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 15:00:04 +0000
References: <20210720172433.995912-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210720172433.995912-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        festevam@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Jul 2021 20:24:33 +0300 you wrote:
> The blamed commit was probably not tested on net-next, since it did not
> refactor the extra phy id check introduced in commit b856150c8098 ("net:
> phy: at803x: mask 1000 Base-X link mode").
> 
> Fixes: 8887ca5474bd ("net: phy: at803x: simplify custom phy id matching")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: at803x: finish the phy id checking simplification
    https://git.kernel.org/netdev/net-next/c/f5621a01c86b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


