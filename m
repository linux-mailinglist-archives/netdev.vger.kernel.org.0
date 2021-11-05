Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282D4445CD2
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 01:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhKEACr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 20:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232410AbhKEACr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 20:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 927A46121E;
        Fri,  5 Nov 2021 00:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636070408;
        bh=XXI3eorhq/GII46wGAcQuo3BA/TxinGP28/BYA/pICk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CBOyaAlKi2TAOdffXJoCdYhuyLd4xH9zzxjeamF3phwtdEcp/7YDFZ/5GF7HA+MJC
         ZAaJayBodJ9Q/KTsi+IU960DjzvdKWH6EaMDJc9yzWq2DqoPsBbSvUaYeai7ICCGJw
         hQK3y4m1+adrwmRblhrnQOP0RREhQUR5ZbbVJCfb6Y0x4kKVEKEHTTIeavNrEgSPG+
         y5T6hgfdY4UQmQjcKcDQxTEpJMKqsZpiA2XZiccltXzUZMy41iWmCBw6UFLEBea5Cr
         NaCynZvZD77cehMQzFHb/uHfBAYtqqEW/WYjG++lPRu9ZebraB/fxoKWTnnIHLuh5v
         Cu7sUq9cNiJ6g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 88F2960A0E;
        Fri,  5 Nov 2021 00:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/5][pull request] Intel Wired LAN Driver Updates
 2021-11-03
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163607040855.859.8793960423598441511.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Nov 2021 00:00:08 +0000
References: <20211103161935.2997369-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211103161935.2997369-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed,  3 Nov 2021 09:19:30 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Brett fixes issues with promiscuous mode settings not being properly
> enabled and removes setting of VF antispoof along with promiscuous
> mode. He also ensures that VF Tx queues are always disabled and resolves
> a race between virtchnl handling and VF related ndo ops.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/5] ice: Fix VF true promiscuous mode
    https://git.kernel.org/netdev/net/c/1a8c7778bcde
  - [net,v2,2/5] ice: Remove toggling of antispoof for VF trusted promiscuous mode
    https://git.kernel.org/netdev/net/c/0299faeaf8eb
  - [net,v2,3/5] ice: Fix replacing VF hardware MAC to existing MAC filter
    https://git.kernel.org/netdev/net/c/ce572a5b88d5
  - [net,v2,4/5] ice: Fix not stopping Tx queues for VFs
    https://git.kernel.org/netdev/net/c/b385cca47363
  - [net,v2,5/5] ice: Fix race conditions between virtchnl handling and VF ndo ops
    https://git.kernel.org/netdev/net/c/e6ba5273d4ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


