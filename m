Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEC7439738
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhJYNMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230170AbhJYNMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 09:12:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CCD2360F9D;
        Mon, 25 Oct 2021 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635167412;
        bh=eHA66VsrPZv2BLMkIYMn616g+UfpD2V6IIYj6SGiLLM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R9RVgb4W22nVCLC4fGss+mSERX3vBWQIuP2nG7B7Igh8+FkQSdjo/GaVftF69J6mj
         YY4kna0Oz0ge/RguR965FEp1U7+r8SFYIlmzTxPMo2FmmMbAvQaeuQHIlfz9cFKpKV
         KiNNRj/7Hyr2Y3irS1k0Kz7yr3uHF5SV0G9rnIUJvhYwHVNb3jT8d1DtKyGPoYz9AM
         3NW6ZKLTgcf50sIyxPGmWYLjfI+z2NjBja+CQEuIoCSAVjx9cF7eILH1DnyFta+w80
         1iSe+hIqPkO9Ce1K8LEY9MwfUJddELdBI5zAjUrLi979eKE/ZLPvCnqJxaCg/ZDex1
         l3fuGI3Swo0Eg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BB47660A0A;
        Mon, 25 Oct 2021 13:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 0/14] net: phy: Add qca8081 ethernet phy driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163516741276.29679.5814223959477940197.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 13:10:12 +0000
References: <20211024082738.849-1-luoj@codeaurora.org>
In-Reply-To: <20211024082738.849-1-luoj@codeaurora.org>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 24 Oct 2021 16:27:24 +0800 you wrote:
> This patch series add the qca8081 ethernet phy driver support, which
> improve the wol feature, leverage at803x phy driver and add the fast
> retrain, master/slave seed and CDT feature.
> 
> Changes in v7:
> 	* update Reviewed-by tags.
> 
> [...]

Here is the summary with links:
  - [v7,01/14] net: phy: at803x: replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS
    https://git.kernel.org/netdev/net-next/c/c0f0b563f8c0
  - [v7,02/14] net: phy: at803x: use phy_modify()
    https://git.kernel.org/netdev/net-next/c/2d4284e88a59
  - [v7,03/14] net: phy: at803x: improve the WOL feature
    https://git.kernel.org/netdev/net-next/c/7beecaf7d507
  - [v7,04/14] net: phy: at803x: use GENMASK() for speed status
    https://git.kernel.org/netdev/net-next/c/9540cdda9113
  - [v7,05/14] net: phy: add qca8081 ethernet phy driver
    https://git.kernel.org/netdev/net-next/c/daf61732a49a
  - [v7,06/14] net: phy: add qca8081 read_status
    https://git.kernel.org/netdev/net-next/c/79c7bc052154
  - [v7,07/14] net: phy: add qca8081 get_features
    https://git.kernel.org/netdev/net-next/c/765c22aad157
  - [v7,08/14] net: phy: add qca8081 config_aneg
    https://git.kernel.org/netdev/net-next/c/f884d449bf28
  - [v7,09/14] net: phy: add constants for fast retrain related register
    https://git.kernel.org/netdev/net-next/c/1cf4e9a6fbdb
  - [v7,10/14] net: phy: add genphy_c45_fast_retrain
    https://git.kernel.org/netdev/net-next/c/63c67f526db8
  - [v7,11/14] net: phy: add qca8081 config_init
    https://git.kernel.org/netdev/net-next/c/2acdd43fe009
  - [v7,12/14] net: phy: add qca8081 soft_reset and enable master/slave seed
    https://git.kernel.org/netdev/net-next/c/9d4dae29624f
  - [v7,13/14] net: phy: adjust qca8081 master/slave seed value if link down
    https://git.kernel.org/netdev/net-next/c/8bc1c5430c4b
  - [v7,14/14] net: phy: add qca8081 cdt feature
    https://git.kernel.org/netdev/net-next/c/8c84d7528d8d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


