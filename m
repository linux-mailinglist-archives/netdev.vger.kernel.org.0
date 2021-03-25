Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64863485CF
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 01:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239222AbhCYAUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 20:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239201AbhCYAUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 20:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C7B6761A1F;
        Thu, 25 Mar 2021 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616631609;
        bh=g/h8okAhnBUC8PuloGj+E5Mp9Lf8IBaRMegEzWlhzrs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qk4pa6qkoQbGZ/ESF4eCEAw99uqsFS3nIessqyC9ASg0FmdnyqUjLAshsRjooFED2
         JWALfY8cxWUBk2RP0W/kivrQat5vWBAMQMU8XLuojzxcKfRtt5BvmplF0sJ6hZ8KBX
         t9sjQdzrjDqgOnl8awxbXEGmQevZyBExVNGxNximyd01fMn3bg4+/8VdFaPhqoDIhq
         yu1w3xvfgf1XNPY+Rq1GW5yIDhOZ0nW63wxj+cVvYrjTIQrLw6W35muJXl41I5jqBA
         D2lDLxYANo68I+zxEzJ+Zgq+pXdlUlleISMnGWoHhpi3TyAF0GfXqVQrF0++9QpuZC
         qY5uZxi4mEQtA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C39C26096E;
        Thu, 25 Mar 2021 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/6] net: ipa: versions and registers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161663160979.5502.1561862780789563905.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Mar 2021 00:20:09 +0000
References: <20210324131528.2369348-1-elder@linaro.org>
In-Reply-To: <20210324131528.2369348-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 24 Mar 2021 08:15:22 -0500 you wrote:
> Version 2 of this series adds kernel-doc descriptions for all
> members of the ipa_version enumerated type in patch 2.
> 
> The original description of the series is below.
> 
> 					-Alex
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/6] net: ipa: reduce IPA version assumptions
    https://git.kernel.org/netdev/net-next/c/d7f3087b396d
  - [net-next,v2,2/6] net: ipa: update version definitions
    https://git.kernel.org/netdev/net-next/c/eb09457c9d33
  - [net-next,v2,3/6] net: ipa: define the ENDP_INIT_NAT register
    https://git.kernel.org/netdev/net-next/c/647a05f3ae98
  - [net-next,v2,4/6] net: ipa: limit local processing context address
    https://git.kernel.org/netdev/net-next/c/e6e49e435512
  - [net-next,v2,5/6] net: ipa: move ipa_aggr_granularity_val()
    https://git.kernel.org/netdev/net-next/c/1910494ee32c
  - [net-next,v2,6/6] net: ipa: increase channels and events
    https://git.kernel.org/netdev/net-next/c/810a2e1f1073

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


