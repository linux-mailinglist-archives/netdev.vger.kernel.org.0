Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7EC312092
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 01:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhBGAUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 19:20:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBGAUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 19:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 067BA64E3E;
        Sun,  7 Feb 2021 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612657209;
        bh=MP7pTLR+jI/hIqZib0kTqK+c8glrKtdPkwEDUpQBwas=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o65jWsCPTX/uk5CCMDJ+5GcdYOefqOTk98BI0cWN09UV4aW6zM9pEOg4KdEdS0p4e
         CVDeTwh0MDIjGvQQoyEIKHxfSzkw9LCVFc1c0c5xprwFx9r9hdXpN2ExcG3wivz0F0
         ZOpCxcmXBDaUkHQO0t6NrIIELCVqvHyY39YymlRse2ZOT3TtkgifK030oZg5JgLDLB
         aDcu3np3bZMRQ0vm6NzKZgMrqHJKRUVjSu40fy4KFKITELNDWuWkmV9PjHyY2VLmZt
         1lLSbdmGQHaAM4uJDMX+9t5PKY6P7oxQn2zOqyjqr2cSftXQwZMj89PRbKnJuCUCtX
         OsVPjvdKkMSTg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EB9C7609FE;
        Sun,  7 Feb 2021 00:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/11][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-02-05
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161265720896.19114.5893553613210425078.git-patchwork-notify@kernel.org>
Date:   Sun, 07 Feb 2021 00:20:08 +0000
References: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  5 Feb 2021 20:40:50 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Jake adds adds reporting of timeout length during devlink flash and
> implements support to report devlink info regarding the version of
> firmware that is stored (downloaded) to the device, but is not yet active.
> ice_devlink_info_get will report "stored" versions when there is no
> pending flash update. Version info includes the UNDI Option ROM, the
> Netlist module, and the fw.bundle_id.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/11] ice: report timeout length for erasing during devlink flash
    https://git.kernel.org/netdev/net-next/c/08e1294daa29
  - [net-next,v2,02/11] ice: create flash_info structure and separate NVM version
    https://git.kernel.org/netdev/net-next/c/9af368fa9c64
  - [net-next,v2,03/11] ice: introduce context struct for info report
    https://git.kernel.org/netdev/net-next/c/74789085d9ce
  - [net-next,v2,04/11] ice: cache NVM module bank information
    https://git.kernel.org/netdev/net-next/c/1fa95e0120eb
  - [net-next,v2,05/11] ice: introduce function for reading from flash modules
    https://git.kernel.org/netdev/net-next/c/0ce50c7066e2
  - [net-next,v2,06/11] ice: display some stored NVM versions via devlink info
    https://git.kernel.org/netdev/net-next/c/2c4fe41d727f
  - [net-next,v2,07/11] ice: display stored netlist versions via devlink info
    https://git.kernel.org/netdev/net-next/c/e120a9ab45d3
  - [net-next,v2,08/11] ice: display stored UNDI firmware version via devlink info
    https://git.kernel.org/netdev/net-next/c/e67fbcfbb4ef
  - [net-next,v2,09/11] ice: Replace one-element array with flexible-array member
    https://git.kernel.org/netdev/net-next/c/e94c0df984d3
  - [net-next,v2,10/11] ice: use flex_array_size where possible
    https://git.kernel.org/netdev/net-next/c/11404310d58d
  - [net-next,v2,11/11] ice: remove dead code
    https://git.kernel.org/netdev/net-next/c/12aae8f1d879

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


