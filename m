Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDF5465069
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 15:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhLAOxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 09:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhLAOxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 09:53:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E15C061574;
        Wed,  1 Dec 2021 06:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED31DB81FDB;
        Wed,  1 Dec 2021 14:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A321AC53FCD;
        Wed,  1 Dec 2021 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638370209;
        bh=MQu/WgwYC/sMDxn6NplnLsGr5GruDwjWoi3Je0t0ZPY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qwd09AF7aJQM7MmCbkRtC/sWgGXgRiuwh7l+d4967vz2Ul1RcZE5KA1Ca388P3Kq8
         Kafg2fV/TNaVphpsG9Ru/48TGWMrvhT0Rt+VtObnVwvuc3JooT4s01E6U5srQRm4uT
         l8WBptT99kL18k//Ft9KRc8BEJurGHI8S1B9tXsN08/wAECJJ5D/Wf7AhIc4Sow0Fw
         4wmQD7144nIwOojMFfdy8lFbAAMESKvH8mD/zrubalh2R6shBbUYEDfKtqiVlUN1D+
         jqXiPy/H8p7AyNrzVjrgOqUs1i/bzD16wqmk2+8A4EcuI55qsl037SokttbLtRdCwP
         UIN/VBODf5PnQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 888DF60A59;
        Wed,  1 Dec 2021 14:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-11-30
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163837020955.10998.11891388169125578652.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Dec 2021 14:50:09 +0000
References: <20211130181243.3707618-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211130181243.3707618-1-anthony.l.nguyen@intel.com>
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

On Tue, 30 Nov 2021 10:12:41 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Shiraz corrects assignment of boolean variable and removes an unused
> enum.
> 
> The following are changes since commit 196073f9c44be0b4758ead11e51bc2875f98df29:
>   net: ixp4xx_hss: drop kfree for memory allocated with devm_kzalloc
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net/ice: Fix boolean assignment
    https://git.kernel.org/netdev/net-next/c/7b62483f64dd
  - [net-next,2/2] net/ice: Remove unused enum
    https://git.kernel.org/netdev/net-next/c/244714da8d5d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


