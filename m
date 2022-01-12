Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F7E48BDE2
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 05:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350698AbiALEaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 23:30:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45520 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiALEaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 23:30:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5350B61842
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 04:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9AC6C36AEA;
        Wed, 12 Jan 2022 04:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641961810;
        bh=yOH4m9Adno7XB7APPGLVYTuEuI+XYzXiKKEf6t66Vig=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=egSb08ly7jZUWzMlb0aTvXypdkSyZGT0O7FJOq/aO9hmv8k/2dycYDM412wPtZWMJ
         bX3VltsjfPjvaVO6Lfp+7nujh0aX1F0S+4zZ1XWhu6WFzwrf+TrgT+N9vcqPNuimWG
         ZDwAu3cqJ4tjrTFRIOPBN+8bb5Snm/sqBJEQJ3+q2f69Vvs/nKWq66Rd4XYuRYz7jA
         wNJ36x1K6TPHEOlEtPj8jTsgnmrU8Q33FsJGM0cJ7nX0fg1y0rZ3tDFoNi1aVyWoZP
         u1caEMVEAOXDiFOJtIRInee7vNfXy3rpVUevxr1BEUcbMUsROw0q8V/G/A+SPzicmQ
         7JAdXMwh9rDUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 829DFF60793;
        Wed, 12 Jan 2022 04:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mctp: test: zero out sockaddr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164196181053.12222.2965918438416421151.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Jan 2022 04:30:10 +0000
References: <20220110021806.2343023-1-matt@codeconstruct.com.au>
In-Reply-To: <20220110021806.2343023-1-matt@codeconstruct.com.au>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     kuba@kernel.org, davem@davemloft.net, jk@codeconstruct.com.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 10 Jan 2022 10:18:06 +0800 you wrote:
> MCTP now requires that padding bytes are zero.
> 
> Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
> Fixes: 1e4b50f06d97 ("mctp: handle the struct sockaddr_mctp padding fields")
> ---
>  net/mctp/test/route-test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] mctp: test: zero out sockaddr
    https://git.kernel.org/netdev/net/c/284a4d94e8e7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


