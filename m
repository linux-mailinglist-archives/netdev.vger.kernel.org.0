Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9003B220A
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 22:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhFWUwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 16:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229800AbhFWUwV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 16:52:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B827D60234;
        Wed, 23 Jun 2021 20:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624481403;
        bh=rFwswodeKVEnjYsGgpiNg9T7sJMbkLnibysFCvmhSWM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EuGLy6ZawKGkE4j0WwOuDyCWuE2Nm75xLWaUb4PB72Ywx+werRjhUhuyc0snw0t3P
         U3kNDNdoRrKqX/k3AHf6QOzvkmB7B7YLfJkh3cIu6c+8BVWDvx+wk0mzzctYpPkLdJ
         cX5sGL6aoPxmpu+NUL0hWUL8Ll8bS7nTTTIhU+C/KF1GYuO4wKwxuqlw+hSwOTlKhf
         sLTNhISKzTgtKG1Y5GoEqlovVVgnlmjaS64hzlqb6J13vkyUb/p09tQKyO6JuBwlI1
         Ule0PV5ucuZ8dz62M1NpaysSn7XLiYZ5BVqzNkA0W9m0wctbHj0gmFcYFX65lDobTT
         GIDY2gl0jqr6A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A73FC609B1;
        Wed, 23 Jun 2021 20:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bonding: allow nesting of bonding device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162448140368.19131.15507947414317919406.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Jun 2021 20:50:03 +0000
References: <20210623032108.51472-1-zhudi21@huawei.com>
In-Reply-To: <20210623032108.51472-1-zhudi21@huawei.com>
To:     zhudi <zhudi21@huawei.com>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, kuba@kernel.org,
        davem@davemloft.net, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, rose.chen@huawei.com,
        jay.vosburgh@canonical.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 23 Jun 2021 11:21:08 +0800 you wrote:
> From: Di Zhu <zhudi21@huawei.com>
> 
> The commit 3c9ef511b9fa ("bonding: avoid adding slave device with
> IFF_MASTER flag") fix a crash when add slave device with IFF_MASTER,
> but it rejects the scenario of nested bonding device.
> 
> As Eric Dumazet described: since there indeed is a usage scenario about
> nesting bonding, we should not break it.
> 
> [...]

Here is the summary with links:
  - bonding: allow nesting of bonding device
    https://git.kernel.org/netdev/net/c/4d293fe1c69c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


