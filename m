Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0BE364DBF
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhDSWkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230035AbhDSWkl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 18:40:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C060A613B4;
        Mon, 19 Apr 2021 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618872010;
        bh=0CZNO8hyH+fKbxkNnczU10+6omeA2VPUHu0LGjIKdeQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tEJWZmtHOTZZsgk6SA4q39gPlf2QA9yMuKDyiAmMTNxyncYqkT31/NLAZImfaw/dE
         wAxo4AgRtbP2m7v5eo1OCb/frG3ReNkjmPxLEIWcHPnyGLsnoNclSQUDyaVNznMupz
         wnZSn3X7WoHX+E1hcNB9DU2kjB1MjusSXAj8bZj57TLokPQb1q85GTINzb1sR/GmkM
         ExahfZEnNkCTSs5dkaqDyDpOL4iSgwx2W/CgKNm8PBEfxBj1la1rXf/eq3zFrpjmWy
         /5sp1Sy06MT+qOyhvHbCgOKZY1tfd37m+2WeadGw13fC0rwCvDyLhPymRhvYJNJwB3
         eNPcoE7wF8R0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B64D360A0B;
        Mon, 19 Apr 2021 22:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: xilinx: drivers need/depend on HAS_IOMEM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887201074.19818.16227750410664983214.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 22:40:10 +0000
References: <20210417065554.11968-1-rdunlap@infradead.org>
In-Reply-To: <20210417065554.11968-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, lkp@intel.com,
        radhey.shyam.pandey@xilinx.com, gary@garyguo.net,
        zhangchangzhong@huawei.com, andre.przywara@arm.com,
        stable@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Apr 2021 23:55:54 -0700 you wrote:
> kernel test robot reports build errors in 3 Xilinx ethernet drivers.
> They all use ioremap functions that are only available when HAS_IOMEM
> is set/enabled. If it is not enabled, they all have build errors,
> so make these 3 drivers depend on HAS_IOMEM.
> 
> ld: drivers/net/ethernet/xilinx/xilinx_emaclite.o: in function `xemaclite_of_probe':
> xilinx_emaclite.c:(.text+0x9fc): undefined reference to `devm_ioremap_resource'
> 
> [...]

Here is the summary with links:
  - [net-next] net: xilinx: drivers need/depend on HAS_IOMEM
    https://git.kernel.org/netdev/net-next/c/46fd4471615c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


