Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6484434DC8D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhC2Xk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230212AbhC2XkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 19:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9C67A61924;
        Mon, 29 Mar 2021 23:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617061209;
        bh=Fzc5MooOIjaGhXjJJnv/tfA5k2z1p2T4YEgeXYpFbvs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tQjvEQaJp482TKhb3TCegkPtLIBSu7MxrAFhdJBGVDSXK7YnJMz4oPfGDDDNnuF3y
         nr2tCui+x06ZiIv0HrmjwR3Tuj6zsGZ1cQoXXYRmTjeMOKx9KcY23BaCG3gsev38I9
         TSxBMYdS9m8NUY0KTq3Oec5mrNLcabK3ytjU1y5oJoBiZR/8q0C9UlVkXOGWPtz6Kz
         CaDEru5P9anGF7kHHKaRscJrz39ckguRePTJqac/3LsQDg1oyGc0USLTz4wo2x8wUD
         94cUHVF9ZVOTAojHtGuGo7oppmO0YjtyUJjVBOZXZLrHGdc40UgSUvAxsVaYz0ppN2
         Qwf5t5YPEJ+dw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9150960074;
        Mon, 29 Mar 2021 23:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/9][pull request] Intel Wired LAN Driver Updates
 2021-03-29
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161706120959.22281.3877698385206092078.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 23:40:09 +0000
References: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 29 Mar 2021 13:18:48 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Ani does not fail on link/PHY errors during probe as this is not a fatal
> error to prevent the user from remedying the problem. He also corrects
> checking Wake on LAN support to be port number, not PF ID.
> 
> Fabio increases the AdminQ timeout as some commands can take longer than
> the current value.
> 
> [...]

Here is the summary with links:
  - [net,1/9] ice: Continue probe on link/PHY errors
    https://git.kernel.org/netdev/net/c/08771bce3300
  - [net,2/9] ice: Increase control queue timeout
    https://git.kernel.org/netdev/net/c/f88c529ac77b
  - [net,3/9] ice: Recognize 860 as iSCSI port in CEE mode
    https://git.kernel.org/netdev/net/c/aeac8ce864d9
  - [net,4/9] ice: prevent ice_open and ice_stop during reset
    https://git.kernel.org/netdev/net/c/e95fc8573e07
  - [net,5/9] ice: fix memory allocation call
    https://git.kernel.org/netdev/net/c/59df14f9cc23
  - [net,6/9] ice: remove DCBNL_DEVRESET bit from PF state
    https://git.kernel.org/netdev/net/c/741b7b743bbc
  - [net,7/9] ice: Fix for dereference of NULL pointer
    https://git.kernel.org/netdev/net/c/7a91d3f02b04
  - [net,8/9] ice: Use port number instead of PF ID for WoL
    https://git.kernel.org/netdev/net/c/3176551979b9
  - [net,9/9] ice: Cleanup fltr list in case of allocation issues
    https://git.kernel.org/netdev/net/c/b7eeb52721fe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


