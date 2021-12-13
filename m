Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF2C472FEB
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239768AbhLMPAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbhLMPAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:00:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB65C061574;
        Mon, 13 Dec 2021 07:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8867E6113E;
        Mon, 13 Dec 2021 15:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7772C34604;
        Mon, 13 Dec 2021 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639407609;
        bh=zNTp3B/zl8CgRafLCfcZNfF/r+AwkWd6CpV9rHcp+Qc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uRsMSEI37sEGrwUG1qljsWaB4iRWFUpYqZWD+Mld00mrCrQ40tg6lxmb2ZMlbNqhU
         upPXjmb2rYtueHR+X50emu5EkYrrJ2yzxapiC3Veqba6vepO9Ym9IcNfOzxYk6pId+
         aY8rIrJAgrumurIUadpXG6ncJy3AASJqONvS0GmViKyxlZt62WVbxa13MBMa58PH60
         1WMeu0UUz8ThNg78Dq89rrP0YJ1qyjiO8YG6eOv0xjOhkcG8I3bc99dk8Y9Af66/eK
         LERyKRYWKbV9mB2Bp7idhUoNsNxrOGbXaFNdAQAZuHQfsX0m9gBy1EWU/frtfi9Ciw
         rzRPBmSX3eYkQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BFF0860A3C;
        Mon, 13 Dec 2021 15:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: add missing of_node_put before return
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940760978.26947.303902787430229511.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 15:00:09 +0000
References: <1639388676-63990-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1639388676-63990-1-git-send-email-wangqing@vivo.com>
To:     Qing Wang <wangqing@vivo.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Dec 2021 01:44:36 -0800 you wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> Fix following coccicheck warning:
> WARNING: Function "for_each_child_of_node"
> should have of_node_put() before return.
> 
> Early exits from for_each_child_of_node should decrement the
> node reference counter.
> 
> [...]

Here is the summary with links:
  - net: ethernet: ti: add missing of_node_put before return
    https://git.kernel.org/netdev/net/c/be565ec71d1d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


