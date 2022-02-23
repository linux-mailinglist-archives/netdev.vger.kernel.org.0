Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7614C12E5
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 13:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240510AbiBWMkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 07:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240126AbiBWMkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 07:40:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A67A27A4;
        Wed, 23 Feb 2022 04:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65D4B612DF;
        Wed, 23 Feb 2022 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B86B4C340F4;
        Wed, 23 Feb 2022 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645620010;
        bh=xAV1ltAryiuNs2ZUkrZ0FwYZgWKeiNNLqbbBTPNqtm0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B7h/8sP+72Mz+OSfQ/LraHP+KAkvrOjMDGi1MQIImHw7QSrNG9fbmv0JxtCVywHcA
         Q/RV4Sq7CkYlutSEFZl+zLYbLZJwJVGa525nxcqTnUK/DbxeMWy2nctaHXUtJq8mif
         dihaRfcPrcS1GUEGT1OpGTMGrG/lFEznbYnBwkNP6JVDbPJRam0qKv6ga+Z/tJf1K8
         iIiTq3bPQsKggxUAX6us/XdJBnK3WDaf+Nw5dh5jEZpqXQ8BlBbg6kAHjnplg0KB5W
         E0r1vJOP1Trgm1/gHyGksWLlnwG9Ys1eEumE2Gj9I7eErjqmICV1aG2bCnMnXX5UF7
         Eg0bLcVWeWclQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F888E73590;
        Wed, 23 Feb 2022 12:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: Fix end of loop tests for list_for_each_entry()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164562001064.25344.14216155455524345283.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 12:40:10 +0000
References: <20220222134311.GA2716@kili>
In-Reply-To: <20220222134311.GA2716@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     jmaloy@redhat.com, richard.alpe@ericsson.com,
        ying.xue@windriver.com, davem@davemloft.net, kuba@kernel.org,
        erik.hugne@ericsson.com, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 22 Feb 2022 16:43:12 +0300 you wrote:
> These tests are supposed to check if the loop exited via a break or not.
> However the tests are wrong because if we did not exit via a break then
> "p" is not a valid pointer.  In that case, it's the equivalent of
> "if (*(u32 *)sr == *last_key) {".  That's going to work most of the time,
> but there is a potential for those to be equal.
> 
> Fixes: 1593123a6a49 ("tipc: add name table dump to new netlink api")
> Fixes: 1a1a143daf84 ("tipc: add publication dump to new netlink api")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [net] tipc: Fix end of loop tests for list_for_each_entry()
    https://git.kernel.org/netdev/net/c/a1f8fec4dac8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


