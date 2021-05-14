Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8933813AB
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbhENWVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229940AbhENWVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 18:21:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5EE7061454;
        Fri, 14 May 2021 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621030810;
        bh=GW8Ctr4M0LPQekcgSqZr0T/FnHOX6mFOnrMfCAo+D7A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k03O73dP0SwWyOaWxOhJRKynzqmJlgVlMKNmVNoid9phjD3DsLQdY6Hb5+a8iHP8M
         1Q7lL8T01JZ5cC6QaH02TV4mZ9Kzk8aluC8h0DZ1bWLmp0gYOw4aCLfCttvaeTZVz2
         GqFU3L4z2auVDHmJB6/gk1js1EJGkaban0J/pB4a8j5gnt6NopoynqATcNZevolk66
         s3GVeYSgnOqrxLRW2NodcacSPI96WkT6lPVcpT2V0yRYxHTaQ7Nd/02Pp2dT89Zh/Y
         uMIASA5cO6urXs0otnSl1y1OA6LvZiyNvuxaedn9u+ADpdGDpHc9wEs1rWTMfNPZJB
         zVs5rwdUaq3AQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5290960A0A;
        Fri, 14 May 2021 22:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: cdc_eem: fix URL to CDC EEM 1.0 spec
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162103081033.6483.16738881440987045840.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 22:20:10 +0000
References: <20210514144101.78912-1-jonathan.davies@nutanix.com>
In-Reply-To: <20210514144101.78912-1-jonathan.davies@nutanix.com>
To:     Jonathan Davies <jonathan.davies@nutanix.com>
Cc:     oliver@neukum.org, davem@davemloft.net, kuba@kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 14 May 2021 14:41:01 +0000 you wrote:
> The old URL is no longer accessible.
> 
> Signed-off-by: Jonathan Davies <jonathan.davies@nutanix.com>
> ---
>  drivers/net/usb/cdc_eem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: cdc_eem: fix URL to CDC EEM 1.0 spec
    https://git.kernel.org/netdev/net/c/b81ac7841d51

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


