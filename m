Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876EF306B41
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 03:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhA1Cuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 21:50:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231171AbhA1Cuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 21:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E609064DD6;
        Thu, 28 Jan 2021 02:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611802210;
        bh=vii+OCZ5Nl2HePoyD10UsBIj2kCrR8hpfV4ficfZ7w8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SvPVAwdccF0zoNRlq0q/7mQMXiBM89Xjp71jYn/2Lx+gL1nfZhTeY0v9L5VXqOK/C
         rZIOh4CfJgYiymWwSRMJ5YajsHgGp9R1iJngG4Egn4/wXFV8NWA4emWilxZzxdFiIm
         58kumg8BoJJqjuIKkMN4GhhJgLKSHVB2IctI6ulb3PcLHSE1oqz6qk2udtH8BGVl82
         iyonObTU70Qq0rVqQhg9eZsu+2zTnLiK0MpIQXsQe4jBIDGJVF3sCTq+xjjhNbTbTQ
         gSlduQ/ZwnB6oDqhpCKUnr/vMAuqPiT8XThASXWWEWEishjrZ/zhkalVH+yq5AKFUW
         lZfBq/ZS1yH5Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D584961E3D;
        Thu, 28 Jan 2021 02:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] net: bridge: multicast: per-port EHT hosts
 limit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161180221086.27895.14934580567433280199.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 02:50:10 +0000
References: <20210126093533.441338-1-razor@blackwall.org>
In-Reply-To: <20210126093533.441338-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 26 Jan 2021 11:35:31 +0200 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> This set adds a simple configurable per-port EHT tracked hosts limit.
> Patch 01 adds a default limit of 512 tracked hosts per-port, since the EHT
> changes are still only in net-next that shouldn't be a problem. Then
> patch 02 adds the ability to configure and retrieve the hosts limit
> and to retrieve the current number of tracked hosts per port.
> Let's be on the safe side and limit the number of tracked hosts by
> default while allowing the user to increase that limit if needed.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: bridge: multicast: add per-port EHT hosts limit
    https://git.kernel.org/netdev/net-next/c/89268b056ed1
  - [net-next,v2,2/2] net: bridge: multicast: make tracked EHT hosts limit configurable
    https://git.kernel.org/netdev/net-next/c/2dba407f994e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


