Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C2243FC0E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhJ2MMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230273AbhJ2MMh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 08:12:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 57DF661166;
        Fri, 29 Oct 2021 12:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635509409;
        bh=V2V/8zUqtda1Yq4tqMaLK0TyTjW/rD5crVemLdmMIVA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vBboFR4vEO3bfzHkAfJT6rN1y408EyHqtqu4UZKrmDn2R2GBUkAws57M1/6/eEOLD
         QHgiqlK/31C3a30TkbGQs9rjDTJORCzqw7lJUk/zk2p4t3yycK7wdSeUWKCTP4cnNd
         54W18jjDBemARVyUj0VL417hu8ezAiHm2KoGaKcEfEdx/tzvSGYqy5a7XOLcBQXbb5
         LGmsamiZpRVckp9AU7PBgTa90kWvVtJ9vjXHj0CR0eFdcXUDHr0JNHmbD2aqsSYGtR
         Y5xMilVgtl+LZ9N8tsTyLZ2nMxYsil3DWThMWvDjljAqk6w+4sPDP1cG795tR9SYb9
         dNgV/ksHfWe9w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4B1FA60A1B;
        Fri, 29 Oct 2021 12:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-10-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163550940930.13314.16909653642423425462.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 12:10:09 +0000
References: <20211028180659.218912-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211028180659.218912-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 28 Oct 2021 11:06:50 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Michal adds support for eswitch drop and redirect filters from and to
> tunnel devices. From meaning from uplink to VF and to means from VF to
> uplink. This is accomplished by adding support for indirect TC tunnel
> notifications and adding appropriate training packets and match fields
> for UDP tunnel headers. He also adds returning virtchannel responses for
> blocked operations as returning a response is still needed.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] ice: support for indirect notification
    https://git.kernel.org/netdev/net-next/c/195bb48fccde
  - [net-next,2/9] ice: VXLAN and Geneve TC support
    https://git.kernel.org/netdev/net-next/c/9e300987d4a8
  - [net-next,3/9] ice: low level support for tunnels
    https://git.kernel.org/netdev/net-next/c/8b032a55c1bd
  - [net-next,4/9] ice: support for GRE in eswitch
    https://git.kernel.org/netdev/net-next/c/f0a35040adbe
  - [net-next,5/9] ice: send correct vc status in switchdev
    https://git.kernel.org/netdev/net-next/c/e492c2e12d7b
  - [net-next,6/9] ice: Add support for changing MTU on PR in switchdev mode
    https://git.kernel.org/netdev/net-next/c/e984c4408fc9
  - [net-next,7/9] ice: Add support to print error on PHY FW load failure
    https://git.kernel.org/netdev/net-next/c/99d407524cdf
  - [net-next,8/9] ice: Fix clang -Wimplicit-fallthrough in ice_pull_qvec_from_rc()
    https://git.kernel.org/netdev/net-next/c/370764e60b18
  - [net-next,9/9] ice: fix error return code in ice_get_recp_frm_fw()
    https://git.kernel.org/netdev/net-next/c/c8e51a012214

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


