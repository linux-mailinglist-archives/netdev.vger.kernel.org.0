Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF6D3813C9
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbhENWba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:31:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233666AbhENWbW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 18:31:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 864A561453;
        Fri, 14 May 2021 22:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621031410;
        bh=qrJLP/r3A3y/0MyfEURktG+DB4zmp3lLFDGbBMOKB8A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P0zgoaprDJvd98bH2YsY9oRsUbNpX6X8rgv/5veHPFVbyZwKiayQ+lnPqhh61onti
         /qgzqCR38fonvkdjL5sUGDu2+AaxoIKOXMHXvG+q91G5ZwsLOu9QuvS8gOKseqEoa3
         z+j6b7QjwOBdcIG9bzVNluyZQdJux6OLi8vkxm4MLMCTm9UIzH1AAdtgAvaBTo4nSv
         hQ+1vvNZrSlA75KQ7SJ39pc3U2qCIIWPc2M+mHWXdka1QFkfvnRxKEGL4xqNVJVFfy
         ysPhyEIXgQa/RHfOIy2Bzug07IMfmVNyvc6h8nsBhO0+MK64/mbSpbRNFHk76WQPnt
         CNBQlmO82/NXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 788F260A02;
        Fri, 14 May 2021 22:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: use XDP helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162103141048.10202.7043185141593053010.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 22:30:10 +0000
References: <20210514183954.7129-1-mcroce@linux.microsoft.com>
In-Reply-To: <20210514183954.7129-1-mcroce@linux.microsoft.com>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        linux-stm32@st-md-mailman.stormreply.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        mst@redhat.com, jasowang@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 14 May 2021 20:39:51 +0200 you wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> The commit 43b5169d8355 ("net, xdp: Introduce xdp_init_buff utility
> routine") and commit be9df4aff65f ("net, xdp: Introduce xdp_prepare_buff
> utility routine") introduces two useful helpers to populate xdp_buff.
> Use it in drivers which still open codes that routines.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] stmmac: use XDP helpers
    https://git.kernel.org/netdev/net-next/c/d172268f93cf
  - [net-next,2/3] igc: use XDP helpers
    https://git.kernel.org/netdev/net-next/c/082294f294f6
  - [net-next,3/3] vhost_net: use XDP helpers
    https://git.kernel.org/netdev/net-next/c/224bf7db5518

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


