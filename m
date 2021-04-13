Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA28735E8D2
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348575AbhDMWKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345636AbhDMWKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 18:10:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EDC50613B1;
        Tue, 13 Apr 2021 22:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618351811;
        bh=ES92U478LsUAZ5S3F/H03niMG8FN6Wmv5Rkq27dcdxs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JHujBMq++8ehWyGN4DQcS0qrWHiQvxTNDON8Vs4UEZs1L8f0jfyxqRbd7656u7Yua
         cUYcuaJUAlcMnUalAh7UiJmIkOEhYA+TEywP3iu+7AqqPAVw3bCKHFAiNtqxnaL9L1
         oW2bVF4ju+GgxdCSx7VWlg3aNycLxkxVTm7RBnjBR0yCU1wtgfygBZDOygg0Mj6u7U
         t0LjvjngxeLHcQUmdyBnbYAqrVule+5iDVpsFZ5rbKY4o57YRdyMLKHboE5cbFfOxb
         Z6smv7MlmGc/lFPJRvf4JeKVahRkfbtUhT2yFTliyOrf1I8Orw7q1DqLaAxo6+zVnu
         XOqoGz1Iu/q6Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E308260CD1;
        Tue, 13 Apr 2021 22:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ionic: return -EFAULT if copy_to_user() fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835181092.31494.8890436906955463778.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 22:10:10 +0000
References: <YHV230jUzxBJxlPS@mwanda>
In-Reply-To: <YHV230jUzxBJxlPS@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     snelson@pensando.io, drivers@pensando.io, davem@davemloft.net,
        kuba@kernel.org, allenbh@pensando.io, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 13 Apr 2021 13:47:59 +0300 you wrote:
> The copy_to_user() function returns the number of bytes that it wasn't
> able to copy.  We want to return -EFAULT to the user.
> 
> Fixes: fee6efce565d ("ionic: add hw timestamp support files")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_phc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] ionic: return -EFAULT if copy_to_user() fails
    https://git.kernel.org/netdev/net-next/c/5871d0c6b8ea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


