Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5609741DA3E
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351120AbhI3Mvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:51:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351070AbhI3Mvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 08:51:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 30DEB619A6;
        Thu, 30 Sep 2021 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633006208;
        bh=Tbjk5nVoB1lzJ2wEqqEEaeh8Bq2eZMQG7O0N1l/HnP0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gTrl/qa9CCYMPh+eE0XzZokdX3eonwH3ZrMIAyp2ne26IXy3M0B+FqclGs4C9xKJ5
         1yL0RvpY4K0I1JY+F+H//OarNIbfDshKAVMXFvKJ0W/WvfhKzRKkuhjHYlsvJLO/cQ
         BuM1pxZQGJIme4OzJ0fDE7Gl+1Jec9gK8bBrb+crAPZCcfotGdAfiKyLaJQkjDHN/a
         MWEspqLCbxACLDjzUoCL0FErsHQUgELod77dtxFfwTpIY50NaGN5JaOZ9tdZVY+RQN
         STH9AA3Xqo6GgP4xMgFQWTpeWc8l9QodfC1qT6g3aNJFIXfttEBZ57jEJUc0LXc1xJ
         zGkgLm5ijAk8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 242D560AA5;
        Thu, 30 Sep 2021 12:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] ixgbe: let the xdpdrv work with more than 64
 cpus
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163300620814.1111.13000461689330514849.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Sep 2021 12:50:08 +0000
References: <20210929175605.3963510-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210929175605.3963510-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xingwanli@kuaishou.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kpsingh@kernel.org, kafai@fb.com, yhs@fb.com, songliubraving@fb.co,
        bpf@vger.kernel.org, lishujin@kuaishou.com,
        sandeep.penigalapati@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 29 Sep 2021 10:56:05 -0700 you wrote:
> From: Jason Xing <xingwanli@kuaishou.com>
> 
> Originally, ixgbe driver doesn't allow the mounting of xdpdrv if the
> server is equipped with more than 64 cpus online. So it turns out that
> the loading of xdpdrv causes the "NOMEM" failure.
> 
> Actually, we can adjust the algorithm and then make it work through
> mapping the current cpu to some xdp ring with the protect of @tx_lock.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] ixgbe: let the xdpdrv work with more than 64 cpus
    https://git.kernel.org/netdev/net-next/c/4fe815850bdc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


