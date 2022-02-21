Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA554BE601
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357105AbiBUMBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 07:01:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357070AbiBUMAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 07:00:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A171EEEF
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 04:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 704D1B80E6F
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 12:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 220E2C340F0;
        Mon, 21 Feb 2022 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645444811;
        bh=QjJ6sySPp9mG1FBS4Kc6pxSCxCrRT33uugiK3P/wCCM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fPr/iaAFbgQ1w80TLA7FC2QBgKMTw4TgSydzcVcgCAtwChzZmyDPy3tzapaNZXFIQ
         GSxxEqLmsrOZLSiwp3rDKKoj8cNClGa+ODEa4Sbd8E+rW5wyPKyJEFxNu+HX0WvgRh
         x1N5/V2UuZXEq5dA7nXjdZzKXINAWjFTgtYdHwNFsi2PftwwvwtOPqAOrgNnnLV1G9
         eGIzwlpoOo/tcTYgBgncNNWRKrSYQvZkV+9s84ABCwn8exyvGI0TYYkC434dIxsh+5
         WQ0+zN3FggueRHcMsMz2zQgMze2FWUMMKVBi0TAsKlVWrk8V4JOtl0hggJZHTPHTJu
         0XJMzbN6vU2KA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09ECEE6D45A;
        Mon, 21 Feb 2022 12:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] ipv4: Invalidate neighbour for broadcast address
 upon address addition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164544481103.22815.644270005273182545.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Feb 2022 12:00:11 +0000
References: <20220219154520.344057-1-idosch@nvidia.com>
In-Reply-To: <20220219154520.344057-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, wanghai38@huawei.com, mlxsw@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 19 Feb 2022 17:45:18 +0200 you wrote:
> Patch #1 solves a recently reported issue [1]. See detailed description
> in the changelog.
> 
> Patch #2 adds a matching test case.
> 
> Targeting at net-next since as far as I can tell this use case never
> worked.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] ipv4: Invalidate neighbour for broadcast address upon address addition
    https://git.kernel.org/netdev/net-next/c/0c51e12e218f
  - [net-next,2/2] selftests: fib_test: Add a test case for IPv4 broadcast neighbours
    https://git.kernel.org/netdev/net-next/c/25bd462fa42f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


