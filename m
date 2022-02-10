Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9711F4B14FD
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245562AbiBJSKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:10:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiBJSKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:10:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE616110C
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D575B826AA
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 18:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1DCB2C340EF;
        Thu, 10 Feb 2022 18:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644516610;
        bh=Np40ZH+iO1IWk2b0ERVPG+RTHSjUy/CoAB4f2UqpS9w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=US4TMymUfdz98uuy6Je6HsI9mr/WG01AOCrUAuhagOJdbFK5yDee2Fbqh10/al2XM
         ziD1JNi3quKj5msuJ78UAvHeD1X6wodPn5jl/whoclX+WcSMn1fo8NiXmiR1DkXLh7
         Om15FHNFXg7VENdHVwzosFpj8SVpwOdFkKnWw8vTverNBgqzvP0/PP/1U2MaYuVMEN
         pJpmmjuRR25Jjs/FoT7jy3lCk8IrQAMG3JYIePcGIQsQ0BkwggwbLHwkYmoCJ2S0V9
         TWLajgF8L168J0sjf6uSbqJ7SlLOvsnDg3aEF+wAv2f8WT4dQPQC4GivvfZC8HnGYY
         F3w85mX9hBq8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 01C56E6D453;
        Thu, 10 Feb 2022 18:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 1/2] Add support for the IOAM insertion
 frequency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164451661000.28542.11297772284276369342.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 18:10:10 +0000
References: <20220205155208.22531-2-justin.iurman@uliege.be>
In-Reply-To: <20220205155208.22531-2-justin.iurman@uliege.be>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        stephen@networkplumber.org
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

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Sat,  5 Feb 2022 16:52:07 +0100 you wrote:
> This patch adds support for the IOAM insertion frequency by introducing
> a new parameter "freq". The expected value is "k/n", see the patchset
> description for more details.
> 
> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> ---
>  ip/iproute_lwtunnel.c | 69 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 67 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [iproute2-next,1/2] Add support for the IOAM insertion frequency
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=8908cb25711e
  - [iproute2-next,2/2] Update documentation
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=ff14875e9d77

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


