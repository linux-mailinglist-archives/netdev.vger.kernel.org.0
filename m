Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C0334533D
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhCVXug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:50:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230367AbhCVXuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 19:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5AC78619A5;
        Mon, 22 Mar 2021 23:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616457009;
        bh=HeNlaJ2mr0M1/LDasbvqoIIRGn4N9bMRmIiD2jfVu30=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QToKLahHHY7LxMu76NeaXVlsD+J7CZKrWs1bm+odiFFOuby8uGxRxgvhUpr04/AtX
         qlheJmN22iS6f26ol+CnZ9XvjwU+AXzCtoJvFk4sOKo+p0z4Xw4YPDFWxxwopeUxVE
         /Ye9qspXNlfcb2DA/OZLIyUiWrFdD7vcCsNWVI4JADxdsY+RymLE1hG5OaMexDlSzH
         E5oRnHyaphY6A6FSRa/+BKewXAZOqhiu2Gp/K8csvJxg3rWpt53YMHkoqoaxRkGDWG
         v9TI+TAocQQJlQO67k7OyP0gWumKsoO7+QEA4+8f6lM8Mb14ImXMl2JNkuhL6jGNbo
         YFQaiS7u4+yhg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 47FAF60074;
        Mon, 22 Mar 2021 23:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] dpaa2-switch: offload bridge port flags to
 device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161645700929.14300.11909770448262821934.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 23:50:09 +0000
References: <20210322205859.606704-1-ciorneiioana@gmail.com>
In-Reply-To: <20210322205859.606704-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 22:58:53 +0200 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> Add support for offloading bridge port flags to the switch. With this
> patch set, the learning, broadcast flooding and unknown ucast/mcast
> flooding states will be user configurable.
> 
> Apart from that, the last patch is a small fix that configures the
> offload_fwd_mark if the switch port is under a bridge or not.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] dpaa2-switch: move the dpaa2_switch_fdb_set_egress_flood function
    https://git.kernel.org/netdev/net-next/c/c7e856c85981
  - [net-next,2/6] dpaa2-switch: refactor the egress flooding domain setup
    https://git.kernel.org/netdev/net-next/c/f054e3e217e4
  - [net-next,3/6] dpaa2-switch: add support for configuring learning state per port
    https://git.kernel.org/netdev/net-next/c/1e7cbabfdb12
  - [net-next,4/6] dpaa2-switch: add support for configuring per port broadcast flooding
    https://git.kernel.org/netdev/net-next/c/b54eb093f5ce
  - [net-next,5/6] dpaa2-switch: add support for configuring per port unknown flooding
    https://git.kernel.org/netdev/net-next/c/6253d5e39ce2
  - [net-next,6/6] dpaa2-switch: mark skbs with offload_fwd_mark
    https://git.kernel.org/netdev/net-next/c/b175dfd7e691

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


