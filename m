Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1E047D97D
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 00:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242264AbhLVXAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 18:00:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36900 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhLVXAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 18:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82DFF61D2D
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 23:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC83EC36AE5;
        Wed, 22 Dec 2021 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640214012;
        bh=3pN43D2MNATLC8J2XO+U15p5Sxd3J3ugxOdMa7JWKuc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bnyruBwPjRbGDWaUx+kvYa1ipaAnftcm2ZaOwPtNW1+lnRUqQyXTp8n6UWiBYg9aH
         7iAurbRYc4NGzEtIvBcLXngNT3EVyQHsKAZ4fkRb6rRnNk2Co7rB+8b2wLDCJErIIt
         Aicmw54LuB+FVFmpfiPNkvKmZAWfKwpvEPfe+23mSxCDmFOkh3xXjfg3KglJDB6EIQ
         HBMbNib0iQeo2zGgPCs+hgH3RkngQQSRUPptxTARKLWpU4kcWlu0+CkQmmds6TZ1DD
         hOoz590+EmaymOm8dz63VsStpkBjTrBiu0JwtVadQ2FPGnmnQZ+tVfwqFVblk2tXQl
         1kWFTE7uxOzcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DBEC8FE55BB;
        Wed, 22 Dec 2021 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-12-21
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164021401189.685.13580923024035030481.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Dec 2021 23:00:11 +0000
References: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 21 Dec 2021 09:48:35 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Karol modifies the reset flow to correct issues with PTP reset.
> 
> Jake extends PTP support for E822 based devices. This includes a few
> cleanup patches, that fix some minor issues. In addition, there are some
> slight refactors to ease the addition of E822 support, followed by adding
> the new hardware implementation ice_ptp_hw.c.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] ice: Fix E810 PTP reset flow
    https://git.kernel.org/netdev/net-next/c/4809671015a1
  - [net-next,02/10] ice: introduce ice_base_incval function
    https://git.kernel.org/netdev/net-next/c/78267d0c9cab
  - [net-next,03/10] ice: PTP: move setting of tstamp_config
    https://git.kernel.org/netdev/net-next/c/e59d75dd410e
  - [net-next,04/10] ice: use 'int err' instead of 'int status' in ice_ptp_hw.c
    https://git.kernel.org/netdev/net-next/c/39b2810642e8
  - [net-next,05/10] ice: introduce ice_ptp_init_phc function
    https://git.kernel.org/netdev/net-next/c/b2ee72565cd0
  - [net-next,06/10] ice: convert clk_freq capability into time_ref
    https://git.kernel.org/netdev/net-next/c/405efa49b54b
  - [net-next,07/10] ice: implement basic E822 PTP support
    https://git.kernel.org/netdev/net-next/c/3a7496234d17
  - [net-next,08/10] ice: ensure the hardware Clock Generation Unit is configured
    https://git.kernel.org/netdev/net-next/c/b111ab5a11eb
  - [net-next,09/10] ice: exit bypass mode once hardware finishes timestamp calibration
    https://git.kernel.org/netdev/net-next/c/a69f1cb62aec
  - [net-next,10/10] ice: support crosstimestamping on E822 devices if supported
    https://git.kernel.org/netdev/net-next/c/13a64f0b9894

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


