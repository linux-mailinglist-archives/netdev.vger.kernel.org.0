Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7B64D315D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 16:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbiCIPBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 10:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiCIPBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 10:01:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D25014FFFE
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 07:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0F9C60FA6
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 15:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0484CC340EF;
        Wed,  9 Mar 2022 15:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646838014;
        bh=QKtlkrXU/8m3OiW6lssiMf8zOHKo0YMJHdLU7r3/GOg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EMxfTXEJxa7RJaySsmp3JDRsv4jIxVv7tk5flmRy18ftlEbopn/+zjy6QB8WcNnWi
         pWyA52/WOKLiSySX6hgNg7RNd5gRxPPu/tMkrb1b4w/7wZyRKmEEx5cvLetRbPQt8r
         F/SC/rlcIUEegif7G8GxGdTLa1Mmrr6k1a/8yV4ZZs1NWtq9u3cJVQhD9CdXq8kr5t
         skeFOOiAVKusnI4I89l49EZlTBv+d0Ud8BqYKd6/QVo3p8W++ckCFApfaO347tvRVs
         JEJ9n933XVP8LenBw+B3EISytdEa6RyDSCFkQz/tDGMfk8h579iQtd54ucqY4PzP8t
         Z+t0HMZ7X5uRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB188EAC095;
        Wed,  9 Mar 2022 15:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request (net): ipsec 2022-03-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164683801389.7970.17437403056051813722.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 15:00:13 +0000
References: <20220309130839.3263912-1-steffen.klassert@secunet.com>
In-Reply-To: <20220309130839.3263912-1-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Wed, 9 Mar 2022 14:08:34 +0100 you wrote:
> 1) Fix IPv6 PMTU discovery for xfrm interfaces.
>    From Lina Wang.
> 
> 2) Revert failing for policies and states that are
>    configured with XFRMA_IF_ID 0. It broke a
>    user configuration. From Kai Lueke.
> 
> [...]

Here is the summary with links:
  - pull request (net): ipsec 2022-03-09
    https://git.kernel.org/netdev/net/c/cc7e2f596e64
  - [2/5] Revert "xfrm: state and policy should fail if XFRMA_IF_ID 0"
    https://git.kernel.org/netdev/net/c/a3d9001b4e28
  - [3/5] esp: Fix possible buffer overflow in ESP transformation
    https://git.kernel.org/netdev/net/c/ebe48d368e97
  - [4/5] esp: Fix BEET mode inter address family tunneling on GSO
    https://git.kernel.org/netdev/net/c/053c8fdf2c93
  - [5/5] net: Fix esp GSO on inter address family tunnels.
    https://git.kernel.org/netdev/net/c/23c7f8d7989e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


