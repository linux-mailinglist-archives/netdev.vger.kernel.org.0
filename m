Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF78494D1E
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiATLkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiATLkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:40:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98ECC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 03:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 567D06165E
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 11:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6654C340E5;
        Thu, 20 Jan 2022 11:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642678809;
        bh=yKnNroBzJ7DmEQ2A4CHSGGUNWBD2FCt0F/ZhPbNnX4I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m73+0XzRNHvM9zRky/3AmCfSDWepexO2DwWM9jDwtEOiykperh6qFcHievGjbHNlW
         Jvy8IDUyfqT95jaMYVCchsZT3s8A5nJaZWSj9+mnN0JbIDk8AdSdK+nHO3pxvROxWb
         uWFrCCEkvRq5G0m+E4bbXr5Ga531ejY9w0gDYVa9KPYYo8MP8r51eCcOOKMJ4owtGH
         8zQ71uYLnzwS9TtT+rIhxjcEbBkXnbtijK6MLg8yVOznB2jaheSE0nAPWUre2GgTR7
         THNg1JDwvmJ3bKMS84xar4dy4FAczMhMFdHXsXZAvX/fRFR3sPE80wZ/J19d9Sdd4Y
         K469k7ozzxejQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8AF77F6079B;
        Thu, 20 Jan 2022 11:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6_tunnel: Rate limit warning messages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164267880956.20064.4642518907540320828.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Jan 2022 11:40:09 +0000
References: <20220120080546.1733332-1-idosch@nvidia.com>
In-Reply-To: <20220120080546.1733332-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org, vnuorval@tcs.hut.fi,
        mlxsw@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 20 Jan 2022 10:05:46 +0200 you wrote:
> The warning messages can be invoked from the data path for every packet
> transmitted through an ip6gre netdev, leading to high CPU utilization.
> 
> Fix that by rate limiting the messages.
> 
> Fixes: 09c6bbf090ec ("[IPV6]: Do mandatory IPv6 tunnel endpoint checks in realtime")
> Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
> Tested-by: Maksym Yaremchuk <maksymy@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net] ipv6_tunnel: Rate limit warning messages
    https://git.kernel.org/netdev/net/c/6cee105e7f2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


