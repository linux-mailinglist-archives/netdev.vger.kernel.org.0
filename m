Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB6C3A1ED9
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhFIVWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229685AbhFIVWA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 17:22:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 60DB0613F3;
        Wed,  9 Jun 2021 21:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623273605;
        bh=gSN1wGF/MRy6AgJ4HBMTV/lUHDh9chnxhC3rpbLQMi0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rVUGk08JtrqZi4aeKCCZPrlhcTyNOZpP19JxlGvISOj0EuAwjsWkosCyPqc8HCEoB
         AOKuf6p8gH6o9HtmFuWcX3y5BRTYcGQGspZ5B++Z9bMc0MEIYo9fWtEhwrfEylRciD
         WicaWS+wb9wrfoG5SLRwU1DeCFg7ujsSW8NHtPNcq9hDXvVBqEZmCX1MEzILE0Y5OU
         oBA7YvtaBGe3IjmbutaNYI9HkozVNB0Kquul4wuD8qSF0fMrocixUsHkWCnNxupH9Y
         aoXCVtvItmIbzB5KVexTW1pqhi5bJuGUEnEh7EZ2HwZe5JcjQMa8bsKWB8rRSrduCc
         xn/1T49LMBdLw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 529BD609E3;
        Wed,  9 Jun 2021 21:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: Fix error message in
 devlink_rate_set_ops_supported()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327360533.22106.4908263048090880494.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 21:20:05 +0000
References: <YMCP1wJ6+e2E1n4m@mwanda>
In-Reply-To: <YMCP1wJ6+e2E1n4m@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     jiri@nvidia.com, dlinkin@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, vladbu@nvidia.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 9 Jun 2021 12:54:31 +0300 you wrote:
> The WARN_ON() macro takes a condition, it doesn't take a message.  Use
> WARN() instead.
> 
> Fixes: 1897db2ec310 ("devlink: Allow setting tx rate for devlink rate leaf objects")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  net/core/devlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] devlink: Fix error message in devlink_rate_set_ops_supported()
    https://git.kernel.org/netdev/net-next/c/711d1dee1c86

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


