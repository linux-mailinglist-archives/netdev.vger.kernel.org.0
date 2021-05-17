Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3DA386D90
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 01:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbhEQXLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 19:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234781AbhEQXL2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 19:11:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 304786134F;
        Mon, 17 May 2021 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621293011;
        bh=pjVRmKcVC5FxOfzwEvVF7PLUWBlV5avZZyMLBBUvc0E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fk2WflXYvh9ROLHtG7G2fZX4BzV+kR16Mtqs7BBG/VjqhMVuYITQcPdLo+FgcBU3O
         HyDk5aXy6zO2lnMah7757xQmkefPrMs2lMuXW88++XQb5LP0H2j8zAh9TEd4nTjvzB
         76KCxVsVnre1x7JuLgc4aRDFZ0x0Vil8Gq6eHxNOMWJIrpgg2COuld6wS2TKBRXAs6
         Th2NrCNhuUbhO6jCAdirYJgI2vKhUkyQXzhYLsNWvJyRqlChrVxSjxUNGW7Ro5qL6x
         KnT0dhS86pAaAoDXPYG5G0H3gBCJtSM57Y7xa1la8D5v1jKY567ixdfm8Hm2OY1n/s
         GI//hPAMMRTVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1C60260A4D;
        Mon, 17 May 2021 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers/net: Remove leading spaces in Kconfig
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162129301111.23530.6123072030162121527.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 23:10:11 +0000
References: <20210517095833.81681-1-juergh@canonical.com>
In-Reply-To: <20210517095833.81681-1-juergh@canonical.com>
To:     Juerg Haefliger <juerg.haefliger@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        juergh@canonical.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 17 May 2021 11:58:33 +0200 you wrote:
> Remove leading spaces before tabs in Kconfig file(s) by running the
> following command:
> 
>   $ find drivers/net -name 'Kconfig*' | xargs sed -r -i 's/^[ ]+\t/\t/'
> 
> Signed-off-by: Juerg Haefliger <juergh@canonical.com>
> 
> [...]

Here is the summary with links:
  - drivers/net: Remove leading spaces in Kconfig
    https://git.kernel.org/netdev/net-next/c/06b38e233ce4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


