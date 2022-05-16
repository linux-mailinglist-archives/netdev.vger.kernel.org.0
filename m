Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6685280F0
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 11:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237942AbiEPJkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 05:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiEPJkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 05:40:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1262FE7A
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 02:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B84F7B81031
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 09:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55F1EC34100;
        Mon, 16 May 2022 09:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652694018;
        bh=d76AP1NTa6KJ6SEKdPD7enIqDn3waSC1+t9D1Oj8hWQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t2Jc0IRVzPuTOtg957f5U6DjxxmnxxzEdwKyXUG1HzWtXgwoFb4c+jk6RsGrrZ6gO
         am02RVTgag2EwP6jI/iRaE5A20FzjyVzteZqwqfK81u21qd+Zo6Z+q/aV0neOODAl+
         QTui2WAliEI0dwGUZiqKMNsy27nGC8DnN2UBU9YSVsVbrnHT4nhVwyCp0JhE/7dOKm
         wQ70cFCFzRH5NJkqA2KqA7Kp0S/RyV2xu6Ktgru/AmYjIKF68hCVe3nEOK/ZbMtsUC
         hc39+tFzDD8XFxLcYfFizMKxvslyy3eYj27RVRBksGPXbzFgRUlqbGaExxs+HSeNza
         xl67jxgeg/oKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2EAFAE8DBDA;
        Mon, 16 May 2022 09:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 00/10]
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165269401818.10450.10175337460901334408.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 09:40:18 +0000
References: <20220513185550.844558-1-eric.dumazet@gmail.com>
In-Reply-To: <20220513185550.844558-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 13 May 2022 11:55:40 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> net: add annotations for sk->sk_bound_dev_if
> 
> While writes on sk->sk_bound_dev_if are protected by socket lock,
> we have many lockless reads all over the places.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,01/10] net: annotate races around sk->sk_bound_dev_if
    https://git.kernel.org/netdev/net-next/c/4c971d2f3548
  - [v2,net-next,02/10] sctp: read sk->sk_bound_dev_if once in sctp_rcv()
    https://git.kernel.org/netdev/net-next/c/a20ea298071f
  - [v2,net-next,03/10] tcp: sk->sk_bound_dev_if once in inet_request_bound_dev_if()
    https://git.kernel.org/netdev/net-next/c/fdb5fd7f736e
  - [v2,net-next,04/10] net: core: add READ_ONCE/WRITE_ONCE annotations for sk->sk_bound_dev_if
    https://git.kernel.org/netdev/net-next/c/e5fccaa1eb7f
  - [v2,net-next,05/10] dccp: use READ_ONCE() to read sk->sk_bound_dev_if
    https://git.kernel.org/netdev/net-next/c/36f7cec4f3af
  - [v2,net-next,06/10] inet: add READ_ONCE(sk->sk_bound_dev_if) in inet_csk_bind_conflict()
    https://git.kernel.org/netdev/net-next/c/d2c135619cb8
  - [v2,net-next,07/10] net_sched: em_meta: add READ_ONCE() in var_sk_bound_if()
    https://git.kernel.org/netdev/net-next/c/70f87de9fa0d
  - [v2,net-next,08/10] l2tp: use add READ_ONCE() to fetch sk->sk_bound_dev_if
    https://git.kernel.org/netdev/net-next/c/ff0094030f14
  - [v2,net-next,09/10] ipv6: add READ_ONCE(sk->sk_bound_dev_if) in INET6_MATCH()
    (no matching commit)
  - [v2,net-next,10/10] inet: rename INET_MATCH()
    https://git.kernel.org/netdev/net-next/c/eda090c31fe9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


