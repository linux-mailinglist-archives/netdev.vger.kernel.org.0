Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EF6426CAA
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 16:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbhJHOWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 10:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229756AbhJHOWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 10:22:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1C117610CE;
        Fri,  8 Oct 2021 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633702807;
        bh=kgFXOG7BhQb6pvDVPe680hl2VgGm9DgHMMQjQ07DhzI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K18Qy6lC0uICfspDp8gHMBMTtrHA+tADkfzhyuLq+/YTehBgpQdx2kIrjkYhKJQ7z
         cTeeBA3gzORCGHibVWiqKTiYblybDH3GB3AUnN04mWBdSfNLvROadmwYmjBhnGs6eh
         /dDVaXnQg6TSw5sGA/eNBjoTG6f6kWpNBzX76EMUap3lleOweodpyrAN2sVwEHKm9w
         34GTmPXl53RCsNZ16Du/i6Ci0ryn+FNvGuZ8MSlJr0IMuuTuVLsxZzMF8p+kRnKm29
         LMx2WlFs3RwWvjQhu42l8YW/bW6a0oN5PKuiaHp3kqC1sV/UAwK7mol25kaOmvNMej
         uK8zpz7+21Qtg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1290060A44;
        Fri,  8 Oct 2021 14:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2][next] qed: Initialize debug string array
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163370280707.5508.8344854515850968604.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 14:20:07 +0000
References: <20211007120413.8642-1-tim.gardner@canonical.com>
In-Reply-To: <20211007120413.8642-1-tim.gardner@canonical.com>
To:     Tim Gardner <tim.gardner@canonical.com>
Cc:     pkushwaha@marvell.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, smalin@marvell.com, okulkarni@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Oct 2021 06:04:13 -0600 you wrote:
> Coverity complains of an uninitialized variable.
> 
> CID 120847 (#1 of 1): Uninitialized scalar variable (UNINIT)
> 3. uninit_use_in_call: Using uninitialized value *sw_platform_str when calling qed_dump_str_param. [show details]
> 1344        offset += qed_dump_str_param(dump_buf + offset,
> 1345                                     dump, "sw-platform", sw_platform_str);
> 
> [...]

Here is the summary with links:
  - [v2,next] qed: Initialize debug string array
    https://git.kernel.org/netdev/net-next/c/d5ac07dfbd2b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


