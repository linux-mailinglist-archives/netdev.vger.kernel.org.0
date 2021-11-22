Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9E14590B7
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbhKVPDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:03:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239820AbhKVPDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 10:03:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B2DF060F50;
        Mon, 22 Nov 2021 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637593209;
        bh=Za0ZJl9E5yiRT7Qi7U6BPc3LGzUIO+C7PD1xLd3btsw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OBhyqt5MHkl1hvBYQPcM45/pFd9QYbUTS3TRH6Y/2uM46EqZnFEMMkLpenr8labuM
         VddvADu1B3dmf8hw8JJAkuB3WSjICO3t3umNey6Upc0r40ucPGBNeTiBu0fbmUREzb
         i+7Poy7ZqbuY5ImqxWqTUXLD7qeAAO2O4IbtXCbfjtxhLibDIh+LA5bhbQWg97SdQh
         13rDzdjFS8GdxWSUzbz/l0QGS2y4XKiu2xVsuDPAcdjM/W9Zyjd+zkcSRdJmyZazFS
         xGkZEQvjLW93frnWBWiVRl0CPhnFjJt8u9UqWIjy8lhAXOkPfwxSrtK9FBFsilRTt1
         EkIIOIfaIONqw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ACA4060A94;
        Mon, 22 Nov 2021 15:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hv_netvsc: Use bitmap_zalloc() when applicable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163759320970.11926.3557850890600741677.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 15:00:09 +0000
References: <534578d2296a1f4bd86c9bd4676e9d6b92eceb59.1637531723.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <534578d2296a1f4bd86c9bd4676e9d6b92eceb59.1637531723.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 21 Nov 2021 22:56:39 +0100 you wrote:
> 'send_section_map' is a bitmap. So use 'bitmap_zalloc()' to simplify code,
> improve the semantic and avoid some open-coded arithmetic in allocator
> arguments.
> 
> Also change the corresponding 'kfree()' into 'bitmap_free()' to keep
> consistency.
> 
> [...]

Here is the summary with links:
  - hv_netvsc: Use bitmap_zalloc() when applicable
    https://git.kernel.org/netdev/net-next/c/e9268a943998

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


