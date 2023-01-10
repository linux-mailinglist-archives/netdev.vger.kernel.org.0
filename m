Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00AE2664752
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 18:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjAJRWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 12:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjAJRVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 12:21:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D523758834
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 09:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7176761802
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 17:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7571C433F0;
        Tue, 10 Jan 2023 17:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673371217;
        bh=irLMQ6YuPbG1XeFnoK+vQSgQ6Uv18D1yHTwwfLI3plI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OHtwEiTJGW6w0SArx2jgv/FMFMvXd7b7j3fTSNmwwjSq0BPS38wRlxqwf7HFQAcbQ
         MjoQau/QQzZmADw2Ut6DX6p/KzhZP8NFAtUnSMIcnkiintjv/h7OeT1oSyI/TPzG/z
         ofu3QKEfvENgdqvxHZ2cmjkwy7ZBYNQjIetxaqhLw0Dq7GezQWNdPyJNBwIWVLEvIU
         US7vzItvBzy+aFRk66vUUc7brfooA7xUrcml/jmjetdAzbrox7qRjcCXjEUdpRqATc
         /L5KdzCRln9YNxQsYd+wR9JsrmUms0bLlXIFDbYLZgS5a+PGGdRSLkiTNWe/LUQLWr
         cwZX6ca1t26ug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9F63E21EE8;
        Tue, 10 Jan 2023 17:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] mptcp: add new listener events
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167337121769.21273.2579417905978970207.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Jan 2023 17:20:17 +0000
References: <20230110-mptcp-events-listener-net-v1-1-88a946722fe7@tessares.net>
In-Reply-To: <20230110-mptcp-events-listener-net-v1-1-88a946722fe7@tessares.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, mathew.j.martineau@linux.intel.com,
        geliang.tang@suse.com
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

On Tue, 10 Jan 2023 16:36:20 +0100 you wrote:
> These new events have been added in kernel commit f8c9dfbd875b ("mptcp:
> add pm listener events") by Geliang Tang.
> 
> Two new MPTCP Netlink event types for PM listening socket creation and
> closure have been recently added. They will be available in the future
> v6.2 kernel.
> 
> [...]

Here is the summary with links:
  - [iproute2] mptcp: add new listener events
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=e2e81aa20f73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


