Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD94475769
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 12:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbhLOLKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 06:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236834AbhLOLKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 06:10:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9C3C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D3CD61893
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 11:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE58BC34605;
        Wed, 15 Dec 2021 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639566612;
        bh=kghl8RGDntgP72ZaIaHHjqLGWEaRasOND7UDb17p7Co=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k7I3iE6gJ8sdSN8eHcD12DfDNljifr5Y48KWj4GcdTvYSC4hslkgai4woL7+6hvsX
         YBTPi7Q+0XJX9PolUe17vHO/pBA8ZWhIOXtllBQRrRiNwNN/imcN6kyMDIicU9hXH7
         ptvIDAqHylxnqdz9NjgaaAJsSdWYx2uozNlGgnLrBj+1JbRC3IOUaLWq/QxX8PJsWG
         D+MRp/Sek05hfTbGpufbDNhIKtgPEOk2Rg+Pb4YpJV3BJZh3Tna0aFlxyosvDWwTFv
         126vIie6BcGqsb0URbOVxMgUcz7sCW227GZONjoC5TaqW9t/FV98y47YNruWjq1MDS
         7Yq63yxPzbF3g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C45D260A4F;
        Wed, 15 Dec 2021 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-12-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163956661280.16045.17092888317206247238.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Dec 2021 11:10:12 +0000
References: <20211214182908.1513343-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211214182908.1513343-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 14 Dec 2021 10:28:56 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Haiyue adds support to query hardware for supported PTYPEs.
> 
> Jeff changes PTYPE validation to utilize the capabilities queried from
> the hardware instead of maintaining a per DDP support list.
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] ice: Add package PTYPE enable information
    https://git.kernel.org/netdev/net-next/c/8818b95409d8
  - [net-next,02/12] ice: refactor PTYPE validating
    https://git.kernel.org/netdev/net-next/c/60f44fe4cde9
  - [net-next,03/12] ice: Refactor promiscuous functions
    https://git.kernel.org/netdev/net-next/c/fabf480bf95d
  - [net-next,04/12] ice: Refactor status flow for DDP load
    https://git.kernel.org/netdev/net-next/c/247dd97d713c
  - [net-next,05/12] ice: Remove string printing for ice_status
    https://git.kernel.org/netdev/net-next/c/5f87ec4861aa
  - [net-next,06/12] ice: Use int for ice_status
    https://git.kernel.org/netdev/net-next/c/5e24d5984c80
  - [net-next,07/12] ice: Remove enum ice_status
    https://git.kernel.org/netdev/net-next/c/d54699e27d50
  - [net-next,08/12] ice: Cleanup after ice_status removal
    https://git.kernel.org/netdev/net-next/c/5518ac2a6442
  - [net-next,09/12] ice: Remove excess error variables
    https://git.kernel.org/netdev/net-next/c/2ccc1c1ccc67
  - [net-next,10/12] ice: Propagate error codes
    https://git.kernel.org/netdev/net-next/c/c14846914ed6
  - [net-next,11/12] ice: Remove unnecessary casts
    https://git.kernel.org/netdev/net-next/c/e53a80835f1b
  - [net-next,12/12] ice: Remove unused ICE_FLOW_SEG_HDRS_L2_MASK
    https://git.kernel.org/netdev/net-next/c/f8a3bcceb422

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


