Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19F937306F
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 21:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhEDTLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 15:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhEDTLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 15:11:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2CC5061182;
        Tue,  4 May 2021 19:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620155410;
        bh=r2bSYkSM5y7N1co+6dpHXHQ0FQC9UWRYwRDO8hODpVI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GtmbjyJUBl/3R/+W2hipJXES4NoqnN4VlBYbbP8Tqtvq4Ynadn/CRfiirdVFLNH4O
         OyJPg88kMZIM96DPK+YxVfFUOEik36EJG6vTproyfkR4FIoPm0vQV/X1fRf8jMnT11
         /eIJkikl0vCjcaXPVJ3gnDsfxaY46vL/+WxVPJIKWP5wboOkCGQVRz+LHTazoLD0B7
         ih4OWpppyqIxDT9ZD97iGWnp3rhfLNVDC/NbVtPGfyH3V7ipcCqP+QHaLOyDsWsher
         sICY4HMsb4LybN9OYbG3MFaL71+oMlwuibakpt/XcVHrHFRey996wrPYzdVbqAZmT+
         BZT7f4PVfcQsQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1A73A609F5;
        Tue,  4 May 2021 19:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net: stmmac: Clear receive all(RA) bit when
 promiscuous mode is off
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162015541010.23495.12824554221267903248.git-patchwork-notify@kernel.org>
Date:   Tue, 04 May 2021 19:10:10 +0000
References: <20210504154241.1165-1-ramesh.Babu.B@intel.com>
In-Reply-To: <20210504154241.1165-1-ramesh.Babu.B@intel.com>
To:     Ramesh Babu B <ramesh.babu.b@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com,
        vee.khee.wong@intel.com, ramesh.Babu.B@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  4 May 2021 21:12:41 +0530 you wrote:
> From: Ramesh Babu B <ramesh.babu.b@intel.com>
> 
> In promiscuous mode Receive All bit is set in GMAC packet filter register,
> but outside promiscuous mode Receive All bit is not cleared,
> which resulted in all network packets are received when toggle (ON/OFF)
> the promiscuous mode.
> 
> [...]

Here is the summary with links:
  - [net,1/1] net: stmmac: Clear receive all(RA) bit when promiscuous mode is off
    https://git.kernel.org/netdev/net/c/4c7a94286ef7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


