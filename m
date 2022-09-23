Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436815E7C95
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 16:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiIWOLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 10:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbiIWOKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 10:10:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6848FEE67B;
        Fri, 23 Sep 2022 07:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B5F87CE24E3;
        Fri, 23 Sep 2022 14:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1AF64C4347C;
        Fri, 23 Sep 2022 14:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663942217;
        bh=iAWhOPsndRHqQw8SQe8LSyqZZn5ruSlDcyafkVQl0xs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rHnY2Rbg+pxQ+vtknC8C1wKlFqj3JQz9BSel/X+FHqgB/yCPFbXp1d/i1NJYLlKiQ
         ZMbU2WCXKNYs8vAEyTUtQ7ZueorPA9JPmFwO9yHL7tGlu9uLvXYMkqVl31of1aQ7v3
         g7tB8rseuicwuq1mseI67gtt4ARs+G0utDlW9h8b2BMvSDUFQ8fVTqYhYnVISMiZ6D
         Xi0A1ip/x7guZatl6wDT4BQF3KC3scDMIk0xJUmE1pIbgJl40a9iz+BqC2B2cIveNr
         txpSIkX9PQ/7XQfF6bj4DNusifjwkuA0zAtFwvX924aCH9jWjk+lRWuOYBODRDC06X
         ZHhX+Rmpg5bIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2EE9E4D03F;
        Fri, 23 Sep 2022 14:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests/bonding: re-add lladdr target test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166394221699.18573.18054139188469148797.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 14:10:16 +0000
References: <20220923082306.2468081-1-matthieu.baerts@tessares.net>
In-Reply-To: <20220923082306.2468081-1-matthieu.baerts@tessares.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        shuah@kernel.org, kuba@kernel.org, liuhangbin@gmail.com,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri, 23 Sep 2022 10:23:06 +0200 you wrote:
> It looks like this test has been accidentally dropped when resolving
> conflicts in this Makefile.
> 
> Most probably because there were 3 different patches modifying this file
> in parallel:
> 
>   commit 152e8ec77640 ("selftests/bonding: add a test for bonding lladdr target")
>   commit bbb774d921e2 ("net: Add tests for bonding and team address list management")
>   commit 2ffd57327ff1 ("selftests: bonding: cause oops in bond_rr_gen_slave_id")
> 
> [...]

Here is the summary with links:
  - [net-next] selftests/bonding: re-add lladdr target test
    https://git.kernel.org/netdev/net-next/c/aacdecda9eb4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


