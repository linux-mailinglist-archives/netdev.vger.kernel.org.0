Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267F9567411
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 18:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbiGEQUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 12:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiGEQUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 12:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4D11ADB9
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 09:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACC3361BD6
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 16:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1047AC341CA;
        Tue,  5 Jul 2022 16:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657038013;
        bh=mJdHUCD+ggS6/V7khCuZ5iS3n2tf/yXw738ZZ2yNREA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UraNKgTScSrkQtYkK63vKYzwbNZY+9ue1A6Bb1qmGe+7d5YZbjFfRMbZ0EuhggoBX
         w8dafRIYGS3nr35NAEGHJz5JRWdHzyfMvKHlv3MxfvI+ynBKyFywtvFW9Wh8z9ThMt
         oLKH/cYyxkiGoIfmoHhiK4LG5PNs5t4ZI0yTgRZJoEHgVsagv1lTRc+l/UlzTw5kR7
         FnPvrUwUSilcuFE2gw96aSdWgDlA5R8mrDt7bUNQCRbrr1XKH6tWKIy84tXqk8Y/1f
         W9J9YsOwSqd7i0P4nRi9OgdN1aF+ef4QfP6W93ZVB/pOZDDsylCxhvZws/Nwt7A0Q7
         mR+nb5X7ITcpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E89E7E45BDF;
        Tue,  5 Jul 2022 16:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2 v2] ip: Fix size_columns() invocation that passes a
 32-bit quantity
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165703801294.4255.10482939304957775474.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Jul 2022 16:20:12 +0000
References: <2d920d88cf51f48c0201495ce371817523b7ab48.1656411269.git.petrm@nvidia.com>
In-Reply-To: <2d920d88cf51f48c0201495ce371817523b7ab48.1656411269.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Tue, 28 Jun 2022 12:17:31 +0200 you wrote:
> In print_stats64(), the last size_columns() invocation passes number of
> carrier changes as one of the arguments. The value is decoded as a 32-bit
> quantity, but size_columns() expects a 64-bit one. This is undefined
> behavior.
> 
> The reason valgrind does not cite this is that the previous size_columns()
> invocations prime the ABI area used for the value transfer. When these
> other invocations are commented away, valgrind does complain that
> "conditional jump or move depends on uninitialised value", as would be
> expected.
> 
> [...]

Here is the summary with links:
  - [iproute2,v2] ip: Fix size_columns() invocation that passes a 32-bit quantity
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=329fda186156

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


