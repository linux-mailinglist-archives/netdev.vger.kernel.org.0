Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D05E47E247
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 12:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347945AbhLWLaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 06:30:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50724 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347940AbhLWLaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 06:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2F1061E53;
        Thu, 23 Dec 2021 11:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1865DC36AEC;
        Thu, 23 Dec 2021 11:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640259011;
        bh=/SXaGUWx89j7b1kJVT2xlE6Ibf01QvjaGK4Ex+5Ghq0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PQBLz2nWWK8qN/v8DpIaE9F8pzccG54AyFtkJ1ZD4lI0cprxqoXun18/bZH8sdw2b
         U7Ox+pe8k+1aTTfPuLQDLlEVhG25ex6LH2m1Q4yPt+4LDbGuwuxG9lWViJdezowtiA
         moGstPp7iwlaVyb1EFCRN6OzutAe4a1KByuenQN8k+zkDpqURS02qjLwVu1anGOHTm
         GQUMhNkYkGhOWSfdLqNRrB5/DmpyFV0rUSWyhFJEr7BB7oT8deLqGK5IV3NKA0Z070
         9xUOVbfW6rStSfYmylxF2jeEv8GHM/Y7vgq4YVUfHloV/cj7OKOEAi0X3VJsZ6p8bc
         E7zJqJRs4KatQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02C6FEAC06C;
        Thu, 23 Dec 2021 11:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 1/1] wwan: Replace kernel.h with the necessary inclusions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164025901100.907.10301955769841392273.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Dec 2021 11:30:11 +0000
References: <20211222163256.66270-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20211222163256.66270-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 22 Dec 2021 18:32:56 +0200 you wrote:
> When kernel.h is used in the headers it adds a lot into dependency hell,
> especially when there are circular dependencies are involved.
> 
> Replace kernel.h inclusion with the list of what is really being used.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [v1,1/1] wwan: Replace kernel.h with the necessary inclusions
    https://git.kernel.org/netdev/net-next/c/30be4551f9e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


