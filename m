Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652B73ABC8A
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 21:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbhFQTW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 15:22:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233253AbhFQTWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 15:22:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6F324613EE;
        Thu, 17 Jun 2021 19:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623957613;
        bh=PsJWAkyXgW4WiW2hDScun0vO/mPUHwpob19D9DS+/Jo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HAFvvcKiRdEpUtnUFZm7PN2hLjW1pTvBv+CTLFKpaVJWt1A+IepTBwD5XhB/hUU4F
         nwuWhiweRWdwUtBRmYxi0Hev3qvAbaPQiybp+NPPg2g8YVumMl9G8x5rorVsPcI9yS
         tAg/sA6ymdCgHEDYPNBM7YSG3nqJJKGtCMVEL/JULR7c2il0ktVlmPRn7oyTCz+q/9
         OtCiDNdEtPLmGkgee1bMQLWkVJ2UhSwKUyBY5krb5hSvLUU498boYR6A1cvO19zbGM
         El+i7QFzj14a08IXHy/avgrK1se0HhLi1zd9rx5r4WVmbICeXFU7lLFS8XnYq6K2zp
         Z9SRV64dCSnuw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5EEDD60A54;
        Thu, 17 Jun 2021 19:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] net: mdio: setup both fwnode and of_node
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162395761338.22568.4198014578041173710.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Jun 2021 19:20:13 +0000
References: <20210617122905.1735330-1-ciorneiioana@gmail.com>
In-Reply-To: <20210617122905.1735330-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        grant.likely@arm.com, calvin.johnson@oss.nxp.com,
        ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 17 Jun 2021 15:29:02 +0300 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> The first patch in this series fixes a bug introduced by mistake in the
> previous ACPI MDIO patch set.
> 
> The next two patches are adding a new helper which takes a device and a
> fwnode_handle and populates both the of_node and fwnode so that we make
> sure that a bug like this does not happen anymore.
> Also, the new helper is used in the MDIO area.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: mdio: setup of_node for the MDIO device
    https://git.kernel.org/netdev/net-next/c/70ef608c224a
  - [net-next,v2,2/3] driver core: add a helper to setup both the of_node and fwnode of a device
    https://git.kernel.org/netdev/net-next/c/43e76d463c09
  - [net-next,v2,3/3] net: mdio: use device_set_node() to setup both fwnode and of
    https://git.kernel.org/netdev/net-next/c/7e33d84db1a8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


