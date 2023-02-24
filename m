Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648016A215E
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjBXSUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBXSUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:20:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E1D6B171
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BDCDB81C99
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 18:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34636C433EF;
        Fri, 24 Feb 2023 18:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677262817;
        bh=XMuGEUvl9KSHGNrbirRokNXxUJ0soAv+QxM8Lf9hlwo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YXwFHGdQZ8uh3uUtiIduNYuZVTx5p9MayYJevv9/WY3bX5gfQvGtrSt+mOfsW0Gk+
         SEuxJuX13hO+Jutpt5qh2i558Hun5As0ZyJDn9fs7YET5u9o9Ta9VuIcx6JCYqFaJG
         4NuA0R8wPsRfvfNgS0sosHrNYjJ4FqOPDi/jnmYXyLVQv/4/SmQEwal9X9ipOCTy9i
         PHKqYZBz4YZhfq7JnGf6xrju2PxGQsNaQbiLvNnZgJW1HODJTmhpaI2W3A8ind4xDR
         gM0gzz30RKY+7q40lFWrdiHHjMf30od7SImbMTYRwLVcpQXbDJf2a93eQBPx5OaGbA
         KYTI/hjZs8hUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 087BDE68D2D;
        Fri, 24 Feb 2023 18:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] tc: m_action: fix parsing of TCA_EXT_WARN_MSG
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167726281703.23174.14181936132337747798.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Feb 2023 18:20:17 +0000
References: <20230224175756.180480-1-pctammela@mojatatu.com>
In-Reply-To: <20230224175756.180480-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, liuhangbin@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Fri, 24 Feb 2023 14:57:56 -0300 you wrote:
> It should sit within the TCA_ACT_TAB hierarchy, otherwise the access to
> tb is out of bounds:
> ./tc action ls action csum
> total acts 1
> 
>         action order 0: csum (?empty) action pass
>         index 1 ref 1 bind 0
>         not_in_hw
> Segmentation fault (core dumped)
> 
> [...]

Here is the summary with links:
  - [iproute2] tc: m_action: fix parsing of TCA_EXT_WARN_MSG
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=70b9ebae63ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


