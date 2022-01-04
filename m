Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A070483AE9
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 04:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbiADDTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 22:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiADDTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 22:19:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B3AC061761;
        Mon,  3 Jan 2022 19:19:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FDFA6125A;
        Tue,  4 Jan 2022 03:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7BA05C36AF3;
        Tue,  4 Jan 2022 03:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641266382;
        bh=7y24eWYO24/R7ZVr7XnNslPeSzNvn6hWC4DDbDOcjlg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p+SFOUmQjgB4ljdRVai0we+/j7EIo2PTq/RNMX8/rDP5OwCBlWRwbwx0FZOxPwNVS
         FSoxjhVrpu37+il7xZCIu4gUKb+blg4+ctKcDE6yam7DCh4c19xqeonY/Kt1GeNG+v
         t0uxb+h1++S1dHQak4AE4lhB8l5TXvj2CUuzgTOv3M/0DPZ2kG1SITluSA+GVEiNfF
         MSEMId7oABSC5sVfHOajbzXTHoz0QmXuJJHViTgdhhg1wjzGeJ8GvfD7SBroz5Ug8f
         Bqa8dwCDwvCLRoZyuV9AFOJAbpTu/0WUmG1+szvezauYdbB+TuR2W74PEvsP6irC6I
         S0iJGT3DsnaRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1ECF8F79408;
        Tue,  4 Jan 2022 03:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "net: phy: fixed_phy: Fix NULL vs IS_ERR()
 checking in __fixed_phy_register"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164126580911.11072.6758431867229467322.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Jan 2022 03:10:09 +0000
References: <20220103193453.1214961-1-f.fainelli@gmail.com>
In-Reply-To: <20220103193453.1214961-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linmq006@gmail.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  3 Jan 2022 11:34:52 -0800 you wrote:
> This reverts commit b45396afa4177f2b1ddfeff7185da733fade1dc3 ("net: phy:
> fixed_phy: Fix NULL vs IS_ERR() checking in __fixed_phy_register")
> since it prevents any system that uses a fixed PHY without a GPIO
> descriptor from properly working:
> 
> [    5.971952] brcm-systemport 9300000.ethernet: failed to register fixed PHY
> [    5.978854] brcm-systemport: probe of 9300000.ethernet failed with error -22
> [    5.986047] brcm-systemport 9400000.ethernet: failed to register fixed PHY
> [    5.992947] brcm-systemport: probe of 9400000.ethernet failed with error -22
> 
> [...]

Here is the summary with links:
  - [net] Revert "net: phy: fixed_phy: Fix NULL vs IS_ERR() checking in __fixed_phy_register"
    https://git.kernel.org/netdev/net/c/065e1ae02fbe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


