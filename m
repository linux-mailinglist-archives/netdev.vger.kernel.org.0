Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D7355F5A8
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 07:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiF2FUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 01:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiF2FUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 01:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4473F31340;
        Tue, 28 Jun 2022 22:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C30EB821C2;
        Wed, 29 Jun 2022 05:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E33EC341CA;
        Wed, 29 Jun 2022 05:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656480013;
        bh=wVaA/zaGrgkeDZVTa1fVbkBtdiqSj69Zp6MvjMQn6+g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c6mTJFvA9MsqU9eOMb/sRIeBu/O0UGiwWKV+YjsOiAo+123DvyBiPYtCRAAd6PVo1
         zvOerCGLy+q6mlW2PqNvw3Ocd+1ymArOaYOJZbWnh+3E26D1AL32DgIOqR9XlK2V5O
         WqTw2ebp/NuZghwiBxlsZqla1VyNB910H29Mkod06fqWjPMPy8P0jgW+AqBXWOGw3Q
         f1vS1C5J2s4//Dad30ec0iGADomGCMq0d6vs/SSVUylUKHPzLwFB8/1L4IjPfUgv0a
         4/SSPbVQ7YggTRdiahntf1D9KjsRIJK1WfOrnivmi6rGxMaZMhi7bBPXZDVh1fDU2U
         5ieRjgzbt8XvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7CB1FE49BBA;
        Wed, 29 Jun 2022 05:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mptcp: fix some spelling mistake in mptcp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165648001350.19091.5869614487710926226.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 05:20:13 +0000
References: <20220627121626.1595732-1-imagedong@tencent.com>
In-Reply-To: <20220627121626.1595732-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     kuba@kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        imagedong@tencent.com
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

On Mon, 27 Jun 2022 20:16:25 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> codespell finds some spelling mistake in mptcp:
> 
> net/mptcp/subflow.c:1624: interaces ==> interfaces
> net/mptcp/pm_netlink.c:1130: regarless ==> regardless
> 
> [...]

Here is the summary with links:
  - [net-next] net: mptcp: fix some spelling mistake in mptcp
    https://git.kernel.org/netdev/net-next/c/d640516a65d8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


