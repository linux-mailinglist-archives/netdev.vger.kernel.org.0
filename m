Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5A1386D70
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 01:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344337AbhEQXBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 19:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238821AbhEQXB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 19:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 839496134F;
        Mon, 17 May 2021 23:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621292412;
        bh=zseJInV76JwddU8WjJbwFCXdZiWWLZ6gbeEwTjl1Yo8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=usc3cjlKQl8apO71D1hwDpJmrMMEVe0IhCgMwYQH7n+D3zcOYCoxoeuKHU4Ux/vHz
         pXRfyvSvAkHX+7uN8VZUNa5sPgsYjhzHhyCzh5DeyPC3sDIqCoISeLArJ0yccOemKf
         y8viuI46EMhk+KFTfxE4455auaNTfFQZA5Ez415g7c6up+CGwjun13w8577Es48YKT
         jb+Hq1x5Sf4KtlH76uFFEyZZwzPocaQwOeZx2QWSQsRKs7HuGk4coQ9mbAnXB0WRoT
         jM4/VeqLREwo9xXSRjxfkqBP9BzG7BIcDkYAwhHS35ipYHGUuZOjnvsB+5yqyQQgVj
         FbYR5yzOY1ptQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7C50A60A4D;
        Mon, 17 May 2021 23:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Introducing support for DWC xpcs Energy
 Efficient Ethernet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162129241250.19462.16193417271658339119.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 23:00:12 +0000
References: <20210517094332.24976-1-michael.wei.hong.sit@intel.com>
In-Reply-To: <20210517094332.24976-1-michael.wei.hong.sit@intel.com>
To:     Sit@ci.codeaurora.org,
        Michael Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        davem@davemloft.net, mcoquelin.stm32@gmail.com,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        tee.min.tan@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 17 May 2021 17:43:30 +0800 you wrote:
> The goal of this patch set is to enable EEE in the xpcs so that when
> EEE is enabled, the MAC-->xpcs-->PHY have all the EEE related
> configurations enabled.
> 
> Patch 1 adds the functions to enable EEE in the xpcs and sets it to
> transparent mode.
> Patch 2 adds the callbacks to configure the xpcs EEE mode.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: pcs: Introducing support for DWC xpcs Energy Efficient Ethernet
    https://git.kernel.org/netdev/net-next/c/7617af3d1a5e
  - [net-next,2/2] net: stmmac: Add callbacks for DWC xpcs Energy Efficient Ethernet
    https://git.kernel.org/netdev/net-next/c/e80fe71b3ffe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


