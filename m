Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C21047E22C
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 12:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347896AbhLWLUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 06:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347863AbhLWLUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 06:20:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF26C061401
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 03:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A1823CE1FDC
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 11:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2750C36AED;
        Thu, 23 Dec 2021 11:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640258409;
        bh=RTVA7fvFcqexcAb1AqWVwO7L2rx0QN+l1jDNyXmNrac=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EcV1+I/TzizjrZXzRrmjG7lNlk+D2eTuBTU18vuiHeRLwkkfgr2pUmmnjRqk8Kq4h
         Wen08zc4wEbf1ho+w+lOxI+WCVVFCTeUy7nUF/6Zl2woHkU7ywj6Nk+vbBMOXk4NGk
         ZbVNtjB3U6yo8b/asJqbpc2fsazrXovEt0g3pHaKfYf4Jtw8hq9OvB8ns5v+9SpEs9
         z88/pEZZEwz00S61nzF0qwx39ffLLTWrpLQkb3dD2TmwF0pR8i3rQydS55SwUbBZkP
         L0O6oQhsDOVlkTItyX3TotPLsrCyJhB2ATMmb3MsANVCSKlFGPshPg0sJwjU2E0dDS
         OFiCX6t45ca0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE12EEAC066;
        Thu, 23 Dec 2021 11:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] flow_offload: fix suspicious RCU usage when
 offloading tc action
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164025840984.28761.7314510545220370003.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Dec 2021 11:20:09 +0000
References: <1640147146-4294-1-git-send-email-baowen.zheng@corigine.com>
In-Reply-To: <1640147146-4294-1-git-send-email-baowen.zheng@corigine.com>
To:     Baowen Zheng <baowen.zheng@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, netdev@vger.kernel.org,
        louis.peens@corigine.com, oss-drivers@corigine.com,
        eric.dumazet@gmail.com, simon.horman@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 22 Dec 2021 12:25:46 +0800 you wrote:
> Fix suspicious rcu_dereference_protected() usage when offloading tc action.
> 
> We should hold tcfa_lock to offload tc action in action initiation.
> 
> Without these changes, the following warning will be observed:
> 
> WARNING: suspicious RCU usage
> 5.16.0-rc5-net-next-01504-g7d1f236dcffa-dirty #50 Tainted: G          I
> 
> [...]

Here is the summary with links:
  - [net-next,v1] flow_offload: fix suspicious RCU usage when offloading tc action
    https://git.kernel.org/netdev/net-next/c/963178a06352

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


