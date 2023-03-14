Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A046B867C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjCNAAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCNAAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021DC868A
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 17:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A539CB81687
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 00:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42CA4C433A8;
        Tue, 14 Mar 2023 00:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678752017;
        bh=3i7PjXnjqLDHQ5SbavfdR1/IZRoenkOhqmTOGIEbWSE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c2XGXKPlOpQe5MFlfKv73jCf05al5xPxJaep6lJLU8gNelgb8N9cs95pdzCwQI1qq
         5IhhBL7kMrg2Gpq+YSJWicv4ES3N7FBCyFdA/tX3WkEUa5JJu4fm86wruOZpl6QYn6
         faUQLUeqTuHZspx5nNVBwuyKQaKmjv0K0UzOw+45EW3Ss2aBS9GYAc4nxJYjxURQM2
         QBWmtr4dNdnVDEQw3EgdmAfS5UWlUOWlMP9p5kHh5NmrwGpuYhftq4MKzxsLUceqz0
         Eff9NuKIrbFlZAwK21ADOwpyCy08zRdRcrMKtZ9SKB8SAMymKhKi1MaRARphxvaXVB
         7Kc+Bhmn7Ho9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2DA80E66CB9;
        Tue, 14 Mar 2023 00:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: tc-testing: add tests for action binding
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167875201718.9292.17433033495134114452.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Mar 2023 00:00:17 +0000
References: <20230309175554.304824-1-pctammela@mojatatu.com>
In-Reply-To: <20230309175554.304824-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, shuah@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Mar 2023 14:55:54 -0300 you wrote:
> Add tests that check if filters can bind actions, that is create an
> action independently and then bind to a filter.
> 
> tdc-tests under category 'infra':
> 1..18
> ok 1 abdc - Reference pedit action object in filter
> ok 2 7a70 - Reference mpls action object in filter
> ok 3 d241 - Reference bpf action object in filter
> ok 4 383a - Reference connmark action object in filter
> ok 5 c619 - Reference csum action object in filter
> ok 6 a93d - Reference ct action object in filter
> ok 7 8bb5 - Reference ctinfo action object in filter
> ok 8 2241 - Reference gact action object in filter
> ok 9 35e9 - Reference gate action object in filter
> ok 10 b22e - Reference ife action object in filter
> ok 11 ef74 - Reference mirred action object in filter
> ok 12 2c81 - Reference nat action object in filter
> ok 13 ac9d - Reference police action object in filter
> ok 14 68be - Reference sample action object in filter
> ok 15 cf01 - Reference skbedit action object in filter
> ok 16 c109 - Reference skbmod action object in filter
> ok 17 4abc - Reference tunnel_key action object in filter
> ok 18 dadd - Reference vlan action object in filter
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: tc-testing: add tests for action binding
    https://git.kernel.org/netdev/net-next/c/c66b2111c9c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


