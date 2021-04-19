Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F5F364DC1
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhDSWk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhDSWkl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 18:40:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B1C6E613B0;
        Mon, 19 Apr 2021 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618872010;
        bh=+MgneAzMiUbdwvs3A/8M6c8r8cUGinT0H+o0HDpl6D8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QQvKOP1gVBBdu34mdIQJ+hEem53aBMBkHWkj/7YTN2lhxERNXonr5S3zZWwc3tgdA
         DSW/viG6FLTu91YylbCBMcOcj0WiXyy+7LQ6naHB7uhPWdpxd425CtoIgIk64K5RlK
         pZk09VMOC6J/aoH2RxoivrB55E/ytycrGnnMyuy6ONSSaOo6Tixqzf1/EUTuR5i3ri
         bRHcnVc42EwMKYjytUAW/+/zdT7zVQF3wYa0wQqn9IbZWZsZy2ejuVONuJ3e4NsBEd
         RMmvX+3GAbNk3GwaoMSsOCbAZoqcToSRTMoX9F5Sr6h7IAd2i49fBemu2BMzpfa1Jo
         qRTy4gSRv7axQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AB02660A13;
        Mon, 19 Apr 2021 22:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] Flow control for NXP ENETC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887201069.19818.8834514668475852756.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 22:40:10 +0000
References: <20210416234225.3715819-1-olteanv@gmail.com>
In-Reply-To: <20210416234225.3715819-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, robh+dt@kernel.org,
        shawnguo@kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        michael@walle.cc, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 17 Apr 2021 02:42:20 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This patch series contains logic for enabling the lossless mode on the
> RX rings of the ENETC, and the PAUSE thresholds on the internal FIFO
> memory.
> 
> During testing it was found that, with the default FIFO configuration,
> a sender which isn't persuaded by our PAUSE frames and keeps sending
> will cause some MAC RX frame errors. To mitigate this, we need to ensure
> that the FIFO never runs completely full, so we need to fix up a setting
> that was supposed to be configured well out of reset. Unfortunately this
> requires the addition of a new mini-driver.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: enetc: create a common enetc_pf_to_port helper
    https://git.kernel.org/netdev/net-next/c/87614b931c24
  - [net-next,2/5] dt-bindings: net: fsl: enetc: add the IERB documentation
    https://git.kernel.org/netdev/net-next/c/4ac7acc67f29
  - [net-next,3/5] net: enetc: add a mini driver for the Integrated Endpoint Register Block
    https://git.kernel.org/netdev/net-next/c/e7d48e5fbf30
  - [net-next,4/5] arm64: dts: ls1028a: declare the Integrated Endpoint Register Block node
    https://git.kernel.org/netdev/net-next/c/b764dc6cc1ba
  - [net-next,5/5] net: enetc: add support for flow control
    https://git.kernel.org/netdev/net-next/c/a8648887880f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


