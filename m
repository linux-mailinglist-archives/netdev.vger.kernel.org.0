Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822DC43E0B5
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 14:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhJ1MWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 08:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhJ1MWj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 08:22:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C51ED610FC;
        Thu, 28 Oct 2021 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635423612;
        bh=KV9HW++Awb87qOKeQH7yUus29kx2pGAgSC7R+wH8U0c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F6o8m+kmmapKAOWC2Zlv/FNenOHVNmNi/OIPdHCwrsa2kLvUlSLgJ+90O65g7kpJF
         tQkEoRS0ZB0kEbEHN6xXuzzFWxt6ts9cb7o5XiVqRt6nYO6EP7IaMosKBu5Gx7xFY2
         id3GIjEMNUl+Q31apcNc1WQcLRnpRmGURil4CIjpZ4jTueixmAoggvqdLPMJlr7Qrt
         ZXS/ve9j/C4qxWq3ApVZxc+LbdB08zn+wMTWYlhawnHfwMWJOq4VDRFqP77FO9h9b/
         LlZACzWab+hx2XXbh8hUlE5x9zHLKULiBmvNsytKgupSHP1tM5nXRquUjdB270NMds
         1hSic+9zxytVQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BA62F60987;
        Thu, 28 Oct 2021 12:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] ipv6: enable net.ipv6.route.max_size sysctl in network
 namespace
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542361275.29870.17918604652975516735.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 12:20:12 +0000
References: <20211027080008.57044-1-wwfq@yandex-team.ru>
In-Reply-To: <20211027080008.57044-1-wwfq@yandex-team.ru>
To:     Alexander Kuznetsov <wwfq@yandex-team.ru>
Cc:     netdev@vger.kernel.org, zeil@yandex-team.ru, davem@davemloft.net,
        ebiederm@xmission.com, dmtrmonakhov@yandex-team.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Oct 2021 11:00:08 +0300 you wrote:
> We want to increase route cache size in network namespace
> created with user namespace. Currently ipv6 route settings
> are disabled for non-initial network namespaces.
> We can allow this sysctl and it will be safe since
> commit <6126891c6d4f> because route cache account to kmem,
> that is why users from user namespace can not DOS system.
> 
> [...]

Here is the summary with links:
  - [v2] ipv6: enable net.ipv6.route.max_size sysctl in network namespace
    https://git.kernel.org/netdev/net-next/c/06e6c88fba24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


