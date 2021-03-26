Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E4D349D9B
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhCZAUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhCZAUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 256AC61A41;
        Fri, 26 Mar 2021 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718010;
        bh=202tDrDrG3qsmiV66y3CG2g8JozX4gJyl7tHusiviSc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oBS3NA5Fg/VMufTCFMkx9S1CIolH2udtK4UZXMMF7VrdhQcdwTK+34R1hVWMDxVCI
         uuVc0xFuDjraiEhrQiC+O5wVlSSiWKwU/KCHoqC3aV1DzHpLuYaRqOPG6bDcWJ2djh
         742uiK+XE/7Dqp7FFPAWr4JeBfKl4HN+Nxe55KaV1aFB7IZ716lZgzm9oWWl0dEceh
         /0iXZNP9QJVfZAwMGNuYVY7Z6jdKVAn+pYl/cjPf2WpBMRLhkC86mM/4dg/dyEu1vC
         Zis7WmIB8qEczVGnYL8TA8NVMcJ61XQYPb9MKR8b/qYVYP5yZAKLHeE1/ESGtteDGt
         EfJt2xeOVZa1g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1F99B6008E;
        Fri, 26 Mar 2021 00:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers: net: ethernet: struct sk_buff is declared
 duplicately
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671801012.29431.14505392166407439391.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:20:10 +0000
References: <20210325063559.853282-1-wanjiabing@vivo.com>
In-Reply-To: <20210325063559.853282-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     simon.horman@netronome.com, kuba@kernel.org, davem@davemloft.net,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 25 Mar 2021 14:35:55 +0800 you wrote:
> struct sk_buff has been declared. Remove the duplicate.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_app.h | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - drivers: net: ethernet: struct sk_buff is declared duplicately
    https://git.kernel.org/netdev/net-next/c/01dc080be6b8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


