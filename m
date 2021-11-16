Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A33453303
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 14:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbhKPNnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 08:43:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:57346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236791AbhKPNnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 08:43:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 178B563213;
        Tue, 16 Nov 2021 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637070011;
        bh=nMBwJ4N3QF/IGKtfx8zYENtDQfcXmpHnAGq5m+ajh90=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=THTTx68t3NNcl68pz/y2ck61HrvPUpcOR732MG8Zf5Z9/DRPKQUaXftMxuQQWJSa7
         IwH6/yb9MZPhqRNRys4gD9rc1w/gLfeRd9WNHq3xN8GysNXEpTO8tBmR0bIKTinnOE
         fm/wvFHJvrsXoV0E7FeiifIEPIF4pnE+EQnTYYsR9pGtPhnJc1rk8lH9G35z/CT7fy
         kQCaSEj8ViTFjAceOobXWat/rUniSDEWdH0CqwBVou0Ot2e/EIiKZBAn/fAV1Ph2Rc
         8lRZHP0eASjilOt2T/8NfAomzS7k9szPfjaIk8KFGpJPtT13mRua6xOiMR9CXP/9+s
         aKfoBiXNR+TgA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0D7EC60A49;
        Tue, 16 Nov 2021 13:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 00/10][pull request] Intel Wired LAN Driver Updates
 2021-11-15
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163707001105.28808.8761693129917968476.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Nov 2021 13:40:11 +0000
References: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 15 Nov 2021 15:59:24 -0800 you wrote:
> This series contains updates to iavf driver only.
> 
> Mateusz adds a wait for reset completion when changing queue count which
> could otherwise cause issues with VF reset.
> 
> Nick adds a null check for vf_res in iavf_fix_features(), corrects
> ordering of function calls to resolve dependency issues, and prevents
> possible freeing of a lock which isn't being held.
> 
> [...]

Here is the summary with links:
  - [net,01/10] iavf: Fix return of set the new channel count
    https://git.kernel.org/netdev/net/c/4e5e6b5d9d13
  - [net,02/10] iavf: check for null in iavf_fix_features
    https://git.kernel.org/netdev/net/c/8a4a126f4be8
  - [net,03/10] iavf: free q_vectors before queues in iavf_disable_vf
    https://git.kernel.org/netdev/net/c/89f22f129696
  - [net,04/10] iavf: don't clear a lock we don't hold
    https://git.kernel.org/netdev/net/c/2135a8d5c818
  - [net,05/10] iavf: Fix failure to exit out from last all-multicast mode
    https://git.kernel.org/netdev/net/c/8905072a192f
  - [net,06/10] iavf: prevent accidental free of filter structure
    https://git.kernel.org/netdev/net/c/4f0400803818
  - [net,07/10] iavf: validate pointers
    https://git.kernel.org/netdev/net/c/131b0edc4028
  - [net,08/10] iavf: Fix for the false positive ASQ/ARQ errors while issuing VF reset
    https://git.kernel.org/netdev/net/c/321421b57a12
  - [net,09/10] iavf: Fix for setting queues to 0
    https://git.kernel.org/netdev/net/c/9a6e9e483a96
  - [net,10/10] iavf: Restore VLAN filters after link down
    https://git.kernel.org/netdev/net/c/4293014230b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


