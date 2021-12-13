Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E039472EDA
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 15:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239019AbhLMOUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 09:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbhLMOUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 09:20:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECE4C061748
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 06:20:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56707B8107E
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14F97C34605;
        Mon, 13 Dec 2021 14:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639405230;
        bh=Vd/i6QiyPjhBDCw9mAQ4FJBeZad6GZju/KzN08w8sU0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Br3fBBm0j9cu+T1+X93i77IFae7xBDYgUxvEh7pAG9AEc6/Lhi0Xzp4NB8Wg+OqwO
         umQdKoiXPsM7jgKc3etx8InLpgkJ4Fyfn6atH8oA4eUqAQMD5tsPJDAie99TTE1Q39
         X3HXaEwvaWU2O3KIngPrheWpj+s0Fy+Leeq5yWNak2UQG0x5qY9+RndD75kVicV+ex
         JLQRfk1LmhFjjbjXpBcISbbHjQEY8XwE2jnr5AUOfOAiQ1TDhZJQ/iDnLqulqntUA9
         SwnZJiSJqX4OYVLE/0jUiyjjkP9+Edc3a+1UZtUgfOcF08a+7mabb9sNahPUzOj9IH
         WuA/HOJdZC0VQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 04D77609F5;
        Mon, 13 Dec 2021 14:20:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: axienet: mark as a legacy_pre_march2020 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940523001.6863.3318803861471074589.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 14:20:30 +0000
References: <E1mwOTb-00FHgY-TW@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mwOTb-00FHgY-TW@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, kabel@kernel.org,
        radhey.shyam.pandey@xilinx.com, michal.simek@xilinx.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 12 Dec 2021 13:01:15 +0000 you wrote:
> axienet has a PCS, but does not make use of the phylink PCS support.
> Mark it was a pre-March 2020 driver.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> This driver was missed from the patch set when the patches were sent
> for merging; it was in the original RFC series.
> 
> [...]

Here is the summary with links:
  - [net-next] net: axienet: mark as a legacy_pre_march2020 driver
    https://git.kernel.org/netdev/net-next/c/62cc9a7387f1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


