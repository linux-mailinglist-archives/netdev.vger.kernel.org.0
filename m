Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C049938972B
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 22:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbhESUBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 16:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230431AbhESUBb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 16:01:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6999D6124C;
        Wed, 19 May 2021 20:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621454411;
        bh=gU/NF9fFRNujsjItbYhLHv9MGDQxq7nmuRurZepASD8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TklWvZoCfcJqSXUs3DNxU3sWN94kIM016wSu3bjPruN7JWiIfmKvqItaQMfKZkL73
         kKLBZotz4sYPcTMonpUXXJ1PpF7q1J27p0ghKHYgaYskZk6FPJ5t5qamZdbHkQj1a5
         boPoOv4ECZk6O5NaZT/rolORqhFrxy0z7ArOPD++tuhLrf6Nn7oNbqpY5psv+qgX4u
         2b/UWhP5pNghMpafj2mdb5IYjCX/fWNBxkJU4/gTUerQUij46MEebI9H1JMYY8EvNw
         5eDP42fF67jgkVRReTHWVFmg+WxmP9s+Bqbx9G6N23LMOgRdJOMWYmpF8tBYByqe20
         w87OQ+kzVKxPw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5852A60A56;
        Wed, 19 May 2021 20:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] mlxsw: Add support for new multipath hash
 policies
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162145441135.5368.1464095854041311423.git-patchwork-notify@kernel.org>
Date:   Wed, 19 May 2021 20:00:11 +0000
References: <20210519120824.302191-1-idosch@idosch.org>
In-Reply-To: <20210519120824.302191-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 19 May 2021 15:08:17 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset adds support for two new multipath hash policies in mlxsw.
> 
> Patch #1 emits net events whenever the
> net.ipv{4,6}.fib_multipath_hash_fields sysctls are changed. This allows
> listeners to react to changes in the packet fields used for the
> computation of the multipath hash.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: Add notifications when multipath hash field change
    https://git.kernel.org/netdev/net-next/c/eb0e4d59b6ed
  - [net-next,2/7] mlxsw: spectrum_router: Replace if statement with a switch statement
    https://git.kernel.org/netdev/net-next/c/7725c1c8f732
  - [net-next,3/7] mlxsw: spectrum_router: Move multipath hash configuration to a bitmap
    https://git.kernel.org/netdev/net-next/c/9d23d3eb6f41
  - [net-next,4/7] mlxsw: reg: Add inner packet fields to RECRv2 register
    https://git.kernel.org/netdev/net-next/c/28bc824807a5
  - [net-next,5/7] mlxsw: spectrum_outer: Factor out helper for common outer fields
    https://git.kernel.org/netdev/net-next/c/b7b8f435ea3b
  - [net-next,6/7] mlxsw: spectrum_router: Add support for inner layer 3 multipath hash policy
    https://git.kernel.org/netdev/net-next/c/01848e05f8bb
  - [net-next,7/7] mlxsw: spectrum_router: Add support for custom multipath hash policy
    https://git.kernel.org/netdev/net-next/c/daeabf89eb89

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


