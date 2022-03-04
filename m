Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141444CCD43
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 06:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238171AbiCDFbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 00:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiCDFa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 00:30:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E3912D220;
        Thu,  3 Mar 2022 21:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E57E461C41;
        Fri,  4 Mar 2022 05:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4108DC340F1;
        Fri,  4 Mar 2022 05:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646371810;
        bh=5LEVjy1YmkdJcCb4Zn5rpRGX1NqKvW+i31QIMXhspnQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bpZK2GqMOPl5OSERZLs3Oaysgwz2PF3qs3kjzyx3t/bg+c/SWSGWeWZAjqfMDiBks
         BsKF0bF3mM1koD0S5YEkZelsQ7C51w4tjh5hHSizQBOPmn4sClE61ylOrQfDCJPC2P
         Sma0xW+n5/aYc9yOa3eASJ0pE9rnEGVlorG3QzrU8jyDMVQpcq/l6OzOo5AccchHNV
         wnDS6sl3+cGk1P0Ry6Xa68sWJVl1bw1n+ZuSdykPYtuSsovzfQLQvvBtouBVNFFnme
         M/pEhWI+95UCwIDa75V0HcOYD7spoTOIseXQpoQTAy71GNTi9DwfWSKXlEpUaE/zrS
         HeWyvoZzNAAhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 25DF2E7BB18;
        Fri,  4 Mar 2022 05:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/smc: fix document build WARNING from
 smc-sysctl.rst
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164637181015.17739.5111216644872044455.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Mar 2022 05:30:10 +0000
References: <20220303113527.62047-1-dust.li@linux.alibaba.com>
In-Reply-To: <20220303113527.62047-1-dust.li@linux.alibaba.com>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  3 Mar 2022 19:35:27 +0800 you wrote:
> Stephen reported the following warning messages from smc-sysctl.rst
> 
> Documentation/networking/smc-sysctl.rst:3: WARNING: Title overline
> too short.
> Documentation/networking/smc-sysctl.rst: WARNING: document isn't
> included in any toctree
> 
> [...]

Here is the summary with links:
  - [net-next] net/smc: fix document build WARNING from smc-sysctl.rst
    https://git.kernel.org/netdev/net-next/c/f9f52c347428

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


