Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D456636168B
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236102AbhDOXuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:50:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234866AbhDOXuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:50:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B631E61158;
        Thu, 15 Apr 2021 23:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618530611;
        bh=Dc9p6Esv545CXJ0VshQ5IwbRQHLZaTuzH2ovxX3ndR8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H/hh1SMVSTzA29p4cEanaQiagLeE+lIbe8z+yn1V96tAPdUtjd/QHoP7ktQN1SKGC
         6Dhzr4vUN/egveTXEt/8caHVyEPeorTxPECWjJQLM3rZSr6JoaHofYLPRQkkh7T7aL
         JFyBanQuY7OZ9p+tJiS3JzVoJbnSnqNVmsAv6OgNQc7gM/Vn73PR647JVRJVVtkiQU
         5HfnMLFL++b4vx29HG/azm0mYgWGM8NkHfxFYJhV1T2LLI6j8iVSP1kUiTYaztXhvm
         1A/YVj1zmU2o/6dYLTd4YoKnLXDryEkvZx2kJrWH9o635b8RFzPihAXNX9IhkiiXqG
         M/6MCuTOZ2RVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B05CA60CD1;
        Thu, 15 Apr 2021 23:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-04-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161853061171.30410.2291923508287705765.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Apr 2021 23:50:11 +0000
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 14 Apr 2021 17:29:58 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Bruce changes and removes open coded values to instead use existing
> kernel defines and suppresses false cppcheck issues.
> 
> Ani adds new VSI states to track netdev allocation and registration. He
> also removes leading underscores in the ice_pf_state enum.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] ice: use kernel definitions for IANA protocol ports and ether-types
    https://git.kernel.org/netdev/net-next/c/d41f26b5ef8f
  - [net-next,02/15] ice: Drop leading underscores in enum ice_pf_state
    https://git.kernel.org/netdev/net-next/c/7e408e07b42d
  - [net-next,03/15] ice: Add new VSI states to track netdev alloc/registration
    https://git.kernel.org/netdev/net-next/c/a476d72abe6c
  - [net-next,04/15] ice: refactor interrupt moderation writes
    https://git.kernel.org/netdev/net-next/c/b8b4772377dd
  - [net-next,05/15] ice: replace custom AIM algorithm with kernel's DIM library
    https://git.kernel.org/netdev/net-next/c/cdf1f1f16917
  - [net-next,06/15] ice: manage interrupts during poll exit
    https://git.kernel.org/netdev/net-next/c/b7306b42beaf
  - [net-next,07/15] ice: refactor ITR data structures
    https://git.kernel.org/netdev/net-next/c/d59684a07e37
  - [net-next,08/15] ice: Reimplement module reads used by ethtool
    https://git.kernel.org/netdev/net-next/c/e9c9692c8a81
  - [net-next,09/15] ice: print name in /proc/iomem
    https://git.kernel.org/netdev/net-next/c/80ad6dde6189
  - [net-next,10/15] ice: use local for consistency
    https://git.kernel.org/netdev/net-next/c/58623c52b427
  - [net-next,11/15] ice: remove unused struct member
    https://git.kernel.org/netdev/net-next/c/1cdea9a7eae3
  - [net-next,12/15] ice: Set vsi->vf_id as ICE_INVAL_VFID for non VF VSI types
    https://git.kernel.org/netdev/net-next/c/c931c782d846
  - [net-next,13/15] ice: suppress false cppcheck issues
    https://git.kernel.org/netdev/net-next/c/b370245b4b95
  - [net-next,14/15] ice: remove return variable
    https://git.kernel.org/netdev/net-next/c/4fe36226943b
  - [net-next,15/15] ice: reduce scope of variable
    https://git.kernel.org/netdev/net-next/c/4c26f69d0cf9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


