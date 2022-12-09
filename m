Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F5B647CD7
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 05:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiLIEKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 23:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiLIEKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 23:10:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19454E037
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 20:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99A376215D
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 04:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3037C433F1;
        Fri,  9 Dec 2022 04:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670559017;
        bh=yhBuhX1jg/56Xu+MSUYitgiHFjC7OCy7+tkNsUHN7qw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t4cHsF+JUXWtYpZQag85a7mm5EC4dV/WW6KmxHyRpGfloEWwPtdBCobfZjdCRXTwP
         gn62Rkp9tH4LS9xKVw6M2oWpz/wAXnETNckI1hmZzIzd75gI6kz3V3xpRaJkdThLZ6
         RNZHk0kOvIu8ortK7Fq4JpUVXbm8Sl8SoQAcDQkMotng+YsqePaMZ1kMg0E4IJuwoz
         4U/CCQ6bq1KYv+w2FB+2Mmslv3yH+Ao4U8lfU/Dw7zUhxwbh2P1iHFaQnkFw0dlwEF
         8ZH+0lj61Wyrw07v7AMLa34tXE0DU4YVLr5kl70SxdgI1p5N7d1flTY8Gzbw6zScAC
         Sh5kXgDiPYIWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CED72C00442;
        Fri,  9 Dec 2022 04:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net_tstamp: add SOF_TIMESTAMPING_OPT_ID_TCP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167055901683.13279.3992701252219142991.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Dec 2022 04:10:16 +0000
References: <20221207143701.29861-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20221207143701.29861-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, soheil@google.com,
        sotodel@meta.com, willemb@google.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 Dec 2022 09:37:01 -0500 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Add an option to initialize SOF_TIMESTAMPING_OPT_ID for TCP from
> write_seq sockets instead of snd_una.
> 
> This should have been the behavior from the start. Because processes
> may now exist that rely on the established behavior, do not change
> behavior of the existing option, but add the right behavior with a new
> flag. It is encouraged to always set SOF_TIMESTAMPING_OPT_ID_TCP on
> stream sockets along with the existing SOF_TIMESTAMPING_OPT_ID.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net_tstamp: add SOF_TIMESTAMPING_OPT_ID_TCP
    https://git.kernel.org/netdev/net-next/c/b534dc46c8ae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


