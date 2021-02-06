Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF21312050
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 23:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBFWkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 17:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBFWks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 17:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 33F7564DFA;
        Sat,  6 Feb 2021 22:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612651208;
        bh=sGEzTBdT7dfPM2IFMp8uKl+cq0tm0o4baKocIjoIvn0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YGr/jlmMPmVuLA/sOAlUmW8BQalmRznmHt/JIh+UXHzTndORedjW0fBokOVE9N6ap
         MEbumT3YI56/wURKYYF/ZVFyo3+xdT0EY2dkZKskNm7jZHL+6/EHFb50Z/2hO87Cs5
         I3S3A6ME/5L+2o31pLZDzwRP30F+8a6YApjOXwAu5yHC1oEkPvWBUza21E73suCC+z
         aD5X3+EE4QRb4MegVAJKxvP6zL/PZnybapJuySsW6q6s2+5vw/J4YkhmkUKlqwjNNK
         npkliIqBihS1krY6hUfRTCB5VN/ciUIrLSPozjUmDoYZz8jCQHi6RTMvunpvRPvUO4
         GOytYah7x9/TA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1B4F6609FE;
        Sat,  6 Feb 2021 22:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] dpaa2: add 1000base-X support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161265120810.6465.11286856669892192181.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 22:40:08 +0000
References: <20210205103859.GH1463@shell.armlinux.org.uk>
In-Reply-To: <20210205103859.GH1463@shell.armlinux.org.uk>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     ioana.ciornei@nxp.com, ruxandra.radulescu@nxp.com, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 5 Feb 2021 10:39:00 +0000 you wrote:
> Hi,
> 
> This patch series adds 1000base-X support to pcs-lynx and DPAA2,
> allowing runtime switching between SGMII and 1000base-X. This is
> a pre-requisit for SFP module support on the SolidRun ComExpress 7.
> 
> v2: updated with Ioana's r-b's, and comment on backplane support
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: pcs: add pcs-lynx 1000BASE-X support
    https://git.kernel.org/netdev/net-next/c/694a0006c0b1
  - [net-next,v2,2/3] net: dpaa2-mac: add 1000BASE-X support
    https://git.kernel.org/netdev/net-next/c/46c518c8145b
  - [net-next,v2,3/3] net: dpaa2-mac: add backplane link mode support
    https://git.kernel.org/netdev/net-next/c/085f1776fa03

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


