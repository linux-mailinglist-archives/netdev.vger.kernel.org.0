Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645BE4D54F0
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344139AbiCJXBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343631AbiCJXBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:01:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9140AE6D91;
        Thu, 10 Mar 2022 15:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43319B82923;
        Thu, 10 Mar 2022 23:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EAF5BC340E9;
        Thu, 10 Mar 2022 23:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646953211;
        bh=YnU9wRAcgPPKa0uEALi1ZM17WwpEji+yiQPEESqcbrs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TSVNAqV3G6a18BwVmRPxQlEu81vG7hjstbDuuqAjisoA5O6gSqghugmRxEE3uCDIS
         TqCwZF9P9J4svYvfZ7Z5zdbaLPtiz1xNwAuvpJ6bjmVDZNGDnyMCOBjPJJWvkwoDVB
         phRraHuyV92yg/lhU1JZwbczrJHmzb1bXKun48RMQPqxMRuKV/OKcdfeljHhmWCvwl
         Jx57JyijHMwdZuHe0r1esRsTRVoezAUXBy7fH4v5F+AN0FYf4E2S4N20hlao5S8pX9
         LnhIuIvlfhb8Iyjee0B5DqTpaBubKKkjwh+++k6OsojTVTnmKFkNin1KlJRrvzv9jY
         ZFc/gyH92KduA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB8ADF0383F;
        Thu, 10 Mar 2022 23:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bcmgenet: Don't claim WOL when its not available
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164695321082.6170.1437245957185629804.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 23:00:10 +0000
References: <20220310045535.224450-1-jeremy.linton@arm.com>
In-Reply-To: <20220310045535.224450-1-jeremy.linton@arm.com>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, pbrobinson@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  9 Mar 2022 22:55:35 -0600 you wrote:
> Some of the bcmgenet platforms don't correctly support WOL, yet
> ethtool returns:
> 
> "Supports Wake-on: gsf"
> 
> which is false.
> 
> [...]

Here is the summary with links:
  - net: bcmgenet: Don't claim WOL when its not available
    https://git.kernel.org/netdev/net/c/00b022f8f876

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


