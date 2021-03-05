Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC7F32F523
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 22:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhCEVKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 16:10:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:51430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhCEVKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 16:10:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 25C1E6509B;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614978609;
        bh=tfYUmsXc+cYJmMT4lfQnI5zjXJDKfH7cTJiFLPkrU5g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uf2VRjGwjoay2V7SkPiABDzdEtcFOMNCCMuvpJELf/WRu5t8EgZ8+QEUuGw+cYR98
         2kHuVrmpo+CHTV1K+U2iAq300SdCo788eztwPYoeo0ztDIDHCGU2o9Wvau75C5OlAX
         UXNvFo4lF1Q2rjS7iksZNsWA2Fhw46k17q4WteGEzZkj1CQEBfq6HLS0rIdLS9hLMT
         sZWngUX5lZVC5OPaGMbp534Tq2gmt2VT4WTy4sryHsXm6rmuUb5Emb/QrxhPyewWcE
         8MyuK0yFm0blf9RApay+rV3Gz15eTHIEUO2gFcgXqj9iGnqcYhU0pPrpzkTNK4PBxq
         b98i1Ge69UWXQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1C57B609D4;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net: stmmac: Fix VLAN filter delete timeout issue in
 Intel mGBE SGMII
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161497860911.24588.15607170379509206328.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Mar 2021 21:10:09 +0000
References: <20210305054930.7434-1-boon.leong.ong@intel.com>
In-Reply-To: <20210305054930.7434-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        weifeng.voon@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  5 Mar 2021 13:49:30 +0800 you wrote:
> For Intel mGbE controller, MAC VLAN filter delete operation will time-out
> if serdes power-down sequence happened first during driver remove() with
> below message.
> 
> [82294.764958] intel-eth-pci 0000:00:1e.4 eth2: stmmac_dvr_remove: removing driver
> [82294.778677] intel-eth-pci 0000:00:1e.4 eth2: Timeout accessing MAC_VLAN_Tag_Filter
> [82294.779997] intel-eth-pci 0000:00:1e.4 eth2: failed to kill vid 0081/0
> [82294.947053] intel-eth-pci 0000:00:1d.2 eth1: stmmac_dvr_remove: removing driver
> [82295.002091] intel-eth-pci 0000:00:1d.1 eth0: stmmac_dvr_remove: removing driver
> 
> [...]

Here is the summary with links:
  - [net,1/1] net: stmmac: Fix VLAN filter delete timeout issue in Intel mGBE SGMII
    https://git.kernel.org/netdev/net/c/9a7b3950c7e1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


