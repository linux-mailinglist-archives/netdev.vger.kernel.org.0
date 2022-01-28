Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2452F49FC79
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349509AbiA1PKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349498AbiA1PKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41CAC061747;
        Fri, 28 Jan 2022 07:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9662CB82617;
        Fri, 28 Jan 2022 15:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52E85C340EA;
        Fri, 28 Jan 2022 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643382617;
        bh=P7jhgsDVzLo3bAxyICm5NwEgWC5an3mQxnsCQRTuqMk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d70XSm4hHNisdQbrfmHeAQ9nSWW0x3/WFHzjStsQLo5vlLyTs8OiAxt1CqACwsg6N
         r5bMG+vJG6+lc7vINbZ67ejZLPJ0hv914qmsuuKwtvf82LauU91tykYkhQiIRLJnO+
         iLE11P3jmw4CxGRfEqWVL4WtRbN2+uSmzsa3i9ELXlnSxr7DRTnTSWJgAf8GNVaRZx
         vdCXxJwRhyOtxpGsqMVjCx9dt8awsNiJUfb7ghzsvxNBi3ijaHpCt77wXlYMsAi0yr
         r4XDfJVnZH36gL/k/iwMu76fRUspHPhRggS/MKQSluDhg29AoR5WdssY+JUJQn8Io8
         D0MTmLcEFRvIw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3430AE5D089;
        Fri, 28 Jan 2022 15:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] SUNRPC: add some netns refcount trackers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164338261720.2420.9086184599946096191.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 15:10:17 +0000
References: <20220127200937.2157402-1-eric.dumazet@gmail.com>
In-Reply-To: <20220127200937.2157402-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, chuck.lever@oracle.com,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 27 Jan 2022 12:09:34 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Effort started in linux-5.17
> 
> Our goal is to replace get_net()/put_net() pairs with
> get_net_track()/put_net_track() to get instant notifications
> of imbalance bugs in the future.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] SUNRPC: add netns refcount tracker to struct svc_xprt
    https://git.kernel.org/netdev/net-next/c/6cdef8a6ee74
  - [net-next,2/3] SUNRPC: add netns refcount tracker to struct gss_auth
    https://git.kernel.org/netdev/net-next/c/9b1831e56c7f
  - [net-next,3/3] SUNRPC: add netns refcount tracker to struct rpc_xprt
    https://git.kernel.org/netdev/net-next/c/b9a0d6d143ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


