Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C9C45D27B
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347014AbhKYBpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244268AbhKYBnT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 20:43:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A9972610D1;
        Thu, 25 Nov 2021 01:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637804408;
        bh=zuYI0KGqw6w80V5c26J7ZBCR3sWIcykVgOY1mZV/yAg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gmvg/XAW5whK+3sz03z4LHj6FMzld6a7pkGlzklSCc/rzg/GIyLyNCwB0mQdfnANz
         pXv3GxB/55RahDrBTeNbiigEJQpPZcgRjIybQqLtddtBXjmN5P+ncBKlSB1psNiLq0
         rvUBAQM58H1FSICUYtUPmOi3Fz9Sh3seZ9Js9Ri4SkjNK8ETXUcYB0o5hiEe1D3bb5
         oW4E9A/PyvumASrgNzQNwodQw6brdl9x+r0zA7LyiSZrxcY5emkA4tfrJZUfLCIOrR
         XiKPWgU2ZZbJD0BUdPqfBOJnV7MKW+G5+3fDvLS+bKleUwa40fEduMsagzrytWO1Fw
         CDZz/c1+jB2UQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9D3D7609D5;
        Thu, 25 Nov 2021 01:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] net: dsa: qca8k: fix warning in LAG feature
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163780440863.8890.1394468759774734999.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 01:40:08 +0000
References: <20211123154446.31019-1-ansuelsmth@gmail.com>
In-Reply-To: <20211123154446.31019-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 Nov 2021 16:44:46 +0100 you wrote:
> Fix warning reported by bot.
> Make sure hash is init to 0 and fix wrong logic for hash_type in
> qca8k_lag_can_offload.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: qca8k: fix warning in LAG feature
    https://git.kernel.org/netdev/net-next/c/0898ca67b86e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


