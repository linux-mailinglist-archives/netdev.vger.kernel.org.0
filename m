Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B06D345326
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhCVXkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230366AbhCVXkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 19:40:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 95C50619AB;
        Mon, 22 Mar 2021 23:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616456411;
        bh=WOnecYxz3NTM0jSEfmNsp3ODjpgokxQ4V2YHZ45ke9M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VXuqBxGk6kfLskortfzlIY97js37fNickNJOUnpDjWSGWUVxD8lGuf5+TrB7mVUMg
         4AZLJ8PpOAi+rRGAjvmNo8U33kOv5/gMPyC74dCSDXN7udARyAPS9cVWP1X8Umrgkq
         Yg4sdVt33t2+622XDft+ajpqoMRrhWvkIglIBaUXTCWFIeYPuO3XuJ79oAqprVdXX2
         cxqTTNat2ZVmTl4gA7OkyL0UzZAoy2llKZXu8I2jIAO1uBhTEIXGkPAeWfHTx806L3
         dZts0mQd697IqqgaVPZt1Bxo254dXMQbgWD52Ruy6RfksYJq8RraimJWcsuQ8nwRJm
         AKkmrdxQxqqiA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 91A8560A1B;
        Mon, 22 Mar 2021 23:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/18][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-03-22
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161645641159.10796.12952499402559939568.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 23:40:11 +0000
References: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, haiyue.wang@intel.com, qi.z.zhang@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 13:32:26 -0700 you wrote:
> This series contains updates to ice and iavf drivers.
> 
> Haiyue Wang says:
> 
> The Intel E810 Series supports a programmable pipeline for a domain
> specific protocols classification, for example GTP by Dynamic Device
> Personalization (DDP) profile.
> 
> [...]

Here is the summary with links:
  - [net-next,01/18] ice: Add more basic protocol support for flow filter
    https://git.kernel.org/netdev/net-next/c/390bd141808d
  - [net-next,02/18] ice: Support non word aligned input set field
    https://git.kernel.org/netdev/net-next/c/b199dddbd399
  - [net-next,03/18] ice: Add more advanced protocol support in flow filter
    https://git.kernel.org/netdev/net-next/c/0577313e5388
  - [net-next,04/18] ice: Support to separate GTP-U uplink and downlink
    https://git.kernel.org/netdev/net-next/c/cbad5db88aaf
  - [net-next,05/18] ice: Enhanced IPv4 and IPv6 flow filter
    https://git.kernel.org/netdev/net-next/c/7012dfd1afc3
  - [net-next,06/18] ice: Add support for per VF ctrl VSI enabling
    https://git.kernel.org/netdev/net-next/c/da62c5ff9dcd
  - [net-next,07/18] ice: Enable FDIR Configure for AVF
    https://git.kernel.org/netdev/net-next/c/1f7ea1cd6a37
  - [net-next,08/18] ice: Add FDIR pattern action parser for VF
    https://git.kernel.org/netdev/net-next/c/0ce332fd62f6
  - [net-next,09/18] ice: Add new actions support for VF FDIR
    https://git.kernel.org/netdev/net-next/c/346bf2504397
  - [net-next,10/18] ice: Add non-IP Layer2 protocol FDIR filter for AVF
    https://git.kernel.org/netdev/net-next/c/21606584f1bb
  - [net-next,11/18] ice: Add GTPU FDIR filter for AVF
    https://git.kernel.org/netdev/net-next/c/ef9e4cc589ca
  - [net-next,12/18] ice: Add more FDIR filter type for AVF
    https://git.kernel.org/netdev/net-next/c/213528fed2f6
  - [net-next,13/18] ice: Check FDIR program status for AVF
    https://git.kernel.org/netdev/net-next/c/d6218317e2ef
  - [net-next,14/18] iavf: Add framework to enable ethtool ntuple filters
    https://git.kernel.org/netdev/net-next/c/0dbfbabb840d
  - [net-next,15/18] iavf: Support IPv4 Flow Director filters
    https://git.kernel.org/netdev/net-next/c/527691bf0682
  - [net-next,16/18] iavf: Support IPv6 Flow Director filters
    https://git.kernel.org/netdev/net-next/c/e90cbc257a6f
  - [net-next,17/18] iavf: Support Ethernet Type Flow Director filters
    https://git.kernel.org/netdev/net-next/c/a6ccffaa8da3
  - [net-next,18/18] iavf: Enable flex-bytes support
    https://git.kernel.org/netdev/net-next/c/a6379db818a8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


