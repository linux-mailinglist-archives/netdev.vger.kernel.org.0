Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BC63412B9
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 03:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhCSCUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 22:20:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231266AbhCSCUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 22:20:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7FB0864F69;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616120412;
        bh=jNyUZfXlsLhgllYvYDrVviadzfncXMj2v5qCCP9M23Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bvXg9joYsFTdiRkt5TwD7WiYeSaOmxSt7bgWjsM0Q6bAd9qf02SDUvuSQhyHGV2ak
         56uIg2izUMlB85cG3Ho0Z8Pb40GQSQWqC2oFQK/G6Fo4EXftIq0xiqWbf/sQ2R+GSa
         A2ukSb0JDMmcWvLEcwjd7G4DBPn9eO82b4EwvreIkY3bu7jDvrUtp8QrBIboBc+mR8
         +Z6vqbRwGjD4c9MRz+svbtUdxKbB1CHm+7x/2H+aOoW/GyanwBIjkpP/fdo3fvn/e+
         qCiKqTfszX2fok0LpUuViE0Iw6B4eIraFfgemci0pltFLKrElPYc7fvzyESWKfouyT
         42qp9EnoVsmGA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 72C2160997;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/1] stmmac: add PCH and PSE PTP clock setting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161612041246.22955.7315779436357052148.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 02:20:12 +0000
References: <20210317013247.25131-1-boon.leong.ong@intel.com>
In-Reply-To: <20210317013247.25131-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        weifeng.voon@intel.com, vee.khee.wong@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Mar 2021 09:32:46 +0800 you wrote:
> Hi,
> 
> Intel mGBE controllers that are integrated into EHL, TGL SoC have
> different clock source selection. This patch adds the required setting for
> running linuxptp time-sync.
> 
> The patch has been tested on both PSE (/dev/ptp0) and PCH TSN(/dev/ptp2)
> and the results for the time sync looks correct.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] stmmac: intel: Add PSE and PCH PTP clock source selection
    https://git.kernel.org/netdev/net-next/c/76da35dc99af

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


