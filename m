Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2EB2FDB10
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388418AbhATUnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:43:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388761AbhATUlA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 15:41:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B51AF235F7;
        Wed, 20 Jan 2021 20:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611175219;
        bh=HI/wzQ4N2mmemZh/ROgouP4NvuKtskCJbdebKaBFIMs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vHj9cM3RUVinpaP+i/zP1ngpE+9lgqGY7I83s+xim2FpLFbGW52utcc5IegazJ6lW
         HjUkcCRK+jpwb6Fk1Pm4KBCUxVZyqQOWHndn8zKltqCQZ4kqK6q6v78hsH076qcvDz
         1jtSarIXD0kpNVLXY/X89oe5ULhCbUGi0O6ctz+Z+sg1Ywg+5p3zIBnscHJxy0a3NS
         27nq2yAu9fHyAX/6lQnGAOGaLVzKWYC5IUwuyiBnP2sKzChFAjuhu/kKHg/EoG1Ckb
         ZFmdQLEebPBlHtctgmBw7g+ILaGBqotFHe0rxRaC0pywyClHO0LBo9USJuWbp2MibI
         vqPh5+P8fe/CQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id ABC6F6063C;
        Wed, 20 Jan 2021 20:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can 2021-01-20
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161117521969.21178.9145815988654345424.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jan 2021 20:40:19 +0000
References: <20210120125202.2187358-1-mkl@pengutronix.de>
In-Reply-To: <20210120125202.2187358-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Wed, 20 Jan 2021 13:51:59 +0100 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 3 patches for net/master.
> 
> All three patches are by Vincent Mailhol and fix a potential use after free bug
> in the CAN device infrastructure, the vxcan driver, and the peak_usk driver. In
> the TX-path the skb is used to read from after it was passed to the networking
> stack with netif_rx_ni().
> 
> [...]

Here is the summary with links:
  - pull-request: can 2021-01-20
    https://git.kernel.org/netdev/net-next/c/535d31593f59

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


