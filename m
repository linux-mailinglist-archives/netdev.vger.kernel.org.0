Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E349455B45
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 13:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344544AbhKRMNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 07:13:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344558AbhKRMNJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 07:13:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6486F613B1;
        Thu, 18 Nov 2021 12:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637237409;
        bh=wKd64XmNjusL5yxTUQ+3VyQzvQcvVhwUtjhGaUR498o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cm06SYnaHlkeePSA6ELglKUq7Pl21KbkBCHl834wjvfD7sojT5bMVx5/EW+/rvrcK
         dUIt81rzWhZ/5zTOFHlIID5SaqaRjWUShCHmSX8eIBXtJKzc6iUuPctWTBguG/Nxr3
         J51CYiQnvclY3JHehEwQL4qJNcxwr7ERFH/ZUPKGnDNupbVKSK+mGVIZ8VTtN9HXOY
         R580OcMh1RkoVmjVzXMJj81s75Y4OEpgy36azfZECpWj9CYtulpWFZ/Bd7Guxs/9Nr
         lj3u2ita7oaXIjASYc8w/nxejN3qmR6JSVoxijXNiLGqa3vv+uQUTRzhxHAedXSR7y
         v6Jg6bfir9kww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 578DD60A94;
        Thu, 18 Nov 2021 12:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: ethernet: dec: tulip: de4x5: fix possible array
 overflows in type3_infoblock()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723740935.26371.8164804741918888412.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 12:10:09 +0000
References: <20211118070118.63756-1-starmiku1207184332@gmail.com>
In-Reply-To: <20211118070118.63756-1-starmiku1207184332@gmail.com>
To:     Teng Qi <starmiku1207184332@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, tanghui20@huawei.com,
        arnd@arndb.de, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, islituo@gmail.com, oslab@tsinghua.edu.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 15:01:18 +0800 you wrote:
> The definition of macro MOTO_SROM_BUG is:
>   #define MOTO_SROM_BUG    (lp->active == 8 && (get_unaligned_le32(
>   dev->dev_addr) & 0x00ffffff) == 0x3e0008)
> 
> and the if statement
>   if (MOTO_SROM_BUG) lp->active = 0;
> 
> [...]

Here is the summary with links:
  - [v2] net: ethernet: dec: tulip: de4x5: fix possible array overflows in type3_infoblock()
    https://git.kernel.org/netdev/net/c/0fa68da72c3b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


