Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAC74DE368
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241084AbiCRVVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbiCRVVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:21:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A0D21D7E6
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 14:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20EDA61173
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 21:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A06AC340F8;
        Fri, 18 Mar 2022 21:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647638413;
        bh=nM6AGHeZSAIAR+giHj1rnczSD88wMAA0/RjS788l9bM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FFOLSmm4d6EWhmr53nOqnlQibS31zRHv+KaUlvl5a915Cu1fGvlsFJL43YwmhP8fX
         Uw8rkHaR7TZt/l/MH1OeZ7NJ/vC5ybMwK80GUJxuCmZ8dZBgYzdN4zw6fYw4XoX9IT
         eJAdvWAg27gdMUmZCqjA2nRr/Vfy07VWhBVwmxfJxxGXuA8skUEzrTcutK9WC2hGT4
         bgYB3/P2vh8qvEXZ5oLrXN1iDgjbvykNtA+ivCKBKjqf8I7XDfMovoTA6SIEMhgE/4
         MXObna5YWPM2gn0MJOyqUxb6r6DhznCHtUbLa/mE4uYQvAkKq4dV8d6RVTPBFHUZVr
         VpOK41INDGsjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6495AE6D44B;
        Fri, 18 Mar 2022 21:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mptcp: send ADD_ADDR echo before create subflows
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164763841340.20195.7704185499588470614.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 21:20:13 +0000
References: <20220317221444.426335-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220317221444.426335-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, liyonglong@chinatelecom.cn,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 17 Mar 2022 15:14:44 -0700 you wrote:
> From: Yonglong Li <liyonglong@chinatelecom.cn>
> 
> In some corner cases, the peer handing an incoming ADD_ADDR option, can
> receive a retransmitted ADD_ADDR for the same address before the subflow
> creation completes.
> 
> We can avoid the above issue by generating and sending the ADD_ADDR echo
> before starting the MPJ subflow connection.
> 
> [...]

Here is the summary with links:
  - [net-next] mptcp: send ADD_ADDR echo before create subflows
    https://git.kernel.org/netdev/net-next/c/12a18341b5c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


