Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347E355CA86
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244837AbiF1FkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 01:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiF1FkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 01:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C95513F05
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 22:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7276B81CA0
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 05:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 603AEC341C6;
        Tue, 28 Jun 2022 05:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656394813;
        bh=JVEBfAkUUsssanf50hzV6mN4yCdaBMQeDhYZXNMVLbM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UX59W0PXKUWQeRG8c4PQnyBwdKkFn5e3U5J9tnhTboUbvfwisP7Fqwzi5mB8rM04+
         f2tZFo7bhqw21nNwxTSALQLZ/xR1qrrwWH46duMO66oJjpr8G2Y8o4maq+nAi/RmHQ
         cCY+u1Nyne+QRaAQV3GdxmY46YNV6dz28ExbxvkycXUzcR29ZmfqQsCKdxF8pvqdyB
         IIsSzPUOoBhoq0k2p99r+VfqgsmqQOMD6BxaRHI78hLjqJqrR8PchMnloi/VW9CsY5
         7QymcCzeJnfYaNB59SCLvo1/BUa/nEQD/34XQJXJ4awBiJKANjbam+QsWAjEtXodO8
         T8WDLNmJi1Oxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42205E49FA1;
        Tue, 28 Jun 2022 05:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: take care of disable_policy when restoring routes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165639481325.10558.17743723876862500477.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Jun 2022 05:40:13 +0000
References: <20220623120015.32640-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20220623120015.32640-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, klassert@kernel.org,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        netdev@vger.kernel.org, stable@kernel.org, dforster@brocade.com,
        siwar.zitouni@6wind.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Jun 2022 14:00:15 +0200 you wrote:
> When routes corresponding to addresses are restored by
> fixup_permanent_addr(), the dst_nopolicy parameter was not set.
> The typical use case is a user that configures an address on a down
> interface and then put this interface up.
> 
> Let's take care of this flag in addrconf_f6i_alloc(), so that every callers
> benefit ont it.
> 
> [...]

Here is the summary with links:
  - [net] ipv6: take care of disable_policy when restoring routes
    https://git.kernel.org/netdev/net/c/3b0dc529f56b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


