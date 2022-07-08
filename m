Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B7A56B98D
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 14:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238193AbiGHMUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 08:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiGHMUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 08:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7641573F;
        Fri,  8 Jul 2022 05:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A83862622;
        Fri,  8 Jul 2022 12:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC681C341CB;
        Fri,  8 Jul 2022 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657282812;
        bh=7igHYBUjf8cAeNutb+ZLuMrzg2cfDeFZvdEsxuu3ayo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lHI0tCqzR3E9BqdyoJAIo+scgb7kZ9FzPcISHuYMf4XjRLGIMuSczNLvJfawarQp6
         EPolMQTZkE4g+PQlgbRY1pIb3xLQHpTPWmUfUoxB0nF62iTvhEltCgP4VNzZUu4Lv0
         jHB1UvaU5ZMU2I5WoJnfzBsnOU8zMvE1ORx6stZ/aQL1WdBCx0lQhSyBVU2M3M0TkG
         g6BtJcPMb+/Z1mFiABTtBA6a9r2CkkqeQT8YjHupm1EumancyMXarwlzFCyXfdDka4
         oMusmJ2kFgRxID8LUYovUBexlXyh7dzDQgIp+Ye0axpFuX4M7x8/ntrHsIRrHMs0gz
         t0iU+WxgM1TgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B33F3E45BDB;
        Fri,  8 Jul 2022 12:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf,
 docs: Remove deprecated xsk libbpf APIs description
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165728281272.4798.1631027915077654489.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 12:20:12 +0000
References: <20220708042736.669132-1-pulehui@huawei.com>
In-Reply-To: <20220708042736.669132-1-pulehui@huawei.com>
To:     Pu Lehui <pulehui@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        corbet@lwn.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        grantseltzer@gmail.com, rdunlap@infradead.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 8 Jul 2022 12:27:36 +0800 you wrote:
> Since xsk APIs has been removed from libbpf, let's clean
> up the bpf docs simutaneously.
> 
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> ---
>  .../bpf/libbpf/libbpf_naming_convention.rst         | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)

Here is the summary with links:
  - [bpf-next] bpf, docs: Remove deprecated xsk libbpf APIs description
    https://git.kernel.org/bpf/bpf-next/c/fb8ddf24c71d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


