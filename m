Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5634481C87
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 14:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239713AbhL3Nad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 08:30:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52874 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239526AbhL3NaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 08:30:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B80FDB81C5A;
        Thu, 30 Dec 2021 13:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18BA1C36AF6;
        Thu, 30 Dec 2021 13:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640871013;
        bh=Rmth3Hrs2ci4lTAo36mfw3IRjEvrhVOhxxesCt3UxE0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qJvEOr46jvVyaxlzWcKsJhI9Kr4/tgnzXd0500YqW6uvmHTwrsTK7wK3CdgxXMAM4
         UqqFn0/bkBpdqeT+q2YRCJxRq4Uf7S30OiMX6AI6OFFzt0aXKUym1Ws6HINXQ8q/pR
         MhEnPrgMh5spcWcz6ifrWvZwfAa0mxvxe47olDCHQiPI9gNYy6q19yYC3BbTYXKDED
         jGL6tt9JnFcHnW9Z9zN3RgYfiwTMc8R6HtR6K8NpBaRK9QipSJzIHdA5959EhNXbpC
         wsvv9AVQ6iNuAufpalOTjkPo+qAYq1kdkZbLqoMqClLgqGDuL6aclsxgUX9D5tGM7a
         EqOcqFzWtb+fQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 00BE3C395E3;
        Thu, 30 Dec 2021 13:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: lantiq_etop:  remove unnecessary space in
 cast
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164087101299.9335.1760853936109794382.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 13:30:12 +0000
References: <20211229235206.6045-1-olek2@wp.pl>
In-Reply-To: <20211229235206.6045-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     davem@davemloft.net, kuba@kernel.org, jgg@ziepe.ca,
        rdunlap@infradead.org, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Dec 2021 00:52:06 +0100 you wrote:
> As reported by checkpatch.pl, no space is necessary after a cast.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  drivers/net/ethernet/lantiq_etop.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next,v2] net: lantiq_etop: remove unnecessary space in cast
    https://git.kernel.org/netdev/net-next/c/dda0c2e7ed21

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


