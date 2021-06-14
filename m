Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E513A6F6C
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhFNTw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234729AbhFNTwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 15:52:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7F59B611C0;
        Mon, 14 Jun 2021 19:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623700221;
        bh=+HjYjhxq4jE2k2drDodqPDnW4fNL1TRFIxnKXFMMr6Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YeLCWGJfYwZrnwcfGJGvyoOTwUo3MzBLMYIAJoFNjdkNII1e9F9Ll4Y8/e1wzyeH9
         gHUrIO6CPxLx4MpIyoMxAmrRj4+ZzNVZgt/FWutNprPKwkOPEa1uF2JOH0jDUrazks
         Q4kGB7zXqba/dBq34z1U5xL7Gb8dswFZ0yIyFbyWWkssRkVBxPXq6CDA3HNpfNNLYk
         ZI+pZ/HEquJ7qfJNY1w98W7jtUmXQzy/+GBUNQVAGtnTu56SkptRCJeIt9XTNq5jHC
         /qHGfQlIau/JOca1nKUESsTUkKdulw+6aoX2OnSNGNy+7Afsq9f1G/2ouXK7fuzExF
         7wMRd8PDsd5IQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6D9BA60972;
        Mon, 14 Jun 2021 19:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/1] net: qualcomm: rmnet: always expose a few
 functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162370022144.10983.9509980145136685801.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 19:50:21 +0000
References: <20210613142522.3585441-1-elder@linaro.org>
In-Reply-To: <20210613142522.3585441-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, lkp@intel.com,
        bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 13 Jun 2021 09:25:22 -0500 you wrote:
> A recent change tidied up some conditional code, avoiding the use of
> some #ifdefs.  Unfortunately, if CONFIG_IPV6 was not enabled, it
> meant that two functions were referenced but never defined.
> 
> The easiest fix is to just define stubs for these functions if
> CONFIG_IPV6 is not defined.  This will soon be simplified further
> by some other development in the works...
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/1] net: qualcomm: rmnet: always expose a few functions
    https://git.kernel.org/netdev/net-next/c/b84b53ee8337

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


