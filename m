Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446BB4857D3
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242650AbiAESAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:00:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43282 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242630AbiAESAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:00:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C25FCB81CE7
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 18:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B9F5C36AE0;
        Wed,  5 Jan 2022 18:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641405640;
        bh=9CJnkRRp3ZZi0ERNmWdcfG1OplLdRuMSPYN3wdK+TZM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dGsNxiRO9qoVUUvMRxYX6olLaeVPWD/EhEQGb7CtdL3wRBvNfes0hrm/GCeBmgvb8
         zgcOAhlr/3vBUD0zUqK22yvYx42F955U+Tb7wpf8KqxaVuDh94WCId8lp5ie9Uqw7S
         ou0Z8CyG92cOXPZPGOIYStSL5dc23HzOsQTWsiv37UhgnmBJCMjEtsOyO55Z3aM6D3
         TB1cb/PI8MjHjS/bmOhIsuxMYqL9eWCDRh1tjP9vrLbVTj/eJAr4tt0w8LuE00wgyx
         5rsbNnuUfrHhppSJdkCAwtTKKUvxSziFkPocZ7lnvl0V+L5/6bl/pmmgmTi/9P+7sI
         TFvrB8bsuliZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68249F79404;
        Wed,  5 Jan 2022 18:00:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netlink: do not allocate a device refcount tracker
 in ethnl_default_notify()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164140564041.4565.11127069947473181368.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 18:00:40 +0000
References: <20220105170849.2610470-1-eric.dumazet@gmail.com>
In-Reply-To: <20220105170849.2610470-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, johannes@sipsolutions.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  5 Jan 2022 09:08:49 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> As reported by Johannes, the tracker allocated in
> ethnl_default_notify() is not really needed, as this
> function is not expected to change a device reference count.
> 
> Fixes: e4b8954074f6 ("netlink: add net device refcount tracker to struct ethnl_req_info")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Tested-by: Johannes Berg <johannes@sipsolutions.net>
> 
> [...]

Here is the summary with links:
  - [net-next] netlink: do not allocate a device refcount tracker in ethnl_default_notify()
    https://git.kernel.org/netdev/net-next/c/2d6ec25539b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


