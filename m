Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DF83F8623
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241962AbhHZLKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231406AbhHZLKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 07:10:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D02946109F;
        Thu, 26 Aug 2021 11:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629976205;
        bh=RTSwcD8URAYDVHqsI7dBD865ACJF8UnfqXP0gxYuL1g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ah6SGIv85ojUvzojD9P9jH4EVSwp6VEycpB5kSuWYiSKaOq+ZW1E6xlAqa6qvTk1N
         7WDUSWbYTIMONfsXIejA72agTRt12vD+kpJTZhK0Y2q551CzUv2snS0taGd4QaVaoZ
         VC70ky4tsIrArOcf6IMzJ46VlGbdwhH86G07iXHXGeBZjvUsNXLS4M7cNeEAZUgxob
         xoqWjS3yaaD500lFE3kqffmOsh86hOINzSy2u9Ro40rg63IchiI9kRffSc+Q6L1jl8
         G/FWdA62LjyQ8pyRW4qDI/L3OQIomR+uYLxjyWv/lKZue0YHeVgE4qmyKvS93d/Dnv
         +Dp+tJtKfufjw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C53CE60A12;
        Thu, 26 Aug 2021 11:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rtnetlink: Return correct error on changing device netns
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162997620580.12775.6259801272136587447.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Aug 2021 11:10:05 +0000
References: <20210826002540.11306-1-rdna@fb.com>
In-Reply-To: <20210826002540.11306-1-rdna@fb.com>
To:     Andrey Ignatov <rdna@fb.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ebiederm@xmission.com, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 25 Aug 2021 17:25:40 -0700 you wrote:
> Currently when device is moved between network namespaces using
> RTM_NEWLINK message type and one of netns attributes (FLA_NET_NS_PID,
> IFLA_NET_NS_FD, IFLA_TARGET_NETNSID) but w/o specifying IFLA_IFNAME, and
> target namespace already has device with same name, userspace will get
> EINVAL what is confusing and makes debugging harder.
> 
> Fix it so that userspace gets more appropriate EEXIST instead what makes
> debugging much easier.
> 
> [...]

Here is the summary with links:
  - [net] rtnetlink: Return correct error on changing device netns
    https://git.kernel.org/netdev/net/c/96a6b93b6988

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


