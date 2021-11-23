Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5304045A270
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbhKWMXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:23:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237071AbhKWMXU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:23:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1522C6108D;
        Tue, 23 Nov 2021 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637670012;
        bh=T9aGTcJ6fJmohPuVjHm+68vCl9LzAsDwZBGAlnBRPas=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qDsccMh6G+Q5JB0WoCdYNKnrbCB7lr0lJ2n5HWsRSihbtkFT97KYio+ALOb3HKIDJ
         ZwWDnNLAqysJSNobmq0VyS+krhMRPDb/VloRPvz1ownljktLtF1nUnA8y6gTSIc4JA
         PbDsj2i+fUHUxsj6Q3e6EiDKW4HF2L0lQAapj3MWx9NXWbGWO5G1R2lbxiEscTrkE1
         wcF99Mc4VGRFXEN9QjJasXBs4wR2V9ig54MMzrXGuOs2ZBi10BJcZTdadRc8xt0Hnh
         XSYDF+AbhdOzf6m43aoRvody2pN1ba8QrYU8iJFHTu9YLZv/BNYspcACDuNC/vzIbp
         8q9HgKCsRIyng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0E8D460A50;
        Tue, 23 Nov 2021 12:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-11-22
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163767001205.10565.2852083634552212032.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 12:20:12 +0000
References: <20211122211119.279885-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211122211119.279885-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com, jacob.e.keller@intel.com,
        parav@nvidia.com, jiri@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 22 Nov 2021 13:11:16 -0800 you wrote:
> Shiraz Saleem says:
> 
> Currently E800 devices come up as RoCEv2 devices by default.
> 
> This series add supports for users to configure iWARP or RoCEv2 functionality
> per PCI function. devlink parameters is used to realize this and is keyed
> off similar work in [1].
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] devlink: Add 'enable_iwarp' generic device param
    https://git.kernel.org/netdev/net-next/c/325e0d0aa683
  - [net-next,2/3] net/ice: Add support for enable_iwarp and enable_roce devlink param
    https://git.kernel.org/netdev/net-next/c/e523af4ee560
  - [net-next,3/3] RDMA/irdma: Set protocol based on PF rdma_mode flag
    https://git.kernel.org/netdev/net-next/c/774a90c1e1a3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


