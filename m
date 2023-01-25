Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABE367A8E3
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbjAYCkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbjAYCkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D973048A10;
        Tue, 24 Jan 2023 18:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9269AB81886;
        Wed, 25 Jan 2023 02:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46B02C4339C;
        Wed, 25 Jan 2023 02:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674614417;
        bh=/b+hIy8+06ZVWzl1/SHY7PWcR2poSRoejhYKy3qcH6U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G26fBekI15fDkk5goGaxwbrrPuf6Cj+5KpBCb085kZ6dg43vWKI+5jKp+A/sVKpX3
         X92M8+PJQpiamqDC6FSuVnGyvtDTXdia39VFfjtYTYnYl5CxdfXkPNwlRmxf2jD2sC
         uyPT6PWDKp1K+zVIXmFEWSyZZQM3JCCo7kZk10kaaur/YfvlxHidao9/3udFmI5ZlC
         JX+r8icDPU/MY25mR9JF6q0j09n93L4tTxCrb879cjUjNq7gJBfzC2t49fwt1i3cVn
         rl0jqjULIoEBv93G8DzKWRIW56Dt0jOl9iZ56ZndkmpMyk6K4aC+PFRfUyTMFC86aa
         //zSjkBXqmS4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2BCCEE21EE1;
        Wed, 25 Jan 2023 02:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: fail if no bound addresses can be used for a given
 scope
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167461441717.2895.2981409753488921522.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 02:40:17 +0000
References: <9fcd182f1099f86c6661f3717f63712ddd1c676c.1674496737.git.marcelo.leitner@gmail.com>
In-Reply-To: <9fcd182f1099f86c6661f3717f63712ddd1c676c.1674496737.git.marcelo.leitner@gmail.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        lucien.xin@gmail.com, borrello@diag.uniroma1.it
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 23 Jan 2023 14:59:33 -0300 you wrote:
> Currently, if you bind the socket to something like:
>         servaddr.sin6_family = AF_INET6;
>         servaddr.sin6_port = htons(0);
>         servaddr.sin6_scope_id = 0;
>         inet_pton(AF_INET6, "::1", &servaddr.sin6_addr);
> 
> And then request a connect to:
>         connaddr.sin6_family = AF_INET6;
>         connaddr.sin6_port = htons(20000);
>         connaddr.sin6_scope_id = if_nametoindex("lo");
>         inet_pton(AF_INET6, "fe88::1", &connaddr.sin6_addr);
> 
> [...]

Here is the summary with links:
  - [net] sctp: fail if no bound addresses can be used for a given scope
    https://git.kernel.org/netdev/net/c/458e279f861d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


