Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72AEB466445
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 14:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357769AbhLBNNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 08:13:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51292 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235891AbhLBNNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 08:13:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 885ADB8235A;
        Thu,  2 Dec 2021 13:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4ED0BC53FD5;
        Thu,  2 Dec 2021 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638450609;
        bh=XnRKfdjyCvRPASdmWya9LkowSCgI1Yyxwb6lMXaASJg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AT9etGBag/fxD5SU3cffcHPLWVTLv3ZNBCs1tQ/F7H8Gq/F7TsFebSNfgZFH3Thhz
         yV/YaFS+EeMrpsTYSUcdRb4zbO6prCZ1oyIfnFdhNMCuBbh7ZM4BfCPJUjsXu5Aud5
         xh7AZRzyE2zmFAP+kVFhlmsyuIPhVjwVSrZjXugr9BZd0YVt2i5hi9+rqOjHT1LJpj
         hJSe8t97LiYwTyMSphKZvs+aykaelSyLlDGKbzUC97dB2zbEEhwe7/JbHoHjUHB3p/
         AfD8E/D/GyeXHf+MAbVtc5mk1C0aVgEaAXnBLeujbDaW/mesx599Fhon4SvUjfcCJp
         0qlhulJo/GChg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3C97D609EF;
        Thu,  2 Dec 2021 13:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipvlan: Remove redundant if statements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163845060924.30486.11638487002875722798.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 13:10:09 +0000
References: <20211202075359.34291-1-vulab@iscas.ac.cn>
In-Reply-To: <20211202075359.34291-1-vulab@iscas.ac.cn>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     davem@davemloft.net, zkuba@kernel.org, trix@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  2 Dec 2021 07:53:59 +0000 you wrote:
> The 'if (dev)' statement already move into dev_{put , hold}, so remove
> redundant if statements.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---
>  drivers/net/ipvlan/ipvlan_core.c | 3 +--
>  drivers/net/ipvlan/ipvlan_main.c | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)

Here is the summary with links:
  - ipvlan: Remove redundant if statements
    https://git.kernel.org/netdev/net-next/c/0c4789460e8c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


