Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8924241C22C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245252AbhI2KBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245247AbhI2KBr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:01:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B966F613CD;
        Wed, 29 Sep 2021 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632909606;
        bh=ckY2GL0Q7QnX1zQI1hAF2j2bVYDBNxOCBll9Fod9thk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g0Nc9b6vkSmSCUI0hspxh3u3c2JEHg0gLJtEK1o/EkaTvOQXCWoNi4+T1dgLQDyoS
         gLtpioHv7V0TF1OHQ33vxjQqjVfPEb7t25gO++wBiheo8L4BGQfzZnu9fFJJ2XGSR5
         dMJkrXqzJHX1vB2SIKfizw+8gdhTv6exL8s5c5g/arIptnMBbInU7CTDgu8FAx34+i
         WjL3+moA6eYkN35jszggeW3myTm4JAWSY+AWBIEzAWOVsTpQd2Peg4K6ymJ0XRn0Av
         cxKZSCX/WztoaPzuclqS7ava+l08MUg0VDZMKRIBCbgbVQUGbEfCkZHmNSGBbVFpUd
         fyyfDAzMvliKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AB70960A7E;
        Wed, 29 Sep 2021 10:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] ixgbe: Fix NULL pointer dereference in
 ixgbe_xdp_setup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163290960669.9595.16080686564264021241.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Sep 2021 10:00:06 +0000
References: <20210928222359.3380825-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210928222359.3380825-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, zhoufeng.zf@bytedance.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        sandeep.penigalapati@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 28 Sep 2021 15:23:59 -0700 you wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> The ixgbe driver currently generates a NULL pointer dereference with
> some machine (online cpus < 63). This is due to the fact that the
> maximum value of num_xdp_queues is nr_cpu_ids. Code is in
> "ixgbe_set_rss_queues"".
> 
> [...]

Here is the summary with links:
  - [net,1/1] ixgbe: Fix NULL pointer dereference in ixgbe_xdp_setup
    https://git.kernel.org/netdev/net/c/513e605d7a9c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


