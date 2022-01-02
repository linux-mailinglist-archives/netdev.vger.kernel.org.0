Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9434E482B0B
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 13:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiABMUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 07:20:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58630 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbiABMUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 07:20:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BA5260E8D;
        Sun,  2 Jan 2022 12:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF75DC36AF3;
        Sun,  2 Jan 2022 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641126011;
        bh=42FSGjo7bJM1OjCIYk/N8hVFrdzTHFcqqtbCqSNyMKQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ABIXLREgYWx51dQFBEgiJrFLoZhJSfsd7pNeiGb3QYuRNsmCIfDxg5jP6A1UR8S+C
         lBMHIFD3hK6zmQhVr8EBVtRXsvzPaPzqBsi2lIhkD7A0M7mDUZn0Jq/rDibPxGm6Qi
         Mo8PN1shPHTzRGSdla00H0R1f8KoY07cH8T3RotgeMd+nwXOtEdT/0xFFgM0jUraBr
         /mSuGMDz5bd1tSoCu6P8cbIOLfTsYmplig0hm7UAqp0kIiAmR2o7tiNzkxXX17U+Ev
         BNy9axaR/rpI4tXW8761WmFmpvhJf1il+keh/8fIVpoIfDhyOfDzmkD4NNdzQYth8Q
         5AVxsCfwpNF9w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DBA8CC395EC;
        Sun,  2 Jan 2022 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/smc: Introduce TCP ULP support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164112601089.23508.11527183235467128811.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 12:20:10 +0000
References: <20211228134435.41774-1-tonylu@linux.alibaba.com>
In-Reply-To: <20211228134435.41774-1-tonylu@linux.alibaba.com>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 28 Dec 2021 21:44:36 +0800 you wrote:
> This implements TCP ULP for SMC, helps applications to replace TCP with
> SMC protocol in place. And we use it to implement transparent
> replacement.
> 
> This replaces original TCP sockets with SMC, reuse TCP as clcsock when
> calling setsockopt with TCP_ULP option, and without any overhead.
> 
> [...]

Here is the summary with links:
  - [net-next] net/smc: Introduce TCP ULP support
    https://git.kernel.org/netdev/net-next/c/d7cd421da9da

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


