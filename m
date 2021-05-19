Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3D03897C4
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 22:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhESUVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 16:21:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229565AbhESUVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 16:21:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 52EE26135F;
        Wed, 19 May 2021 20:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621455615;
        bh=bLfZ6T+0eeJALV2fgqEgxwkeDQvQ35QAOv8EHlCuLis=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZM0qvfH2F+J15M1VR0gwmRf5Ya1rVk7hlqb6C97NtEbUZos14f8N3POZvcUTWE6lS
         i0ynzL5Gf4A8YeMWnYa0cXEYqvMXzgMF3Z95rY7FtiABCRJ4biePO2/YXzTbztyKOQ
         ZrAiKhL24v3f9/ry5cCgmaeenB7bDJ+hfN0mBlCVZqN0lapY9Rm4PkDa7iUyeYs9Vs
         KXIP91sSZPRvD+6s0RECDO832nXhd8psPrikDW9A9VCRx5R/YGnD7ihEgfHcImRcKH
         TIGexv6ZnavRT9YPXvrgybSCbi6eATlXBxK1fy5kGj3sDfmadtgb3vbz+yBimL/e0Z
         JOl07riBTRFAA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4D32F60A0D;
        Wed, 19 May 2021 20:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ixp4xx: Fix return value check in
 ixp4xx_eth_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162145561531.14289.9199299011458304917.git-patchwork-notify@kernel.org>
Date:   Wed, 19 May 2021 20:20:15 +0000
References: <20210519141627.3047264-1-weiyongjun1@huawei.com>
In-Reply-To: <20210519141627.3047264-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     khalasa@piap.pl, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 19 May 2021 14:16:27 +0000 you wrote:
> In case of error, the function mdiobus_get_phy() returns NULL
> pointer not ERR_PTR(). The IS_ERR() test in the return value
> check should be replaced with NULL test.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: ixp4xx: Fix return value check in ixp4xx_eth_probe()
    https://git.kernel.org/netdev/net-next/c/20e76d3d044d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


