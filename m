Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6959D329409
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 22:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239224AbhCAVpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 16:45:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242918AbhCAVkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 16:40:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B713560232;
        Mon,  1 Mar 2021 21:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614634807;
        bh=e7hOSHEHC601SRODDO4Ugm2gto3mgID6gnXrC+pg6JI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dITUpSSUpiWX+9Jwz5C75Bjwl4f0x9bDU2ZDGdF9ZkP02mTjuH1/sivB+eHRLGX9Y
         qNs2cd+58aKvi2oFHjzvD8HAghdg0XprEIZI4xhWZY7YbRraNLLMQIG0buULieZlLv
         3LwQQJdhXy7bvR1y/6WXl3kih+u2yF02dBpxlt8dN+fQWuh8IdFHDPaeNwnkkr7YIK
         hMAOybFMxTv2ohAZ3O+JS/qFAeETlyGXG8zITLH6KQHgDzQezjGGnzhVHJ4m/VewWu
         mFc9uQJDcwriHZ1V9IRQz40+f2zYXlUWk9wmd07MEZIQ5nWVQ69FQQwCU4mfMN0gNP
         2QpU/yNRSBmSQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A95A160C1E;
        Mon,  1 Mar 2021 21:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net 0/8] Fixes for NXP ENETC driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161463480768.18741.11451492687720022399.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Mar 2021 21:40:07 +0000
References: <20210301111818.2081582-1-olteanv@gmail.com>
In-Reply-To: <20210301111818.2081582-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        michael@walle.cc, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, andrew@lunn.ch,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon,  1 Mar 2021 13:18:10 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This contains an assorted set of fixes collected over the past 2 weeks
> on the enetc driver. Some are related to VLAN processing, some to
> physical link settings, some are fixups of previous hardware workarounds,
> and some are simply zero-day data path bugs that for some reason were
> never caught or at least identified.
> 
> [...]

Here is the summary with links:
  - [v3,net,1/8] net: enetc: don't overwrite the RSS indirection table when initializing
    https://git.kernel.org/netdev/net/c/c646d10dda2d
  - [v3,net,2/8] net: enetc: initialize RFS/RSS memories for unused ports too
    https://git.kernel.org/netdev/net/c/3222b5b613db
  - [v3,net,3/8] net: enetc: take the MDIO lock only once per NAPI poll cycle
    https://git.kernel.org/netdev/net/c/6d36ecdbc441
  - [v3,net,4/8] net: enetc: fix incorrect TPID when receiving 802.1ad tagged packets
    https://git.kernel.org/netdev/net/c/827b6fd04651
  - [v3,net,5/8] net: enetc: don't disable VLAN filtering in IFF_PROMISC mode
    https://git.kernel.org/netdev/net/c/a74dbce9d454
  - [v3,net,6/8] net: enetc: force the RGMII speed and duplex instead of operating in inband mode
    https://git.kernel.org/netdev/net/c/c76a97218dcb
  - [v3,net,7/8] net: enetc: remove bogus write to SIRXIDR from enetc_setup_rxbdr
    https://git.kernel.org/netdev/net/c/96a5223b918c
  - [v3,net,8/8] net: enetc: keep RX ring consumer index in sync with hardware
    https://git.kernel.org/netdev/net/c/3a5d12c9be6f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


