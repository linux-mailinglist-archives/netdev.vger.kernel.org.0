Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F147F34DC93
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhC2Xke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230224AbhC2XkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 19:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 09EF3619A9;
        Mon, 29 Mar 2021 23:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617061212;
        bh=XQX7J2neRF0XDIOYaB9xyh/rXsUr00NjWW3wW+TDP74=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EJhO8iqS8OgT+ER2c4Q1ZZvh4I04EcGDrjDRdwxjS4CtI2Osjz91PXsfSRQfbWrI0
         iXvB5PPGji2CpcOsMR/ZjzYdxjfhSOkuwUbn/6F1B24mYyBQ9EMfWJtoSlFoRDR6zO
         wHWwJC7M7lTnnsFfEPvbznGbE4jogvtIeSyWh98ONFULB+vtclU0LUsh608dgzpO28
         9pKZcKoOCcFlX6Nb+Fw5Jd7PXWfejKzrcL7Xu2KiBxNlf6+XPONtSTQr30hV535nne
         DS2spQGFGAaQmcq9gOLy1YK7EaFtGOYNqH8epfAHs2vqLlRufq/Zd2ivTwH1/uCy87
         uwuJYTlOpF+Tg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0139560074;
        Mon, 29 Mar 2021 23:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-03-29
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161706121200.22281.17374457897788184656.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 23:40:12 +0000
References: <20210329170931.2356162-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210329170931.2356162-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        jithu.joseph@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 10:09:23 -0700 you wrote:
> This series contains updates to igc driver only.
> 
> Andre Guedes says:
> 
> Add XDP support for the igc driver. The approach implemented by this
> series follows the same approach implemented in other Intel drivers as
> much as possible for the sake of consistency.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] igc: Remove unused argument from igc_tx_cmd_type()
    https://git.kernel.org/netdev/net-next/c/2f019ebd5330
  - [net-next,2/8] igc: Introduce igc_rx_buffer_flip() helper
    https://git.kernel.org/netdev/net-next/c/613cf199fd10
  - [net-next,3/8] igc: Introduce igc_get_rx_frame_truesize() helper
    https://git.kernel.org/netdev/net-next/c/a39f5e530559
  - [net-next,4/8] igc: Refactor Rx timestamp handling
    https://git.kernel.org/netdev/net-next/c/e1ed4f92a625
  - [net-next,5/8] igc: Add set/clear large buffer helpers
    https://git.kernel.org/netdev/net-next/c/1bf33f71f981
  - [net-next,6/8] igc: Add initial XDP support
    https://git.kernel.org/netdev/net-next/c/26575105d6ed
  - [net-next,7/8] igc: Add support for XDP_TX action
    https://git.kernel.org/netdev/net-next/c/73f1071c1d29
  - [net-next,8/8] igc: Add support for XDP_REDIRECT action
    https://git.kernel.org/netdev/net-next/c/4ff320361092

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


