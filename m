Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6759F34863D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbhCYBKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:10:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235189AbhCYBKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 21:10:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5632E619EC;
        Thu, 25 Mar 2021 01:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616634608;
        bh=3hq3HKCR3UEK8qbeL++VtdcwpmVIAMm/F7SWAqVNZks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lzewn07A5tpSFqV647jvkMc3HL2vEVjKtwRWHn9IDgBlsiEB1DQry9CX/eX26c/l/
         4JlKHelAEeSnXDMoaILTd0ulA2yn8xEdcDDfNXigEGsEOk5Po6vB5ktiTbbCA5AXI0
         mejinX0lG+E/Jgmr5JoiLIOUnnqerbXqEat29JoO64XG/XgZm+C0IcUZ7uSOaLSbxN
         //fIj017CJHQH7dovn52FeKAcRAzqAiGf+n/j4GEc9Z2cfd02CwAXckHt2KjdQh19L
         RFpZQ6A1c3ec9MQwEp1aFwEDtvQr6lJ+WBRf4+XhQC3LQ0qAkdI9wnmephtucE1xxd
         8B9Iu+DZsyKbg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 42C4460A6A;
        Thu, 25 Mar 2021 01:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: support FPE link partner hand-shaking
 procedure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161663460826.25289.6625842442117364224.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Mar 2021 01:10:08 +0000
References: <20210324090742.3413-1-mohammad.athari.ismail@intel.com>
In-Reply-To: <20210324090742.3413-1-mohammad.athari.ismail@intel.com>
To:     Ismail@ci.codeaurora.org,
        Mohammad Athari <mohammad.athari.ismail@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk,
        qiangqing.zhang@nxp.com, Chuah@vger.kernel.org,
        kim.tatt.chuah@intel.com, fugang.duan@nxp.com,
        boon.leong.ong@intel.com, weifeng.voon@intel.com,
        vee.khee.wong@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 24 Mar 2021 17:07:42 +0800 you wrote:
> From: Ong Boon Leong <boon.leong.ong@intel.com>
> 
> In order to discover whether remote station supports frame preemption,
> local station sends verify mPacket and expects response mPacket in
> return from the remote station.
> 
> So, we add the functions to send and handle event when verify mPacket
> and response mPacket are exchanged between the networked stations.
> 
> [...]

Here is the summary with links:
  - [net-next] net: stmmac: support FPE link partner hand-shaking procedure
    https://git.kernel.org/netdev/net-next/c/5a5586112b92

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


