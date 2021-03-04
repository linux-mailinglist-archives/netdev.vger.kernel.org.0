Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6149632C9D1
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 02:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243844AbhCDBMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 20:12:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:39990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238406AbhCDBAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 20:00:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8226864F5E;
        Thu,  4 Mar 2021 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614819613;
        bh=KSAWwbHb73EOPg5kPH2hKmEoVXP1BNoKlW+Hi1Bcse0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H7mFgg08GUXFggoHDxaWut1SV4wsorIeXYYYNxGKcmXbfYb2YEDKNNcgxqaH4rucL
         9h4Velz4pVMLLg9z0dlQ/VUxtb9ahJh73q4r+dyyKTBbTFAk73Ei4cEixRhkDUw/lX
         pRVHPD/a4zvry4/6A+y6VbbaLz7KPNoXf2iLuxRceO6pysEk4qXYk1sz/nc0xv9Cgt
         wa+efFS2hMyGg03Dsns9ita8cU0Pkm6k6iwXKoE5INxIgXMoSCS2qZBag5N3MiCSlS
         X9xynModSskA8QXf71jkcse0xUHJTxBX7pG1bOA1H0JvvbVhZ7gi8ESfRpZCSGdfo2
         v22ox4TOGtyAw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7691A609EA;
        Thu,  4 Mar 2021 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "r8152: adjust the settings about MAC clock speed
 down for RTL8153"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161481961348.28060.14733317250155775339.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Mar 2021 01:00:13 +0000
References: <1394712342-15778-347-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-347-Taiwan-albertk@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 3 Mar 2021 16:39:47 +0800 you wrote:
> This reverts commit 134f98bcf1b898fb9d6f2b91bc85dd2e5478b4b8.
> 
> The r8153_mac_clk_spd() is used for RTL8153A only, because the register
> table of RTL8153B is different from RTL8153A. However, this function would
> be called when RTL8153B calls r8153_first_init() and r8153_enter_oob().
> That causes RTL8153B becomes unstable when suspending and resuming. The
> worst case may let the device stop working.
> 
> [...]

Here is the summary with links:
  - [net] Revert "r8152: adjust the settings about MAC clock speed down for RTL8153"
    https://git.kernel.org/netdev/net/c/4b5dc1a94d4f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


