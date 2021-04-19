Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CBE364EC0
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 01:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhDSXkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 19:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231434AbhDSXkk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 19:40:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 97829613AA;
        Mon, 19 Apr 2021 23:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618875609;
        bh=KcP3mEy3CC1wS91hCALZJsCUsWIOaevh62AbdE4pjto=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BrhsPm4lBMMs9J3CzrKCltEihtQrD9Oofpi4nJIbUDYd27oI8ia2ED0uClBcVT7Mz
         nD8ESUvMwUWpwUZMlypXzJ9u8qf1cORKYbL/Kxqlnchgwa4Z04doRQb4y4lTwKuhDN
         TF5ljgmepP4tiJRe9jyNSTAExPIp1yGwKIhRdnEf/k8mJ3kIZb1lTVD7PtjIZalUcn
         ynrMV7sOnJ62I9J1QW7sES22tZ7TQe8gIYOOV7pwq8phfzjnkqKC/gkeyDubkSKCUv
         AOG+c5rucUKM6gCL/aDK9JNR7NZ04RiOxX5856ZNNDqNFc32ura62xEwC0GEfji2x3
         /poEd11jb3Q9g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 91A596096F;
        Mon, 19 Apr 2021 23:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] ethtool: add missing EEPROM to list of messages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887560959.13803.2063484320793069423.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 23:40:09 +0000
References: <20210419215235.3075587-1-kuba@kernel.org>
In-Reply-To: <20210419215235.3075587-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz,
        andrew@lunn.ch, corbet@lwn.net, vladyslavt@nvidia.com,
        linux-doc@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Apr 2021 14:52:35 -0700 you wrote:
> ETHTOOL_MSG_MODULE_EEPROM_GET is missing from the list of messages.
> ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY is sadly a rather long name
> so we need to adjust column length.
> 
> v2: use spaces (Andrew)
> 
> Fixes: c781ff12a2f3 ("ethtool: Allow network drivers to dump arbitrary EEPROM data")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] ethtool: add missing EEPROM to list of messages
    https://git.kernel.org/netdev/net-next/c/e9377a911d77

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


