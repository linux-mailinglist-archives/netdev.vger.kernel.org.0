Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82262C1A7F
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 02:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgKXBAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 20:00:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgKXBAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 20:00:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606179605;
        bh=FB/vSPZnN4Bjc7LlvjvI8kHdZYZBGe+dqTl/Ijm+Vi8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GJnt2Jy5ePGXJfdeTlYKw12CsLwndOwFwfEx3Gzo8IWse9eTREDouGHvXxe2SfCa2
         zE80XSzNuMoeDwvk+WEBsxDO4fM9SyjLlDxu1dpgwHYyFmRveyv7sHkz3IS29Nv5uW
         XbDdi+0IiBEARqiduFH7ryHRJMo7f8IU5d+KxiuA=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] i40e: Fix removing driver while bare-metal VFs pass
 traffic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160617960585.25502.16566944216033465342.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Nov 2020 01:00:05 +0000
References: <20201120180640.3654474-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20201120180640.3654474-1-anthony.l.nguyen@intel.com>
To:     Nguyen@ci.codeaurora.org, Anthony L <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        sylwesterx.dziedziuch@intel.com, netdev@vger.kernel.org,
        sassmann@redhat.com, slawomirx.laba@intel.com,
        brett.creeley@intel.com, konrad0.jankowski@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 20 Nov 2020 10:06:40 -0800 you wrote:
> From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
> 
> Prevent VFs from resetting when PF driver is being unloaded:
> - introduce new pf state: __I40E_VF_RESETS_DISABLED;
> - check if pf state has __I40E_VF_RESETS_DISABLED state set,
>   if so, disable any further VFLR event notifications;
> - when i40e_remove (rmmod i40e) is called, disable any resets on
>   the VFs;
> 
> [...]

Here is the summary with links:
  - [net,1/1] i40e: Fix removing driver while bare-metal VFs pass traffic
    https://git.kernel.org/netdev/net/c/2980cbd4dce7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


