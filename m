Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0336D30C6E0
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237102AbhBBRC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:02:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237115AbhBBRAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 12:00:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4C04D64F86;
        Tue,  2 Feb 2021 17:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612285208;
        bh=w1UejxHFMF8Pl0C6aBCYCTYRzjtvB9Hpf/9vTQFV8q0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hV9UVDWlAdfz44Lkdy5gOxEAdIOKuj+sfFuTygBH2GwZRlEaMYbgn9Z44vjcmVt4o
         Rwlak8P9U0+szR7AHM5cQyuod6dOrO4Fp2aqzrvYziKV2hyiVxpFRoHCiAjfPb0vGy
         RJMzIT2b//H79iKij0rHOt2WUIh7ZqWdOXwbxpOHA9NlZayATX49z55B/izUwY0TVF
         ZMROhN1Zd9ZMZkthgCzH9tLKoG2Zkrpfu/jWIde3PKHrzJiEEFHY7b20Lc2BsqSuEw
         U5d7oTjhEVMhWBePm4RpTta2e+skzUI/3aSVDTuHQnuLITVlZMbltugBuNTHL8gxRL
         kfpapphHwSQKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3C545609D9;
        Tue,  2 Feb 2021 17:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1] net: hsr: align sup_multicast_addr in struct hsr_priv to
 u16 boundary
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161228520824.27951.15557500813453182745.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 17:00:08 +0000
References: <20210202090304.2740471-1-ennoerlangen@gmail.com>
In-Reply-To: <20210202090304.2740471-1-ennoerlangen@gmail.com>
To:     Andreas Oetken <ennoerlangen@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        andreas.oetken@siemens.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  2 Feb 2021 10:03:04 +0100 you wrote:
> From: Andreas Oetken <andreas.oetken@siemens.com>
> 
> sup_multicast_addr is passed to ether_addr_equal for address comparison
> which casts the address inputs to u16 leading to an unaligned access.
> Aligning the sup_multicast_addr to u16 boundary fixes the issue.
> 
> Signed-off-by: Andreas Oetken <andreas.oetken@siemens.com>
> 
> [...]

Here is the summary with links:
  - [v1] net: hsr: align sup_multicast_addr in struct hsr_priv to u16 boundary
    https://git.kernel.org/netdev/net/c/6c9f18f294c4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


