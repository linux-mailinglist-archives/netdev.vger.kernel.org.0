Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDAE30B69C
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 05:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhBBEku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 23:40:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:33934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231156AbhBBEkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 23:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8582064EC3;
        Tue,  2 Feb 2021 04:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612240807;
        bh=py0U03aCtVHni9MJzUi+Z5xtAy7zH/Fw5FyZzwxecGs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DpFv4AfeXZSn2f75OHXU7lurZbj6utvv2gpbXXh6OLExNwC+PU1ZRcn/A/fp4Unda
         lJpS/ryAho91gS3OpX6di67EGuos9+MRtHp9FSIzJXG+to26M6mEO4WM0ZQA3B4JNf
         n7ofoMdKTyXL5n/LU9bmtwHcUB1JGdlywAguZ3Jj6BEOFx6tbUTZ8aIjfox0ohxsqk
         CPIeQ5cyevOwhPyV1UB1DAvpZVAqbAdniMHeI2r+oUUMFYRax9jKQj6aZQO+8IE62/
         3lPwMF6Vqjwr7VJB7QiEZlyNfhoJlHCFc0EG3PRLGKDAek22bGz8dBlgdjwOG/7ivH
         sRVxDbhBC3sVQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7617A60987;
        Tue,  2 Feb 2021 04:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/4][pull request] Intel Wired LAN Driver Updates
 2021-02-01
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161224080747.13099.11355150294613048878.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 04:40:07 +0000
References: <20210201214618.852831-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210201214618.852831-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon,  1 Feb 2021 13:46:14 -0800 you wrote:
> This series contains updates to igc and i40e drivers.
> 
> Kai-Heng Feng fixes igc to report unknown speed and duplex during suspend
> as an attempted read will cause errors.
> 
> Kevin Lo sets the default value to -IGC_ERR_NVM instead of success for
> writing shadow RAM as this could miss a timeout. Also propagates the return
> value for Flow Control configuration to properly pass on errors for igc.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/4] igc: Report speed and duplex as unknown when device is runtime suspended
    https://git.kernel.org/netdev/net/c/2e99dedc73f0
  - [net,v2,2/4] igc: set the default return value to -IGC_ERR_NVM in igc_write_nvm_srwr
    https://git.kernel.org/netdev/net/c/ebc8d125062e
  - [net,v2,3/4] igc: check return value of ret_val in igc_config_fc_after_link_up
    https://git.kernel.org/netdev/net/c/b881145642ce
  - [net,v2,4/4] i40e: Revert "i40e: don't report link up for a VF who hasn't enabled queues"
    https://git.kernel.org/netdev/net/c/f559a356043a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


