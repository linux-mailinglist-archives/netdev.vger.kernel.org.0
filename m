Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2833D7E5F
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 21:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhG0TUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 15:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229737AbhG0TUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 15:20:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8DFE360F94;
        Tue, 27 Jul 2021 19:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627413605;
        bh=HavSh650pJYWcBN8ao5Um+SK/Mpt5czcHLKMrH/5vtM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qNsq4mTS1fjebDOu3dxx9LaWOuwTZ11QDiJWnqVArTviJxF5Uwx9Ndkfd3GA8HVJV
         96uraBAjPdjNGWkTVt7HQxlnJNwuIotmPUqmONzPsPPWhDh5xAiTKrus3ymV3xfUcd
         PLo1i0jrOj566e60+n+BMgUAOi+0017jwIKZ8Gg2KSGlYNVc8x26lsvH6mfOjaUEQO
         v1j/brNfZQGmbvpQYH2IkQ5/Eh95xhR5ynnzPxuHizS8mt7UI6yuTHv0m2W25Lj84u
         GT5rAQ+LJU6M6covK/7G4T/9sK92voYOWr/pi9PWLL+T8KWP3ZIyxRBk0QqBKRIYjc
         tM5gnOqhU10AQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8289E60A59;
        Tue, 27 Jul 2021 19:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] more accurate DSACK processing for RACK-TLP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162741360553.32214.12453870560263718574.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jul 2021 19:20:05 +0000
References: <20210727144258.946533-1-ncardwell@google.com>
In-Reply-To: <20210727144258.946533-1-ncardwell@google.com>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Jul 2021 10:42:56 -0400 you wrote:
> This patch series includes two minor improvements to tighten up the accuracy of
> the processing of incoming DSACK information, so that RACK-TLP behavior is
> faster and more precise: first, to ensure we detect packet loss in some extra
> corner cases; and second, to avoid growing the RACK reordering window (and
> delaying fast recovery) in cases where it seems clear we don't need to.
> 
> Neal Cardwell (1):
>   tcp: more accurately check DSACKs to grow RACK reordering window
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] tcp: more accurately detect spurious TLP probes
    https://git.kernel.org/netdev/net-next/c/63f367d9de77
  - [net-next,2/2] tcp: more accurately check DSACKs to grow RACK reordering window
    https://git.kernel.org/netdev/net-next/c/a657db0350bb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


