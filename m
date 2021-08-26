Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0EE13F8626
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242059AbhHZLK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241931AbhHZLKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 07:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8FE71610E6;
        Thu, 26 Aug 2021 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629976206;
        bh=tZ00pHtG0BeuLqX4paMIhLFl0dwa8Qbe5no/sxax62I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eADwo/aNCj+TTMbMtSCxJxciEm++5mJVp6NVYeFzm7pul5wb9rWRzI/wQb2jczPWk
         VUNDSb0O1UCcISFY0vvgty3OkXmFbMRFol83eM+IvxfxOASctFqOw9FDTCwGwSyiRK
         apKPb+wDRbQzgU7V8GqkHNoO7ly07mcr7p+zpAdFxwhacjxSJIGqn5m4jq49Fvq82r
         Cz/wlW4OdyAHPLNMoEEnKBndp97AakJD6WiOIk1z7MkwpdZL+/TXprMoR0ZJynj96k
         ac/+YVhuaZU+lDyF74n301pen/11xvAES6yJ784cN6f83QUpkmlO0lHVj0xJgKSvsS
         cY7CwB092Uzaw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 87A01609EA;
        Thu, 26 Aug 2021 11:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] selftests/net: allow GRO coalesce test on veth
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162997620655.12775.16598558123282113773.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Aug 2021 11:10:06 +0000
References: <529bc61a01c28fbe883ec079cf256070e969b98f.1629963020.git.pabeni@redhat.com>
In-Reply-To: <529bc61a01c28fbe883ec079cf256070e969b98f.1629963020.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        shuah@kernel.org, lixiaoyan@google.com, willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 26 Aug 2021 09:30:42 +0200 you wrote:
> This change extends the existing GRO coalesce test to
> allow running on top of a veth pair, so that no H/W dep
> is required to run them.
> 
> By default gro.sh will use the veth backend, and will try
> to use exiting H/W in loopback mode if a specific device
> name is provided with the '-i' command line option.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] selftests/net: allow GRO coalesce test on veth
    https://git.kernel.org/netdev/net-next/c/9af771d2ec04

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


