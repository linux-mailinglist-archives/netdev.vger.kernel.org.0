Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3A9483699
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 19:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiACSKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 13:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbiACSKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 13:10:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69085C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 10:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 248FAB81076
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 18:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA7AFC36AED;
        Mon,  3 Jan 2022 18:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641233408;
        bh=8mlEQ6b9M7r43y80jloEtmanHGzm/u9iNGHDpDc5nCw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JPDND7EAd+D1eRtxIYY25rXYHnhM65v9hwvgzOSbQ0gkkp7AgIprdJTMLJGsMUh5c
         5lXxxkYYM24uB/BqJ595sjE1E18QhRLpST1xPp1J+mrvdtrbpgJV5uF1OtroBoq8gE
         GCkaglYEMfXkq9VML4dKfmQyLLVhgveNX1RlTB41/DUd8LsnyxsM+RCrfcVJ5aYPQ8
         sbc4OesQB7EOFYwqDm827tw+UzzP1l7LtPlDsJWrncbummkcrVg76an+HidZX9185S
         AHpMNVEA313mjjkYHi5fB9QtikDh8mOBYf4AzYfZ05PQtvOIWRrFTD6W3PhWE+DaTq
         WypIIWrzbb7bA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9CE05F79401;
        Mon,  3 Jan 2022 18:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: Do cleanup if attribute validation fails in
 multipath route
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164123340863.8182.15329803862034948814.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Jan 2022 18:10:08 +0000
References: <20220103170555.94638-1-dsahern@kernel.org>
In-Reply-To: <20220103170555.94638-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, nicolas.dichtel@6wind.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  3 Jan 2022 10:05:55 -0700 you wrote:
> As Nicolas noted, if gateway validation fails walking the multipath
> attribute the code should jump to the cleanup to free previously
> allocated memory.
> 
> Fixes: 23fb261977fd ("ipv6: Check attribute length for RTA_GATEWAY in multipath route")
> Signed-off-by: David Ahern <dsahern@kernel.org>
> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 
> [...]

Here is the summary with links:
  - [net] ipv6: Do cleanup if attribute validation fails in multipath route
    https://git.kernel.org/netdev/net/c/95bdba23b5b4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


