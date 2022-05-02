Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD0F516CAF
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 11:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383979AbiEBJDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 05:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383986AbiEBJDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 05:03:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57653C19
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 02:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0A5761047
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 09:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F68EC385AF;
        Mon,  2 May 2022 09:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651482012;
        bh=Q4Lxg3mYgoJYtOkMy5TJ48zQgqq/TolfcfdH1Pp05fI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WXZjgr4AbWmu2g1YM0Fe6uRTqG2Ty6Xm6wQD8EVZ+fLOTg3wWcTvhrq1OMxFCCZhd
         oTkdqZqt7796gR9YZrDdD9vvh1+iZgi/ct478A+PFu/bfKHZdkLvynoqeuAml2pkJL
         xqS9WArqnEyAxaoAUwTsMGURjQ2UdcHvdABBTud874IW8E8KSJL92etXa0cwD9JI1b
         iPBytOW3Sh7V9ZqiFCC6ERXeNFLxpdzkYKFq1SeFO+0yqFhyCIxOQ+Fs/eqD4VSnmz
         UzHovGMoSrP7D7gYsStBxR+SsFmCtZpty+NEoGQsRoxkyIqayrl9MvA/XYRkf8umWx
         8Z+ra10AbImZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33E7DE8DBDA;
        Mon,  2 May 2022 09:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4] selftests: net: vrf_strict_mode_test: add
 support to select a test to run
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165148201220.20737.6374754994100891007.git-patchwork-notify@kernel.org>
Date:   Mon, 02 May 2022 09:00:12 +0000
References: <20220429164658.GA656707@jaehee-ThinkPad-X1-Extreme>
In-Reply-To: <20220429164658.GA656707@jaehee-ThinkPad-X1-Extreme>
To:     Jaehee Park <jhpark1013@gmail.com>
Cc:     outreachy@lists.linux.dev, jdenham@redhat.com,
        roopa.prabhu@gmail.com, sbrivio@redhat.com, netdev@vger.kernel.org,
        roopa@nvidia.com, dsahern@gmail.com
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 29 Apr 2022 12:46:58 -0400 you wrote:
> Add a boilerplate test loop to run all tests in
> vrf_strict_mode_test.sh. Add a -t flag that allows a selected test to
> run. Remove the vrf_strict_mode_tests function which is now unused.
> 
> Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> ---
> v2
> - Add a -t flag that allows a selected test to
> run.
> 
> [...]

Here is the summary with links:
  - [net-next,v4] selftests: net: vrf_strict_mode_test: add support to select a test to run
    https://git.kernel.org/netdev/net-next/c/a313f858ed36

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


