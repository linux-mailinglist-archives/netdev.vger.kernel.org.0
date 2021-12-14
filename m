Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDC34742C7
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhLNMkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:40:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35584 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234078AbhLNMkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 07:40:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5469D614D6
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7A36C34609;
        Tue, 14 Dec 2021 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639485611;
        bh=Gke9hSHs6NZDPXHBT1XNpL9oFwU1yntfeLMFEDXhwcs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BlDxbdPZWQYxOR/fO5IBQj4KRsH+/X5tB/C3/QFO9ym1dtYJyZIwos8mzHq+EobOd
         LThyY2UNNpc2i1pA0o0LUvP/mHhdZ0+UEye680jx68+Y9T7LqN1oWvlBqJDsmBL2Km
         OFqVCzLcerib5aRJpqfYOQ+GDmsXuaBrB4wjwRoterASC9Dpqf3tbbUggX5SxpsdhG
         Nn6oQ5JN2aScg99+nFEQWO0h2m4iGPGK5FY6/QyIv277/cIhO7lQYF60cl8BK8b1M8
         vHMotmTVIlbirI+/5ESQDD9OwZOP37QXf0s/l3GZL1qTLHPSBWWbLO54TORmGz7Wqv
         /6fDbfjn2cz8g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A5FC0609BA;
        Tue, 14 Dec 2021 12:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] bareudp: Add extack support to bareudp_configure()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163948561167.12013.3217881532774578637.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Dec 2021 12:40:11 +0000
References: <1cb1c14b1423222550601004a3053722c9200f6f.1639417012.git.gnault@redhat.com>
In-Reply-To: <1cb1c14b1423222550601004a3053722c9200f6f.1639417012.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        martin.varghese@nokia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Dec 2021 19:17:17 +0100 you wrote:
> Add missing extacks for common configuration errors.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  drivers/net/bareudp.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] bareudp: Add extack support to bareudp_configure()
    https://git.kernel.org/netdev/net-next/c/b4bffa4ceab1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


