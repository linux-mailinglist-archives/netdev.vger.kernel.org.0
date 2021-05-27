Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492853937F4
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 23:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbhE0Vbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 17:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234101AbhE0Vbh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 17:31:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A1EE4613C9;
        Thu, 27 May 2021 21:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622151003;
        bh=5xGvZVl0h7315PX1xfh07jKqh6lssPh/SWwwSf1GUw8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ct0AVgte52OZfNCWKwfOFGhhMcXpywHKMIl/Dcyt2aum9bzsJ5/KnoSm7eYGsA0IF
         TQDWyXf5VDGkXH8KP4tN4WSSB7ZMUv5Tf4PxJ6tcgK6LaTfN68OkNFkCKDjDqp6/zq
         X7Dhb2XUlB3A/jMm3xWuURSY58FkXbLy6+4HPZ0y0HvgfY616UG7iN7fTZTNf2RR4d
         LlPphWJhqc4YlfWFJOH1X3TDedAUjtj9+eCkTvkIMU67WJWIOuyF48vSF9AdhCQK+M
         4jH8XjBdpq/3h96riBEtleD7Jmg01L4Z71ftONT88KXg3t1NlDWZeKSPBfXeSY34zD
         SyZLD4qfML3xw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 95AF7609F5;
        Thu, 27 May 2021 21:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v2] devlink: append split port number to the port
 name
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162215100360.12583.10419235646821072826.git-patchwork-notify@kernel.org>
Date:   Thu, 27 May 2021 21:30:03 +0000
References: <20210527104819.789840-1-jiri@resnulli.us>
In-Reply-To: <20210527104819.789840-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mlxsw@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 27 May 2021 12:48:19 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Instead of doing sprintf twice in case the port is split or not, append
> the split port suffix in case the port is split.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] devlink: append split port number to the port name
    https://git.kernel.org/netdev/net-next/c/f285f37cb1e6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


