Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142942DC827
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 22:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgLPVKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 16:10:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:54530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727582AbgLPVKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 16:10:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608153007;
        bh=8GZPH8Z7asuJN5vhZiTOpnUkw7jncr+MBNyG3peB2Q4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ISsr5sitllFIhfnv4TWvVvLGI7f2JY/8T0VZwOoOI0p35sSi9zpM4+holNLqy10p9
         jhyXzJVWgj55SKIWahZOCbrhHQcqpqRBFTR9p1GBvK0DtnoN4d2htX4qXHZoORe5en
         d5+IE2yoP/UT1nZMtZNAzbiw8JZGBsqD2zxwPz7ALMzueh75SYJ/sgaZ3jaYK7bquC
         4QgmC16BmRwEQ6sOmwF2ELdOgfcIcZKZgcFYFRayFQbd0cjgZSKAgR0GWcRf+e/Dy2
         puzTP7kMp5umDKRE+aO9D5WaKRMJgEUzo3eMJFqzr60EQ4k5k7SDz2fQyT07yeVPdh
         6CQ7leHvs0g5w==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] tipc: do sanity check payload of a netlink message
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160815300721.24771.295476153583581957.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Dec 2020 21:10:07 +0000
References: <20201215033151.76139-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20201215033151.76139-1-hoang.h.le@dektech.com.au>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 15 Dec 2020 10:31:51 +0700 you wrote:
> From: Hoang Le <hoang.h.le@dektech.com.au>
> 
> When we initialize nlmsghdr with no payload inside tipc_nl_compat_dumpit()
> the parsing function returns -EINVAL. We fix it by making the parsing call
> conditional.
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
> 
> [...]

Here is the summary with links:
  - [net-next] tipc: do sanity check payload of a netlink message
    https://git.kernel.org/netdev/net/c/c32c928d29de

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


