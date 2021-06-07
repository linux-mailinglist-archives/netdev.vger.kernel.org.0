Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A024139E88E
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhFGUmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231347AbhFGUl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 16:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C0FFE611AE;
        Mon,  7 Jun 2021 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623098407;
        bh=pW1olbDAUwjIuEKi5QiEewzxJZpCTB0ZaiU543otTic=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jir2Ne4cqGXUl6iBAnC8kypzTNQ51jXm+rZae12hZXgO+gAMaMro8tHjLaAbQh6MB
         rgiOcgVpY7te0Jkj/8+e3jo9lj2YuUUJK5EHNPf7Mt0DEM/ebDChWab3cT45LdIq1B
         TgZLDk731XLspCRA5QHaW2jKdhsBtW0xdm1br3zawgV3GdQpLxZbxe1M6kMYmWJGYW
         +rn8c2n/bl88f6DHfdSacuHF6Fjy3OqFW8w0TmVq9jnNo2yNhJxNXbDbIcaaocG5Md
         p8YaI2mNuO6MTO3i6RXzwT9gDhIi8ybSpe1KWrSC3ex5W6tEtCOcLv2GEYIzyARIE5
         R49nctMynr+9w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B35CC609F1;
        Mon,  7 Jun 2021 20:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-06-07
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162309840772.17620.8064607622633479170.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 20:40:07 +0000
References: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon,  7 Jun 2021 09:53:10 -0700 you wrote:
> This series contains updates to virtchnl header file and ice driver.
> 
> Brett adds capability bits to virtchnl to specify whether a primary or
> secondary MAC address is being requested and adds the implementation to
> ice. He also adds storing of VF MAC address so that it will be preserved
> across reboots of VM and refactors VF queue configuration to remove the
> expectation that configuration be done all at once.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] virtchnl: Use pad byte in virtchnl_ether_addr to specify MAC type
    https://git.kernel.org/netdev/net-next/c/eb550f53099b
  - [net-next,02/15] ice: Manage VF's MAC address for both legacy and new cases
    https://git.kernel.org/netdev/net-next/c/51efbbdf1dca
  - [net-next,03/15] ice: Save VF's MAC across reboot
    https://git.kernel.org/netdev/net-next/c/f28cd5ce1a60
  - [net-next,04/15] ice: Refactor ice_setup_rx_ctx
    https://git.kernel.org/netdev/net-next/c/43c7f9198deb
  - [net-next,05/15] ice: Refactor VIRTCHNL_OP_CONFIG_VSI_QUEUES handling
    https://git.kernel.org/netdev/net-next/c/7ad15440acf8
  - [net-next,06/15] ice: set the value of global config lock timeout longer
    https://git.kernel.org/netdev/net-next/c/fb3612840d4f
  - [net-next,07/15] ice: Re-organizes reqstd/avail {R, T}XQ check/code for efficiency
    https://git.kernel.org/netdev/net-next/c/b38b7f2bb418
  - [net-next,08/15] ice: use static inline for dummy functions
    https://git.kernel.org/netdev/net-next/c/96cf4f689bf7
  - [net-next,09/15] ice: add extack when unable to read device caps
    https://git.kernel.org/netdev/net-next/c/d5f84ae95f1d
  - [net-next,10/15] ice: add error message when pldmfw_flash_image fails
    https://git.kernel.org/netdev/net-next/c/e872b94f9cf0
  - [net-next,11/15] ice: wait for reset before reporting devlink info
    https://git.kernel.org/netdev/net-next/c/1c08052ec49e
  - [net-next,12/15] ice: (re)initialize NVM fields when rebuilding
    https://git.kernel.org/netdev/net-next/c/97a4ec010705
  - [net-next,13/15] ice: Detect and report unsupported module power levels
    https://git.kernel.org/netdev/net-next/c/c77849f54609
  - [net-next,14/15] ice: downgrade error print to debug print
    https://git.kernel.org/netdev/net-next/c/a69606cde176
  - [net-next,15/15] ice: fix clang warning regarding deadcode.DeadStores
    https://git.kernel.org/netdev/net-next/c/7e94090ae13e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


