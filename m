Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E26334B1F6
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 23:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhCZWKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 18:10:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229933AbhCZWKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 18:10:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0FABF61A2A;
        Fri, 26 Mar 2021 22:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616796617;
        bh=E69KSmfMKhEtJaP3RSCZEN/QecyIm2u/dGnaoIXMpDA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cMV006TogLLxwXJe17pNxaFSPzhzAoNONBoGExFhfzqgUAhv/vMlGpz0H58IAKexb
         TN15JjNFnVwfHEwK/nqDEiQxII82ZHlWXHHQ/5WzLjf/D0EgJqXvpf1zWlw2dyOcgt
         uU8Si8k2VzdgvYpHhsh+hK75y7+HbRY61N/GFSVjpj9kHDWwa15IUI0NPkR9GoiotN
         mTJrHefwAun/hds2pkdKbJopwLRXXFr6WL5FkAMX4/YiMwEu8AyQ+KFQlX3w9qc9lg
         h46J0tEOC+XS0SowC03ZXxJP0vixM3i6MpPkBgyxsYM4KL8YP9EGuPxo4C9cbu/OXY
         RVchQHQW7Vz6g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CA280609E6;
        Fri, 26 Mar 2021 22:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12] net: ipa: rework resource programming
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161679661682.26244.16042690009163360291.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 22:10:16 +0000
References: <20210326151122.3121383-1-elder@linaro.org>
In-Reply-To: <20210326151122.3121383-1-elder@linaro.org>
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

On Fri, 26 Mar 2021 10:11:10 -0500 you wrote:
> This series reworks the way IPA resources are defined and
> programmed.  It is a little long--and I apologize for that--but
> I think the patches are best taken together as a single unit.
> 
> The IPA hardware operates with a set of distinct "resources."  Each
> hardware instance has a fixed number of each resource type available.
> Available resources are divided into smaller pools, with each pool
> shared by endpoints in a "resource group."  Each endpoint is thus
> assigned to a resource group that determines which pools supply
> resources the IPA hardware uses to handle the endpoint's processing.
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] net: ipa: introduce ipa_resource.c
    https://git.kernel.org/netdev/net-next/c/ee3e6beaa015
  - [net-next,02/12] net: ipa: fix bug in resource group limit programming
    https://git.kernel.org/netdev/net-next/c/a749c6c03762
  - [net-next,03/12] net: ipa: identify resource groups
    https://git.kernel.org/netdev/net-next/c/47f71d6e677c
  - [net-next,04/12] net: ipa: add some missing resource limits
    https://git.kernel.org/netdev/net-next/c/9ab7e7288266
  - [net-next,05/12] net: ipa: combine resource type definitions
    https://git.kernel.org/netdev/net-next/c/fd2b7bc32113
  - [net-next,06/12] net: ipa: index resource limits with type
    https://git.kernel.org/netdev/net-next/c/4bcfb35e7af9
  - [net-next,07/12] net: ipa: move ipa_resource_type definition
    https://git.kernel.org/netdev/net-next/c/cf9a10bd7c49
  - [net-next,08/12] net: ipa: combine source and destination group limits
    https://git.kernel.org/netdev/net-next/c/d9d1cddf8b98
  - [net-next,09/12] net: ipa: combine source and destation resource types
    https://git.kernel.org/netdev/net-next/c/7336ce1a7ae7
  - [net-next,10/12] net: ipa: pass data for source and dest resource config
    https://git.kernel.org/netdev/net-next/c/93c03729c548
  - [net-next,11/12] net: ipa: record number of groups in data
    https://git.kernel.org/netdev/net-next/c/4fd704b3608a
  - [net-next,12/12] net: ipa: support more than 6 resource groups
    https://git.kernel.org/netdev/net-next/c/3219953bedc5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


