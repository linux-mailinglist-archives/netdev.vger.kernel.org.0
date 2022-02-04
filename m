Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4620A4A9DD0
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242179AbiBDRkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238161AbiBDRkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 12:40:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0DFC061714;
        Fri,  4 Feb 2022 09:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FF2B61A70;
        Fri,  4 Feb 2022 17:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFEFDC340E9;
        Fri,  4 Feb 2022 17:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643996410;
        bh=oXawZ25MZcEZAL/TWDkiL/TphGUpSxtnn7SJsWpBzPk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RFDyHEHcfg7BjUxKqiUgMC7hA1jXNyVX9SpllCfzFDlwyoDQR/dNgpDXy0wn6ZVxO
         k/n5iPuEM1XGFrFgUBZs080sG8NjDbwwXrZkJ975dsp1XUKuOcp/z84n/eUkoW4fpV
         7Wpc4Gdqk8gaL6Q9yzwmlxVwsMOLrxYevqykCNG68YNuX1j5hTAU7hLY8zdGYsGRhz
         AuR+OKSIXGkbC7iJ/ZHkeoyBf4gCfdG5/8URi39W2xwW+UQm/LctnqK18gH5VtdHSm
         FnbViQdZfXHn1D4tb6kxY00zd4jnc0gDjF49AVkp1+qZdR2y5qX1CKwvxD34QVlkIT
         h6i2HYd2FxnOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D8876E5D08C;
        Fri,  4 Feb 2022 17:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] netfilter: conntrack: don't refresh sctp entries in
 closed state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164399640988.7846.15795496871419366949.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Feb 2022 17:40:09 +0000
References: <20220204151903.320786-2-pablo@netfilter.org>
In-Reply-To: <20220204151903.320786-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri,  4 Feb 2022 16:18:57 +0100 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> Vivek Thrivikraman reported:
>  An SCTP server application which is accessed continuously by client
>  application.
>  When the session disconnects the client retries to establish a connection.
>  After restart of SCTP server application the session is not established
>  because of stale conntrack entry with connection state CLOSED as below.
> 
> [...]

Here is the summary with links:
  - [net,1/6] netfilter: conntrack: don't refresh sctp entries in closed state
    https://git.kernel.org/netdev/net/c/77b337196a9d
  - [net,2/6] netfilter: nft_payload: don't allow th access for fragments
    https://git.kernel.org/netdev/net/c/a9e8503def0f
  - [net,3/6] netfilter: conntrack: move synack init code to helper
    https://git.kernel.org/netdev/net/c/cc4f9d62037e
  - [net,4/6] netfilter: conntrack: re-init state for retransmitted syn-ack
    https://git.kernel.org/netdev/net/c/82b72cb94666
  - [net,5/6] MAINTAINERS: netfilter: update git links
    https://git.kernel.org/netdev/net/c/1f6339e034d5
  - [net,6/6] netfilter: ctnetlink: disable helper autoassign
    https://git.kernel.org/netdev/net/c/d1ca60efc53d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


