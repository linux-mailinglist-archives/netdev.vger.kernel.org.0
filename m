Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10B73A4A73
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 23:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhFKVCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 17:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229540AbhFKVCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 17:02:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B48BA613B8;
        Fri, 11 Jun 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623445213;
        bh=upUd+AoCKBHFGMJ0ODUJEI6u0gOfxF3E2djQbrqg6EE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gXhu7B2xWvH+qw261tS9l4bWlwgAC0D4a+VCZW8EdFMLfqL5IRVZa1YmRv912PXxR
         SaE2ZUc1ZvBkdvY3iNOTMptgugAa9nuW09PX1Nuz9tnkBhbM7ce/qqXm6Aj8o5OKw/
         Jpp6QW2Tp0MfTw+pzAsnLVRzBZNhfOSeuxZCsyyP3j6nocM2I7IDnvx1LqRjDejO1q
         1hvH67OwAMDTYXmJ9DGia6ti0KffmV+J9ClqFH6i+tH2f4qTYuukxsO1UWbE3MpBqv
         ADedjPY7LMTTZJS/0xPZFsR/wnBHMdmWPth7ay6+L/1ovZK3Fhjg6O+oHjxR82f4s5
         MRoWEoI2sh3/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC71360A49;
        Fri, 11 Jun 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-06-11
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162344521370.30951.207313918787426556.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 21:00:13 +0000
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, richardcochran@gmail.com,
        jacob.e.keller@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 09:19:52 -0700 you wrote:
> Jake Keller says:
> 
> Extend the ice driver to support basic PTP clock functionality for E810
> devices.
> 
> This includes some tangential work required to setup the sideband queue and
> driver shared parameters as well.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] ice: add support for sideband messages
    https://git.kernel.org/netdev/net-next/c/8f5ee3c477a8
  - [net-next,2/8] ice: process 1588 PTP capabilities during initialization
    https://git.kernel.org/netdev/net-next/c/9733cc94c523
  - [net-next,3/8] ice: add support for set/get of driver-stored firmware parameters
    https://git.kernel.org/netdev/net-next/c/7f9ab54d3144
  - [net-next,4/8] ice: add low level PTP clock access functions
    https://git.kernel.org/netdev/net-next/c/03cb4473be92
  - [net-next,5/8] ice: register 1588 PTP clock device object for E810 devices
    https://git.kernel.org/netdev/net-next/c/06c16d89d2cb
  - [net-next,6/8] ice: report the PTP clock index in ethtool .get_ts_info
    https://git.kernel.org/netdev/net-next/c/67569a7f9401
  - [net-next,7/8] ice: enable receive hardware timestamping
    https://git.kernel.org/netdev/net-next/c/77a781155a65
  - [net-next,8/8] ice: enable transmit timestamps for E810 devices
    https://git.kernel.org/netdev/net-next/c/ea9b847cda64

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


