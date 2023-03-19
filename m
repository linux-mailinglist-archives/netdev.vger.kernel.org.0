Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4E56BFF15
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 03:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjCSCaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 22:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCSCaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 22:30:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA49BC15D
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 19:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55DE0B80A4A
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 02:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2569C433A0;
        Sun, 19 Mar 2023 02:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679193017;
        bh=Yfp4AzcSo5loJVj4HrClO4mRa3sQwxWtkFEieEOAp9s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kknToVd3YFAqhRNhDOk0/ekiEqkqJ1PoeLYeMZsSJmnYqvtKKKQzMRdCbKqjdT7SE
         sbI4kTzzlc9GkQW/GXsMns51ta6QuipXHZwCaMexvGBco2Fr1hstxT1Lz1xMa6Sj0U
         7dY+SqEmbIQ8nxNmWf1WGdsG2UFSvf7ian6aMq7GE5OGjbNmEpTAqzqc2GvK0Gi+jj
         oRp5t3OQUb3d/nT1sTqARywsG2EhfjrMGzW+vck1O4COqDz4xb1QT5fBBoFAWZzjAl
         1ksX9eyfJ8qN1ditX2+YVEto5xkFbm6nNalrJ3rrOfreLYvnIUo9Br0fbwOjY37o7e
         2sVCoAmnnXXew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7D91E21EE8;
        Sun, 19 Mar 2023 02:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 iproute2 0/2] tc: fix parsing of TCA_EXT_WARN_MSG
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167919301688.17083.16204503921613920562.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Mar 2023 02:30:16 +0000
References: <20230316035242.2321915-1-liuhangbin@gmail.com>
In-Reply-To: <20230316035242.2321915-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, dsahern@kernel.org,
        stephen@networkplumber.org, dcaratti@redhat.com,
        pctammela@mojatatu.com, mleitner@redhat.com, psutter@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Thu, 16 Mar 2023 11:52:40 +0800 you wrote:
> The TCA_EXT_WARN_MSG enum belongs to __TCA_MAX namespace. We can't use it
> in tc action as it use TCA_ROOT_MAX enum. Fix it by adding a new
> TCA_ROOT_EXT_WARN_MSG enum.
> 
> Hangbin Liu (2):
>   Revert "tc: m_action: fix parsing of TCA_EXT_WARN_MSG"
>   tc: m_action: fix parsing of TCA_EXT_WARN_MSG by using different enum
> 
> [...]

Here is the summary with links:
  - [PATCHv2,iproute2,1/2] Revert "tc: m_action: fix parsing of TCA_EXT_WARN_MSG"
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=0012881f3499
  - [PATCHv2,iproute2,2/2] tc: m_action: fix parsing of TCA_EXT_WARN_MSG by using different enum
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


