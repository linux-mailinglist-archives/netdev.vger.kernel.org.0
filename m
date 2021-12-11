Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0E84711EF
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 06:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhLKFdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 00:33:49 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:44672 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhLKFds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 00:33:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 468D2CE2F2A;
        Sat, 11 Dec 2021 05:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6ED74C341C8;
        Sat, 11 Dec 2021 05:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639200609;
        bh=0ZmAWWTMz6arpFX6ldYrpRfXYClOpNPUeObItaYMLcg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nsM0z86/loBbCX5XEoQdVWfZhmliwlIfiFmmC5gnQoeaRlrVmcyxIK3QVwP83MzoR
         /mqTrqPuUCs4fV2SDR3o9zcuiRAZJms7s6XY09c/JW94Gs9LOuFxpnL/E8nUqDkl/w
         AAUJb2+21QvAJb9g06egjWSfyy+vCkly0xhuAXiKzEebIny1NOzMZIOoFp+CP8bmCQ
         MKi9gEt1nr5Xq95wMdRqmfxScgPpbKH9q+xLfu9WgaUdGkJlbe5r7f7SBDupJD1uXj
         e3LLY6Hk3O2tUA14tPBM+WOsZBAWU6JYdJRBUcOS6UXquW9waOS0S5R4sQBpQNEAUc
         8IswXC+o70Ofg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 48A4560A4D;
        Sat, 11 Dec 2021 05:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: add Telit 0x1070 composition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163920060929.12590.9128802447755112885.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Dec 2021 05:30:09 +0000
References: <20211210095722.22269-1-dnlplm@gmail.com>
In-Reply-To: <20211210095722.22269-1-dnlplm@gmail.com>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     bjorn@mork.no, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Dec 2021 10:57:22 +0100 you wrote:
> Add the following Telit FN990 composition:
> 
> 0x1070: tty, adb, rmnet, tty, tty, tty, tty
> 
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> ---
> Hello Bjørn,
> 
> [...]

Here is the summary with links:
  - [1/1] net: usb: qmi_wwan: add Telit 0x1070 composition
    https://git.kernel.org/netdev/net/c/94f2a444f28a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


