Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81795ED215
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiI1AkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbiI1AkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:40:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448C013CF9
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 17:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56842B81E6D
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 00:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EBBE2C433D6;
        Wed, 28 Sep 2022 00:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664325615;
        bh=zavheW2pEPYHKPBj4HHpGS4u+0SzhqqSdmRCko/2bkQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TYTQcgNM1y9LlFMOjONTfTQ0NRZoGX3vDciqgkLftLxLccY1JfKjfMPjo4H9EUxqy
         feC6xyZNBQWY0uNeJMiNy2kb5seMg1v2UPZ8p6+aPPthZnwT3hFel4KlitJ+Rckt2i
         1bSkp6iB+Q6l0kUebGCxvOWsH+zMgXCIKNdljjgLR1AdwBsNqxjAalWPsy4+b4rf08
         mVpugYiOh1dSWWCH1Bk13nrN9JZmEdzW2r9wct0tQrg/CmzEfaaYlE4GBbpRND2Ha3
         tGUfUZOqHbqSn56MEFGbCaKqnvDtbtR3LlutSryj9Dh7BbesvpOv9qcsCSM3xpN1nJ
         YHogdtSefZ8qg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CF2BFE21EC5;
        Wed, 28 Sep 2022 00:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next] net: tls: Add ARIA-GCM algorithm
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166432561484.23988.9598069912073206371.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 00:40:14 +0000
References: <20220925150033.24615-1-ap420073@gmail.com>
In-Reply-To: <20220925150033.24615-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        herbert@gondor.apana.org.au, borisp@nvidia.com,
        john.fastabend@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 25 Sep 2022 15:00:33 +0000 you wrote:
> RFC 6209 describes ARIA for TLS 1.2.
> ARIA-128-GCM and ARIA-256-GCM are defined in RFC 6209.
> 
> This patch would offer performance increment and an opportunity for
> hardware offload.
> 
> Benchmark results:
> iperf-ssl are used.
> CPU: intel i3-12100.
> 
> [...]

Here is the summary with links:
  - [v3,net-next] net: tls: Add ARIA-GCM algorithm
    https://git.kernel.org/netdev/net-next/c/62e56ef57c04

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


