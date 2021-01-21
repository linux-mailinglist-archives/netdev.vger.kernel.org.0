Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD932FE17C
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbhAUFRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:17:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbhAUFLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 00:11:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9CB4A2395C;
        Thu, 21 Jan 2021 05:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611205809;
        bh=3I8l4CUgu5O5uaZ2w+gMlhJdudrEz7ZQNwjq5x68k7g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qarVy4UkzWFMoyAJjQfutDPxjCKgXcjtaeSxeAm47CyFJVw68v7JB/2jOx8i0UUOb
         DB5vcq0F6y2LEq+xLptF0Ii9awf97ZG6VZpLFicfMp1qcrlHEifqWGxlSKPQ4Jp8Mt
         BngRaDQxkXslXwGrxDIBMqlWUh2kVbx3OqLlyXXtb0p3C08FRIKC9HT67l5KiaKac9
         SlEaUS9HTaRqDwmUFLCsnU226wIW5Kzc9BlUU7gDkaf0KPlpNapCZV/r/N2aZyIrBl
         oyUxNIb7uv2jD1HmeZnaWd3ovIBZQ1YlbjGSe0qf0zWCN9gyNX9zjF91nyoPYa5neb
         LboS1kK+utZoQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 8E0F260641;
        Thu, 21 Jan 2021 05:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] nexthop: More fine-grained policies for
 netlink message validation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161120580957.27834.10077802568257203594.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jan 2021 05:10:09 +0000
References: <cover.1611156111.git.petrm@nvidia.com>
In-Reply-To: <cover.1611156111.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, davem@davemloft.net,
        kuba@kernel.org, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 20 Jan 2021 16:44:09 +0100 you wrote:
> There is currently one policy that covers all attributes for next hop
> object management. Actual validation is then done in code, which makes it
> unobvious which attributes are acceptable when, and indeed that everything
> is rejected as necessary.
> 
> In this series, split rtm_nh_policy to several policies that cover various
> aspects of the next hop object configuration, and instead of open-coding
> the validation, defer to nlmsg_parse(). This should make extending the next
> hop code simpler as well, which will be relevant in near future for
> resilient hashing implementation.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] nexthop: Use a dedicated policy for nh_valid_get_del_req()
    https://git.kernel.org/netdev/net-next/c/60f5ad5e19c0
  - [net-next,v2,2/3] nexthop: Use a dedicated policy for nh_valid_dump_req()
    https://git.kernel.org/netdev/net-next/c/44551bff290d
  - [net-next,v2,3/3] nexthop: Specialize rtm_nh_policy
    https://git.kernel.org/netdev/net-next/c/643d0878e674

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


