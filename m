Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A873D45D34C
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 03:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238646AbhKYCzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 21:55:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231792AbhKYCxT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 21:53:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0A1B961050;
        Thu, 25 Nov 2021 02:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637808609;
        bh=4Q4x22TV6HoLVpgdhm2BID9spCd3EFoU2Dl9nZrflrg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pnlo8Kckfq0vtU1XNRXRUc4ph3A2/95g6Z5ucP38LofIkpshMrW0TfGHNOQwkxUJn
         8TirjGw0kRLBrTMJHh+FUA6jZC65XcOBtSyzDMC1zlh+8O1VWoqnK6km4PFwqWye0l
         3DxoOybyEqEdXTiyVKSNMJfYKvEV9NSWCH861Dd1L3KMQjuecXOb4MAbS937O3edYv
         MKdYAyFJuY4aEu/iKK3bJ829xjR1Dw0Ifv/43UV8GAo8UB35u3eJh3UwLV/7FCEWF1
         DR9B+NHXgH1ODzijAKnOOxYbpSYy5MkON8gvlJ2uX5/KPBuZZ1ZbpQ+bv0kTsWJAYY
         CVLynl8WQOiwA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F083C60A12;
        Thu, 25 Nov 2021 02:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] lan743x: fix deadlock in lan743x_phy_link_status_change()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163780860897.6208.1894443377134240771.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 02:50:08 +0000
References: <40e27f76-0ba3-dcef-ee32-a78b9df38b0f@gmail.com>
In-Reply-To: <40e27f76-0ba3-dcef-ee32-a78b9df38b0f@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        netdev@vger.kernel.org, abmaurici@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 08:16:25 +0100 you wrote:
> Usage of phy_ethtool_get_link_ksettings() in the link status change
> handler isn't needed, and in combination with the referenced change
> it results in a deadlock. Simply remove the call and replace it with
> direct access to phydev->speed. The duplex argument of
> lan743x_phy_update_flowcontrol() isn't used and can be removed.
> 
> Fixes: c10a485c3de5 ("phy: phy_ethtool_ksettings_get: Lock the phy for consistency")
> Reported-by: Alessandro B Maurici <abmaurici@gmail.com>
> Tested-by: Alessandro B Maurici <abmaurici@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] lan743x: fix deadlock in lan743x_phy_link_status_change()
    https://git.kernel.org/netdev/net/c/ddb826c2c92d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


