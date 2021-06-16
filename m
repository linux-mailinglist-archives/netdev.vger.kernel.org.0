Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4789C3AA49B
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbhFPTwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:52:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231181AbhFPTwL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:52:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 071C7613C2;
        Wed, 16 Jun 2021 19:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623873005;
        bh=xnPGz+j4qT0oXamCndg9kIHjVv0P6tZaWNZ0E/82KsI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QQWizqaLNhYNoTdU1Bla41FvnFND/9qLETNWx/Otdb2hthol8la3OkPqBw1tqmCC/
         of96g9TSATu9uTSFMHmx5OcXcIgvDIzX+aOOpL7iDUJHNbc1aPBqy+01ISXbHWLzJe
         3TxXBuyfUBsqfliS+pnkiDpASd8BALrPzcRXn70OwxZKDitbMQnuSy2T3AwqU7oKGR
         3RZoB/mkIhWks2mBZRoclvQXOezD6q0vngsLnf05pwnK62AbNSOAwA9V3DLYiZzA7g
         +k+/N/BEjow5qxxopU4UTJENEMcDrIjGrlnLV6o8mK69Mx4A/na/p1B/XVJ9CKFfsN
         UUBmkqt98ZHcg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 006D5609E7;
        Wed, 16 Jun 2021 19:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: fixes for fec ptp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387300499.13042.8545046199906380662.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 19:50:04 +0000
References: <20210616091426.13694-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210616091426.13694-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 16 Jun 2021 17:14:24 +0800 you wrote:
> Small fixes for fec ptp.
> 
> Fugang Duan (1):
>   net: fec_ptp: add clock rate zero check
> 
> Joakim Zhang (1):
>   net: fec_ptp: fix issue caused by refactor the fec_devtype
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: fec_ptp: add clock rate zero check
    https://git.kernel.org/netdev/net/c/cb3cefe3f3f8
  - [net,2/2] net: fec_ptp: fix issue caused by refactor the fec_devtype
    https://git.kernel.org/netdev/net/c/d23765646e71

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


