Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5823AD2D6
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhFRTcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233430AbhFRTcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 114CD613F0;
        Fri, 18 Jun 2021 19:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624044605;
        bh=giV3tmQbE2Qn+Q+HxwbvteJI4TIjwT95NSZuWa+Bqbg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oQr7G8I8E040SXGlUqvYSlq+o7LJ2R0povQeAbIbiZhgyb677gQBJYe9rtFc1KkSS
         H6uqBDPBDoOld5AudaHZp/uOIYkEykQ54MR2R+uPWR/hGpbjIVNIAyKx001gWkOE3H
         K+SFM101iZoQHPUtYwLVh1Zu01mQrESM1g7OtENTi31XXC5QsGCFZhLwZSR/a+t4+n
         G2xdHBj7CAUC0T857U1aXb2O+Vnl2O9vaCJWw7LkEN/dv8+4oVrzr+waSG4V8zYUuV
         WpwpWDd8m1kISEqEYIAb+1Lcswx06FaRMPqdvAJp/Qt/PWqSvVoVjrK6dmbS64WJZW
         TKRMaxLLTqBVA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0BE0360C29;
        Fri, 18 Jun 2021 19:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: sja1105: completely error out in
 sja1105_static_config_reload if something fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404460504.16989.15201040720766315763.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:30:05 +0000
References: <20210618134812.2973050-1-olteanv@gmail.com>
In-Reply-To: <20210618134812.2973050-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 16:48:12 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> If reloading the static config fails for whatever reason, for example if
> sja1105_static_config_check_valid() fails, then we "goto out_unlock_ptp"
> but we print anyway that "Reset switch and programmed static config.",
> which is confusing because we didn't. We also do a bunch of other stuff
> like reprogram the XPCS and reload the credit-based shapers, as if a
> switch reset took place, which didn't.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: sja1105: completely error out in sja1105_static_config_reload if something fails
    https://git.kernel.org/netdev/net-next/c/61c77533b82b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


