Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C93D6BE03A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 05:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjCQEk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 00:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCQEkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 00:40:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7494427497
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 21:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20739B8244A
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 04:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AAF57C433A0;
        Fri, 17 Mar 2023 04:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679028019;
        bh=QJylvpRInFqmuhyn/RDUCzQuJoo5FYAKSwnr9xW+xzM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nC3nYkkDGxSTx9drpq641jv51ooEqCn7O+tvyOWNSZ7W5NsQuBWVcTnLNNd31XsNu
         7M7CQR1NgnBjPrKJrw+4WSGQY6651Ta1bszui3dYYcOwd/JH+PlsJLGYJ39oYCGl+n
         vXOCo6neTJXU3agMUk2To9pOI2jXQPCQqOuaQCcTGFJYd+yEnvjuqnWh//xRyRLTsA
         x7RtAMF/3mCehP7OOZHWvS2bahCG/sbhKx5a2HEAu+l2QjGQWTfH0pmZHPLS9QjgIi
         NTD+uh/pk0Evco8V6Fw2PXdBBf8D2NhQDBZVcJMzCHNobcgmZ5v2pu6f3L9W4DnWTu
         p6pdpaOAieNBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 855F6E21EE9;
        Fri, 17 Mar 2023 04:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net 0/2] net/sched: fix parsing of TCA_EXT_WARN_MSG for tc
 action
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167902801954.7493.12106880275195611961.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 04:40:19 +0000
References: <20230316033753.2320557-1-liuhangbin@gmail.com>
In-Reply-To: <20230316033753.2320557-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, dsahern@kernel.org,
        stephen@networkplumber.org, dcaratti@redhat.com,
        pctammela@mojatatu.com, mleitner@redhat.com, psutter@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Mar 2023 11:37:51 +0800 you wrote:
> In my previous commit 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG
> to report tc extact message") I didn't notice the tc action use different
> enum with filter. So we can't use TCA_EXT_WARN_MSG directly for tc action.
> 
> Let's rever the previous fix 923b2e30dc9c ("net/sched: act_api: move
> TCA_EXT_WARN_MSG to the correct hierarchy") and add a new
> TCA_ROOT_EXT_WARN_MSG for tc action specifically.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net,1/2] Revert "net/sched: act_api: move TCA_EXT_WARN_MSG to the correct hierarchy"
    https://git.kernel.org/netdev/net/c/8de2bd02439e
  - [PATCHv2,net,2/2] net/sched: act_api: add specific EXT_WARN_MSG for tc action
    https://git.kernel.org/netdev/net/c/2f59823fe696

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


