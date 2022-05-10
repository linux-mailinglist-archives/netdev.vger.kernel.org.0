Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C76520A4C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbiEJAoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiEJAoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:44:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2D21DEC5E
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 17:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11C5EB81A01
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 00:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4945C385C2;
        Tue, 10 May 2022 00:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652143211;
        bh=v5EsiA2POF3OeED2pSCGWvqm3dyl6CXI7D6FFxkdlcI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eIHcdG0CqjJp0ONqafYnr1vuo9nt1beMt3FMomi6HRFIWO4BJtMHmf2oPOebwU7iq
         aYZnju+A9EZhQWOoY9HaLwvdUbGzrl0Ux2L9+aW/XT8izRi+UiPoiJzPmLEevYCgv9
         Zl0v8qSPvuww2Oyy44y90pNIs4HpqBl8IC8+/8LJl8m89LLqQGjB4cvt8p49joYoli
         hXMU4uSJ5I1AljSKIvLIhnCCW0p8RukMlsweZQn6Hg6j6RtvA3qg3a5GMr78iLRYbO
         TjktUUX3rCxl9/qWL6TbUTxUdz+Fa+/93NndBqQin4kPM1o+d199F9qnOLZ6I0TIiW
         ZadPbEA6vhYMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8502AF03876;
        Tue, 10 May 2022 00:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] dim: initialize all struct fields
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165214321153.28308.10729742871458519653.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 00:40:11 +0000
References: <20220507011038.14568-1-jesse.brandeburg@intel.com>
In-Reply-To: <20220507011038.14568-1-jesse.brandeburg@intel.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        alexander.lobakin@intel.com, talgi@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  6 May 2022 18:10:38 -0700 you wrote:
> The W=2 build pointed out that the code wasn't initializing all the
> variables in the dim_cq_moder declarations with the struct initializers.
> The net change here is zero since these structs were already static
> const globals and were initialized with zeros by the compiler, but
> removing compiler warnings has value in and of itself.
> 
> lib/dim/net_dim.c: At top level:
> lib/dim/net_dim.c:54:9: warning: missing initializer for field ‘comps’ of ‘const struct dim_cq_moder’ [-Wmissing-field-initializers]
>    54 |         NET_DIM_RX_EQE_PROFILES,
>       |         ^~~~~~~~~~~~~~~~~~~~~~~
> In file included from lib/dim/net_dim.c:6:
> ./include/linux/dim.h:45:13: note: ‘comps’ declared here
>    45 |         u16 comps;
>       |             ^~~~~
> 
> [...]

Here is the summary with links:
  - [net,v2] dim: initialize all struct fields
    https://git.kernel.org/netdev/net/c/ee1444b5e1df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


