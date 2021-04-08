Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700C0358F2C
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 23:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbhDHVab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 17:30:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232265AbhDHVaZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 17:30:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3A36A6113C;
        Thu,  8 Apr 2021 21:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617917414;
        bh=5XfaasXjHlvmNDZDxG5eY4RpjOQLW2wTpVblHJPHSS8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r0gXqOxBekovVlVuJ5BS/QtdogqRufXr1TKI+MKui44dyxSRhaKA7jxs8yte/wn0A
         z5R3aHuv7Wtt8a2TSfoO+BrY2lL0Abe/ibJ5qHweJ6enCzItDQJ30XkIa7SrJIH0yX
         GTVfyKJPQoL0IARPlnqXtf+Np6RRC3DH4WpKXwrywJPnw07aqW/z7Lt6MbvtharDCR
         fopAGHbEEsyHiA3N8HsP3G1EHj6Aq7+sFNcATjTGMuKrKdjOq3IzNMuBlMjxfXb849
         pc5g5C3vX14aDnPl/a/nLh+dB3M7sCwT3VvE9Co1PghtADPeX/49Fw1E2FZD4Iv6Ul
         IdpeCRXe7Q/KQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2ED9060A71;
        Thu,  8 Apr 2021 21:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-04-08
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161791741418.16984.12208268189733311217.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Apr 2021 21:30:14 +0000
References: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu,  8 Apr 2021 09:13:06 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Chinh adds retrying of sending some AQ commands when receiving EBUSY
> error.
> 
> Victor modifies how nodes are added to reduce stack usage.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] ice: Re-send some AQ commands, as result of EBUSY AQ error
    https://git.kernel.org/netdev/net-next/c/3056df93f7a8
  - [net-next,02/15] ice: Modify recursive way of adding nodes
    https://git.kernel.org/netdev/net-next/c/7fb09a737536
  - [net-next,03/15] ice: Align macro names to the specification
    https://git.kernel.org/netdev/net-next/c/d6730a871e68
  - [net-next,04/15] ice: Ignore EMODE return for opcode 0x0605
    https://git.kernel.org/netdev/net-next/c/d348d51771b9
  - [net-next,05/15] ice: Remove unnecessary checker loop
    https://git.kernel.org/netdev/net-next/c/fd3dc1655eda
  - [net-next,06/15] ice: Rename a couple of variables
    https://git.kernel.org/netdev/net-next/c/0be39bb4c7c8
  - [net-next,07/15] ice: Fix error return codes in ice_set_link_ksettings
    https://git.kernel.org/netdev/net-next/c/450f10e79419
  - [net-next,08/15] ice: Replace some memsets and memcpys with assignment
    https://git.kernel.org/netdev/net-next/c/178a666daa0e
  - [net-next,09/15] ice: Use default configuration mode for PHY configuration
    https://git.kernel.org/netdev/net-next/c/0a02944feaa7
  - [net-next,10/15] ice: Limit forced overrides based on FW version
    https://git.kernel.org/netdev/net-next/c/75751c80d6d8
  - [net-next,11/15] ice: Remove unnecessary variable
    https://git.kernel.org/netdev/net-next/c/dc6aaa139fb7
  - [net-next,12/15] ice: Use local variable instead of pointer derefs
    https://git.kernel.org/netdev/net-next/c/efc1eddb28aa
  - [net-next,13/15] ice: Remove rx_gro_dropped stat
    https://git.kernel.org/netdev/net-next/c/51fe27e179b1
  - [net-next,14/15] ice: Remove unnecessary checks in add/kill_vid ndo ops
    https://git.kernel.org/netdev/net-next/c/771015b90b86
  - [net-next,15/15] ice: Remove unnecessary blank line
    https://git.kernel.org/netdev/net-next/c/2e20521b80c7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


