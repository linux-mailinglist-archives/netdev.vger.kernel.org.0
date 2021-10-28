Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9C643E26A
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhJ1Nmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:42:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230017AbhJ1Nmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 09:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B416E61056;
        Thu, 28 Oct 2021 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635428407;
        bh=9npv/cjxYLgWzniB+FzdW3eEsxESCzAedZsPmmnbqhk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jVtn3TkZNwt36JP8/4w4xohZVK3ybiKtKAQKMJpPzLQkOSj5Xrd430yYL2QsTUczV
         1blnm6TVgKftR6U3NjsEdeeVv2hY48evboxMaL/geiq/VXjZbvpyn0wVo2ljBzzki7
         iViTJpndOGhsmNTbASmCMDxxSbjAE13B9rrqX45zedP02MoLIm+fwZzfaUA6bZ+VxR
         Bv2wGj0EC+lbzZ0nNGjoAsEs0kn0jlHdAGHv1Gg0O1jPFsZRwew2fEB5Js8CAbdml6
         RWNcQpwlXbUM8ELQl303rMbI5ytwez27X3pZNZaxrxhWLj6Wr6TNFvYWRvy1q/pVyH
         rjepxj3NAiVDg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A070360972;
        Thu, 28 Oct 2021 13:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] devlink: add documentation for octeontx2 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542840765.2633.14158922092736631678.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 13:40:07 +0000
References: <1635426495-28458-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1635426495-28458-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        hkelam@marvell.com, gakula@marvell.com, sgoutham@marvell.com,
        rsaladi2@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Oct 2021 18:38:15 +0530 you wrote:
> Add a file to document devlink support for octeontx2
> driver. Driver-specific parameters implemented by
> AF, PF and VF drivers are documented.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: add documentation for octeontx2 driver
    https://git.kernel.org/netdev/net-next/c/442e796f0aa7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


