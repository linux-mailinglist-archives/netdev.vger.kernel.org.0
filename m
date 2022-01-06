Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2A6486494
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239047AbiAFMuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:50:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55308 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239012AbiAFMuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:50:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CD2E61BBA;
        Thu,  6 Jan 2022 12:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 998A3C36AED;
        Thu,  6 Jan 2022 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641473409;
        bh=DWUnpIhI7kotNpRY68y0VxbwwHoAukCIZR/I7RI9xQg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rz3xZXoVeLRpFezunw1pjaJc+aVHiOHZiPP1UaoAXKXlHb9NBftAfiKrjGDgEBkEn
         Oti7WimBtS3Q5GVMQnDQwarpfpW+UhAdv/tELqtXFlvCutq3iKdpG+kCVdqbhU9nYB
         2QI2Ah/ZGwgCKLjhF+iha7tJZ9jP/JpbH7HIaQilWlPiObHiYSk19+IgwuZBvFCb/9
         IuHlsgeHM+6hk6enfLAAnHxtUY56bYxU8mFGnMlD14OutwJuumCxXVgQjaBGIbJMKV
         y1+3i/93Ic4mBLEiimDgcGrt34Q09UxAu27smZR/70eDUcGgXyzoRkc7j2gfEjMJcU
         bsVF5AsXSNdtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D91CF79403;
        Thu,  6 Jan 2022 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sfc: Use swap() instead of open coding it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164147340951.10056.7693644262884175169.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 12:50:09 +0000
References: <20220105152237.45991-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20220105152237.45991-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, abaci@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  5 Jan 2022 23:22:37 +0800 you wrote:
> Clean the following coccicheck warning:
> 
> ./drivers/net/ethernet/sfc/efx_channels.c:870:36-37: WARNING opportunity
> for swap().
> 
> ./drivers/net/ethernet/sfc/efx_channels.c:824:36-37: WARNING opportunity
> for swap().
> 
> [...]

Here is the summary with links:
  - sfc: Use swap() instead of open coding it
    https://git.kernel.org/netdev/net-next/c/0cf765fb00ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


