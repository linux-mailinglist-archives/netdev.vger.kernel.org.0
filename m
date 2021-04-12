Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF3735D29D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 23:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244029AbhDLVae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 17:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240321AbhDLVa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 17:30:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0B00461278;
        Mon, 12 Apr 2021 21:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618263009;
        bh=eRKU69GIdF6szFcVc7ExlIOkRKSVezN5BsHcoTBujrM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UU/uiBz2vYA1Vfk+8hh12+YAgD0rhHDeUiUCZ4/Fk7YF2o3BNUu1m8S8B2Oa8QZMU
         arNW2O25XxshgWRzfUS1ffEatYEiKQT+5slMTd37j7PUPtz45BsADDXKvXSZyNvs2j
         31YqHiKiE9Uxftp0OKJkjbaCsQ1YRjoFjOw3qVzbFVpgVfa7SM7yN5f9TzMVlUb2YW
         Ki3iqx3oDC/DT53aKgoKRKqQrJWbMCdeJeHPPQZ7g7VNHRrDN4IxwZbJcA5fYR8HKx
         hksoUhcdWFeTDyXl7Di1gzXA3FL5CKmAgymqPTNULdFWNhbI8g2enIINgx0Se+5Kcx
         gdWyk6Aal5jGA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F258560BD8;
        Mon, 12 Apr 2021 21:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: phy: marvell: fix detection of PHY on Topaz switches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161826300898.30008.38457086565901106.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 21:30:08 +0000
References: <20210412165739.27277-1-pali@kernel.org>
In-Reply-To: <20210412165739.27277-1-pali@kernel.org>
To:     =?utf-8?b?UGFsaSBSb2jDoXIgPHBhbGlAa2VybmVsLm9yZz4=?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kabel@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 12 Apr 2021 18:57:39 +0200 you wrote:
> Since commit fee2d546414d ("net: phy: marvell: mv88e6390 temperature
> sensor reading"), Linux reports the temperature of Topaz hwmon as
> constant -75°C.
> 
> This is because switches from the Topaz family (88E6141 / 88E6341) have
> the address of the temperature sensor register different from Peridot.
> 
> [...]

Here is the summary with links:
  - [v2] net: phy: marvell: fix detection of PHY on Topaz switches
    https://git.kernel.org/netdev/net/c/1fe976d308ac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


