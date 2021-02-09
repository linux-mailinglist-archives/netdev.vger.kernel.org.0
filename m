Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A775315AB5
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbhBJAJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:09:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:58278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234589AbhBIXuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 18:50:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C2F8564E3E;
        Tue,  9 Feb 2021 23:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612914611;
        bh=v6PUT36kK3GlD2L1toFiq1YoFB94kzZ/5/to/rLDi/o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ktZ2PYS0vHP0hT7WXPPuOS1/pMy6QOuBboLnx+z7aZBcvDLlTi0t5Pf+V26ioKXrG
         BRyc+6aTJAsIZkGVElO5ZMhcVMZ2Rx3TOM9ngKu2YsLN54fH6uenrpVu2UgQJAeB5z
         ylgDloMWfuEYMQgvVrBrW3L2Atb4ieRb5Tx48dXO/KAUcjtcMaLjbP3lNOxDCKppoR
         kyE1OXB7FTs4UptRVjsFzue7tBwmt0hilxyvWEHKeSLByaa0pVCWFMlcITGK857h68
         BW31LOSf54SehRI6MDFxffCV/xwttQ/dNn+XBiKZhXRmdJbXjD1UsgWF5FNGJTD85J
         6ZkoSNyf8FTBw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B2894609E4;
        Tue,  9 Feb 2021 23:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-02-08
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161291461172.1297.6146270565979403872.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 23:50:11 +0000
References: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon,  8 Feb 2021 17:16:24 -0800 you wrote:
> This series contains updates to the ice driver and documentation.
> 
> Brett adds a log message when a trusted VF goes in and out of promiscuous
> for consistency with i40e driver.
> 
> Dave implements a new LLDP command that allows adding VSI destinations to
> existing filters and adds support for netdev bonding events, current
> support is software based.
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] ice: log message when trusted VF goes in/out of promisc mode
    https://git.kernel.org/netdev/net-next/c/382e0a6880e7
  - [net-next,02/12] ice: implement new LLDP filter command
    https://git.kernel.org/netdev/net-next/c/34295a3696fb
  - [net-next,03/12] ice: Remove xsk_buff_pool from VSI structure
    https://git.kernel.org/netdev/net-next/c/c7a219048e45
  - [net-next,04/12] ice: Add initial support framework for LAG
    https://git.kernel.org/netdev/net-next/c/df006dd4b1dc
  - [net-next,05/12] ice: create scheduler aggregator node config and move VSIs
    https://git.kernel.org/netdev/net-next/c/b126bd6bcd67
  - [net-next,06/12] ice: Use PSM clock frequency to calculate RL profiles
    https://git.kernel.org/netdev/net-next/c/4f8a14976aa4
  - [net-next,07/12] ice: fix writeback enable logic
    https://git.kernel.org/netdev/net-next/c/1d9f7ca324a9
  - [net-next,08/12] ice: Refactor DCB related variables out of the ice_port_info struct
    https://git.kernel.org/netdev/net-next/c/fc2d1165d4a4
  - [net-next,09/12] ice: remove unnecessary casts
    https://git.kernel.org/netdev/net-next/c/7a63dae0fafb
  - [net-next,10/12] ice: Fix trivial error message
    https://git.kernel.org/netdev/net-next/c/fe6cd89050d9
  - [net-next,11/12] ice: Improve MSI-X fallback logic
    https://git.kernel.org/netdev/net-next/c/741106f7bd8d
  - [net-next,12/12] Documentation: ice: update documentation
    https://git.kernel.org/netdev/net-next/c/a851dfa8dfa7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


