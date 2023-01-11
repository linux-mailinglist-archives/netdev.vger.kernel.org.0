Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50903666308
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235533AbjAKSuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbjAKSuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840373C71C
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32FF6B81CB3
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 18:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3CDEC433F0;
        Wed, 11 Jan 2023 18:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673463016;
        bh=03KTnhOp1p8p+s7KiGw5ABZ91eIWkDbA0gHBqBzbj24=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EvMC8dd8+gpTk887YdenehZuoHG1cbUZiSagghqxOIvnky+IM/E7psjvFo1KUSo7T
         fNF0J2rX+F8JHs2WfaliGQSgk/10o/VOmirkeb2Fq9+AsIstGa6A6N5u5hvEENgR3i
         EzGPuJKd+Ivwq6kO7KDg9DhH0tQKSOKUxVuzOCIowNjftlVNi8lAlJ9TJdToCku9UT
         IoUBzk98E2rt87FmFhjOOYqAGhmjeROHgmKU8Y86jLar35Bt2wPpYBHExMuHTb6J6k
         lkQxhwGyUJzuQJDgtoNSlopwXsD3z47o9bO4Wezkuzp+TRP4E7RsjuiIysYBZogmFY
         fVg8d7O5YfapQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B98AAE4D025;
        Wed, 11 Jan 2023 18:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute] tc: remove support for rr qdisc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167346301675.24078.8164060481977009067.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Jan 2023 18:50:16 +0000
References: <20230111171420.57282-1-stephen@networkplumber.org>
In-Reply-To: <20230111171420.57282-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Wed, 11 Jan 2023 09:14:20 -0800 you wrote:
> The Round-Robin qdisc was removed in kernel version 2.6.27.
> Remove code and man page references from iproute.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  bash-completion/tc |   4 +-
>  man/man8/tc.8      |   4 --
>  tc/Makefile        |   1 -
>  tc/q_rr.c          | 119 ---------------------------------------------
>  4 files changed, 2 insertions(+), 126 deletions(-)
>  delete mode 100644 tc/q_rr.c

Here is the summary with links:
  - [iproute] tc: remove support for rr qdisc
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=4dc60c017920

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


