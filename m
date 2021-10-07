Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19DE425393
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240803AbhJGNCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240739AbhJGNCI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 09:02:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E7F6861108;
        Thu,  7 Oct 2021 13:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633611614;
        bh=n/LyOKYsiHITIBU7f/eNjPxBPJF9qwjnJTyWG8q3j9E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bu3hwGcjunvNC7S3UoZb3OUwyw+7jVcFFRdYukq29C1pE+3ZevWqib5OGWKvMqV0u
         CBgc2Lw1i9oeqAJte0db6yFRkDDZoZAylg07SOwkm6zhEDiGDAQ/gUMB3Mw/UmPX/z
         +ZqZr9B+9ERDumH7pCG8oesaGLwoNCFWGrlRXEmUTX8g3myuFdUPbdnn1Lv66sukFo
         +k3qaj/YJSV9lVJVhLWAGxOiK3Ojpub+xk0d9cqRTB45Pe247AL8eRUhGWSNjh6CTQ
         YkEP6fpF7HHrl4sCjUcHllQwcDTgw63flOFzZQet+CgHRaYxSbNTwEp1af9XxxzXP8
         nlpLdBVzFkcMw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D415660A39;
        Thu,  7 Oct 2021 13:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/9] net: add a helpers for loading
 netdev->dev_addr from FW
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163361161386.30815.7886368181851048182.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Oct 2021 13:00:13 +0000
References: <20211007010702.3438216-1-kuba@kernel.org>
In-Reply-To: <20211007010702.3438216-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, rafael@kernel.org,
        saravanak@google.com, mw@semihalf.com, andrew@lunn.ch,
        jeremy.linton@arm.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        robh+dt@kernel.org, frowand.list@gmail.com,
        heikki.krogerus@linux.intel.com, devicetree@vger.kernel.org,
        snelson@pensando.io
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master)
by David S. Miller <davem@davemloft.net>:

On Wed,  6 Oct 2021 18:06:53 -0700 you wrote:
> We're trying to make all writes to netdev->dev_addr go via helpers.
> A lot of places pass netdev->dev_addr to of_get_ethdev_address() and
> device_get_ethdev_addr() so this set adds new functions which wrap
> the functionality.
> 
> v2 performs suggested code moves, adds a couple additional clean ups
> on the device property side, and an extra patch converting drivers
> which can benefit from device_get_ethdev_address().
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/9] of: net: move of_net under net/
    https://git.kernel.org/netdev/net-next/c/e330fb14590c
  - [net-next,v3,2/9] of: net: add a helper for loading netdev->dev_addr
    https://git.kernel.org/netdev/net-next/c/d466effe282d
  - [net-next,v3,3/9] ethernet: use of_get_ethdev_address()
    https://git.kernel.org/netdev/net-next/c/9ca01b25dfff
  - [net-next,v3,4/9] device property: move mac addr helpers to eth.c
    https://git.kernel.org/netdev/net-next/c/433baf0719d6
  - [net-next,v3,5/9] eth: fwnode: change the return type of mac address helpers
    https://git.kernel.org/netdev/net-next/c/8017c4d8173c
  - [net-next,v3,6/9] eth: fwnode: remove the addr len from mac helpers
    https://git.kernel.org/netdev/net-next/c/0a14501ed818
  - [net-next,v3,7/9] eth: fwnode: add a helper for loading netdev->dev_addr
    https://git.kernel.org/netdev/net-next/c/d9eb44904e87
  - [net-next,v3,8/9] ethernet: use device_get_ethdev_address()
    https://git.kernel.org/netdev/net-next/c/b8eeac565b16
  - [net-next,v3,9/9] ethernet: make more use of device_get_ethdev_address()
    https://git.kernel.org/netdev/net-next/c/894b0fb09215

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


