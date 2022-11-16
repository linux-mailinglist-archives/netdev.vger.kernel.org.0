Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875D762BE9F
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 13:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiKPMuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 07:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiKPMuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 07:50:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83B41083
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 04:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80739B81D45
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1A015C433C1;
        Wed, 16 Nov 2022 12:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668603020;
        bh=Yx9/zqZ8n6VzpXFpZGNvf+Riact1bAL2VLxx9gkNA4o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pj9LkC/LOS124BCaZb/i+/Be9newM0dynd+AdIM4BfJYBrlsVqSJ08RPZhlAUXD5E
         O6eDbLbexrsB2J8r3+S7V/SzzfgPeJtD7FCKooGqlKV37KTPfCUCV/ZoGDAsIg1Hy6
         57oKmLB56tQxELF+DMVDih3OKlgi2rtYXaI2Wc77qaIQ28UjlYKDUoPgPDk6FBUc4T
         DGpxdS72ap7ONyMD/E+m4w8ALlmEtUwk9ivb4ACJ1reLDU4KjS5f7co5eHIHYnIksT
         f3gzikdffz4T4cR6hkktf6VF+Rgb/FTxgYHSfysu5VExrAcEvObcxB2YkeCe2PGoy4
         w3OTe385QxmDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 00E8BC395F0;
        Wed, 16 Nov 2022 12:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: more try_cmpxchg() conversions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166860301999.3073.2793769493705785244.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 12:50:19 +0000
References: <20221115091101.2234482-1-edumazet@google.com>
In-Reply-To: <20221115091101.2234482-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 15 Nov 2022 09:10:55 +0000 you wrote:
> Adopt try_cmpxchg() and friends in more places, as this
> is preferred nowadays.
> 
> Eric Dumazet (6):
>   net: mm_account_pinned_pages() optimization
>   ipv6: fib6_new_sernum() optimization
>   net: net_{enable|disable}_timestamp() optimizations
>   net: adopt try_cmpxchg() in napi_schedule_prep() and
>     napi_complete_done()
>   net: adopt try_cmpxchg() in napi_{enable|disable}()
>   net: __sock_gen_cookie() cleanup
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: mm_account_pinned_pages() optimization
    https://git.kernel.org/netdev/net-next/c/57fc05e8e82d
  - [net-next,2/6] ipv6: fib6_new_sernum() optimization
    https://git.kernel.org/netdev/net-next/c/30189806fbb9
  - [net-next,3/6] net: net_{enable|disable}_timestamp() optimizations
    https://git.kernel.org/netdev/net-next/c/6af645a5b2da
  - [net-next,4/6] net: adopt try_cmpxchg() in napi_schedule_prep() and napi_complete_done()
    https://git.kernel.org/netdev/net-next/c/1462160c7455
  - [net-next,5/6] net: adopt try_cmpxchg() in napi_{enable|disable}()
    https://git.kernel.org/netdev/net-next/c/4ffa1d1c6842
  - [net-next,6/6] net: __sock_gen_cookie() cleanup
    https://git.kernel.org/netdev/net-next/c/4ebf802cf1c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


