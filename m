Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEAC3E14E8
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241428AbhHEMkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240484AbhHEMkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 08:40:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5904B6113C;
        Thu,  5 Aug 2021 12:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628167206;
        bh=DP46H24GDRgCP4SFjoSD7ZUPbVed06UfvRGlnMPXTsA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c+I1n/smb3Rthza0iYLu3jtyDz3CrtUGE9uMuYj3kDqpcu4OsQbi9W/8R6H2g0o60
         ui9Wv8zI0FL6tQ+2wpPniKidExrZe9wfKEII0Yjyqyr0tW1BUUFEDcgWHDTES8192Q
         xu0cBYcIztXsb+mZ5XUQ7stEOFa/+emjk1IDws2bU/dPybXlMKBekc5UVllCBeYH9a
         cfp8x9lkb1s26VEouTCWk5TWaDn0lX/cZ56GXjBrgG37M81XjNcX9tzsaGFZQfDqi1
         mEBVHoHLKEKwL+cELP4HPA2KKQn3Om3vdtzOA/B5Ptj1f0d8/tjhRJB1MDJvrSsWbh
         RIxj/03/lCfkw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3D3A960A88;
        Thu,  5 Aug 2021 12:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: am65-cpsw: fix crash in
 am65_cpsw_port_offload_fwd_mark_update()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162816720624.10114.13998361030687843498.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Aug 2021 12:40:06 +0000
References: <20210805101409.3366-1-grygorii.strashko@ti.com>
In-Reply-To: <20210805101409.3366-1-grygorii.strashko@ti.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vigneshr@ti.com, lokeshvutla@ti.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 5 Aug 2021 13:14:09 +0300 you wrote:
> The am65_cpsw_port_offload_fwd_mark_update() causes NULL exception crash
> when there is at least one disabled port and any other port added to the
> bridge first time.
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000858
> pc : am65_cpsw_port_offload_fwd_mark_update+0x54/0x68
> lr : am65_cpsw_netdevice_event+0x8c/0xf0
> Call trace:
> am65_cpsw_port_offload_fwd_mark_update+0x54/0x68
> notifier_call_chain+0x54/0x98
> raw_notifier_call_chain+0x14/0x20
> call_netdevice_notifiers_info+0x34/0x78
> __netdev_upper_dev_link+0x1c8/0x290
> netdev_master_upper_dev_link+0x1c/0x28
> br_add_if+0x3f0/0x6d0 [bridge]
> 
> [...]

Here is the summary with links:
  - net: ethernet: ti: am65-cpsw: fix crash in am65_cpsw_port_offload_fwd_mark_update()
    https://git.kernel.org/netdev/net/c/ae03d189bae3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


