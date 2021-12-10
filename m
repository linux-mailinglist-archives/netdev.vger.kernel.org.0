Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E0546F98C
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 04:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbhLJDXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 22:23:47 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:60376 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbhLJDXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 22:23:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71D60CE29D7;
        Fri, 10 Dec 2021 03:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6BAB4C341D0;
        Fri, 10 Dec 2021 03:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639106409;
        bh=uBG2Sn7JzS43WffLO6b1Tg2/7OY8U5FlKnHBjN0YOBM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ESQpxcwCEK0l04NBxk8OedN7fkrkcyFOFS9s03nKseUiV6R0KqXQSPsIEr0wlftmX
         nZ8xt8FtEFPF53i4ajvR59nHj0WYac2/hZzDCnB6bTiA1AFfRuAhhKkXc+SHEOb1Cn
         JwbPhfPIPgDbkV8TQ2CJFICDzzjWXmKo7dgfDVjn1FTmDUXch0qqiJv3gf+grrbzg0
         aooTVwD+0pqFcVPyaKHRclFZdAwAqc3maqg1HyC8lFhU/NiPTkK4RN9XHofgw7NWL5
         R4AWt3cLGWGK6hcXSWZQGrYfrSoWChtFQgiIVQ3E+vQZZsdHN0B7E4gvQSr/VzeM06
         998RNb58v/esg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 542E460A54;
        Fri, 10 Dec 2021 03:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: x25: drop harmless check of !more
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163910640934.13476.8421043107129227133.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Dec 2021 03:20:09 +0000
References: <20211208024732.142541-5-sakiwit@gmail.com>
In-Reply-To: <20211208024732.142541-5-sakiwit@gmail.com>
To:     =?utf-8?q?J=CE=B5an_Sacren_=3Csakiwit=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     ms@dev.tdt.de, davem@davemloft.net, kuba@kernel.org,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Dec 2021 00:20:25 -0700 you wrote:
> From: Jean Sacren <sakiwit@gmail.com>
> 
> 'more' is checked first.  When !more is checked immediately after that,
> it is always true.  We should drop this check.
> 
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: x25: drop harmless check of !more
    https://git.kernel.org/netdev/net-next/c/9745177c9489

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


