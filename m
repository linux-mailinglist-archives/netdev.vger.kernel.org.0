Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9707166DC68
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbjAQLan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbjAQLa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:30:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF9C2DE57;
        Tue, 17 Jan 2023 03:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C22CCB815A2;
        Tue, 17 Jan 2023 11:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7455FC433F0;
        Tue, 17 Jan 2023 11:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673955017;
        bh=uanmQl0XnnvrdM4uz2qfuTOC8CnMz0HQVeFeBnzZoqo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mMO8keSE91RebTkdCrhFdEGaW6K0pOB1KBkM9iSVijwttzY6TMfVTKos2ud5+dVYQ
         GqbX56S766aM4/AYPPw6cYUivV4DKI+pslV9vAERAGlCsb1tutjlY7bNtcULDUv/6q
         0QA5AyfjF1cs8Yir/oCFHrS+/hC/w/6sxGE2fKoOllibS7UH2A8i5jshxAZrmbpAQ0
         1xKvwMCx7qxBDzPi8cfyyFvF+q1DV16Vr948HW4ICBpgbXGvqaN43J2oZP2uEhCxpj
         fU8lT1SnDpzzEkCQX+9H1IEcflabpvy1aFswvQidC6fqzLA9m+SEeWIq5q84hTsIFt
         m3rqA/HAZBV4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56D5DC41670;
        Tue, 17 Jan 2023 11:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] inet: fix fast path in __inet_hash_connect()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167395501735.22351.17426243090589547369.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Jan 2023 11:30:17 +0000
References: <20230112-inet_hash_connect_bind_head-v3-1-b591fd212b93@diag.uniroma1.it>
In-Reply-To: <20230112-inet_hash_connect_bind_head-v3-1-b591fd212b93@diag.uniroma1.it>
To:     Pietro Borrello <borrello@diag.uniroma1.it>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        c.giuffrida@vu.nl, h.j.bos@vu.nl, jkl820.git@gmail.com,
        kuniyu@amazon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 14 Jan 2023 13:11:41 +0000 you wrote:
> __inet_hash_connect() has a fast path taken if sk_head(&tb->owners) is
> equal to the sk parameter.
> sk_head() returns the hlist_entry() with respect to the sk_node field.
> However entries in the tb->owners list are inserted with respect to the
> sk_bind_node field with sk_add_bind_node().
> Thus the check would never pass and the fast path never execute.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] inet: fix fast path in __inet_hash_connect()
    https://git.kernel.org/netdev/net-next/c/21cbd90a6fab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


