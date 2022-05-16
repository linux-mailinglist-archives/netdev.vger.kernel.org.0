Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDEE529197
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 22:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbiEPUmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348227AbiEPUlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:41:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA47047570
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B82CB8165D
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 20:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E281C34100;
        Mon, 16 May 2022 20:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652732413;
        bh=gDYPHYqisGOVKW+tPAiGZHLMeC/4uprHeOKiwhc9WS4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CxIUYQdUVjNZursWDQsE56KwhGOCHv8+sY3jY9GXyiRZsSiuwYLjtfc5kGT5taVwB
         6ipyhmAI1obJuAX+4FmQh60Qx2JMU4XWwjIOzGo1oCkf9g99qZUSgqki0JW8fGvB6j
         x8CmVe9khPmSF5Rq2A6AWIUdsQ7AU9p8r00Tin50OgLI+NegRIwcroJQ/sxILK3vpx
         NJHhpm3ZFaySr4oRSqPwjwfIr6dP0x0Y4+57ZGcmFJCHszs/Q8pzPPHquy/oZQIyuU
         XXEaG0T2EIsjRXNsu7o5HWqUNtGvNpQX7coGTBjmKIbkSWGk44RigdOumvFV55H8QP
         pyat04FWCuiMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 00172E8DBDA;
        Mon, 16 May 2022 20:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ptp: ocp: have adjtime handle negative delta_ns
 correctly
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165273241299.3924.7030273717991579079.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 20:20:12 +0000
References: <20220513225231.1412-1-jonathan.lemon@gmail.com>
In-Reply-To: <20220513225231.1412-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, vfedorenko@novek.ru,
        richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, kernel-team@fb.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 13 May 2022 15:52:31 -0700 you wrote:
> delta_ns is a s64, but it was being passed ptp_ocp_adjtime_coarse
> as an u64.  Also, it turns out that timespec64_add_ns() only handles
> positive values, so perform the math with set_normalized_timespec().
> 
> Fixes: 90f8f4c0e3ce ("ptp: ocp: Add ptp_ocp_adjtime_coarse for large adjustments")
> Suggested-by: Vadim Fedorenko <vfedorenko@novek.ru>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] ptp: ocp: have adjtime handle negative delta_ns correctly
    https://git.kernel.org/netdev/net/c/da2172a9bfec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


