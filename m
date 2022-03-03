Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2A74CB6A0
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 07:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiCCGA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiCCGA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:00:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7114E119F19;
        Wed,  2 Mar 2022 22:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3735DB823BB;
        Thu,  3 Mar 2022 06:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3246C340F0;
        Thu,  3 Mar 2022 06:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646287212;
        bh=iF4VEgaaRrydJOnjJ3ZBlQXOAetWcYEh4mHBFO6xg90=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uxQ4bdlsa/Ap2SFJXFYlByLPoCJZA8IDbPmMdcxGsqw9YM4xwR9wxs6pF6Oy1tO1s
         dXPxO4ADtJglq/ESBnCIsLcIHX5XZmCcijQT2YpORtcVN078/cz81HMT0I1DbMZRAm
         KdYv2XeukiRLQnjx4MLxxO3TSFTdv4y2zZd6jqmJrXjG9kul/Ys12d5XMpGrTQlaHa
         60QnRcs20hDjlTkvOQbAJmbCL4EuSrNjzapoLCJ15515J773/UQ0MeeC2Twr/00cVe
         +a5w4PlW2Im/xFkdnEL5s4FWrF3cIHHnXGs8oiFSJghEallmoxH4jhi7QJ647A7iLn
         5cxn2zf0wYTqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6F91EAC096;
        Thu,  3 Mar 2022 06:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless 2022-03-02
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164628721187.27095.16851697103868884820.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 06:00:11 +0000
References: <20220302214444.100180-1-johannes@sipsolutions.net>
In-Reply-To: <20220302214444.100180-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  2 Mar 2022 22:44:43 +0100 you wrote:
> Hi,
> 
> So that was quick - got two more obvious fixes, and
> figured out the build fix (the commit log describes
> it, but evidently I was too dense the other day to
> understand it) ... sorry about that.
> 
> [...]

Here is the summary with links:
  - pull-request: wireless 2022-03-02
    https://git.kernel.org/netdev/net/c/95749c103379

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


