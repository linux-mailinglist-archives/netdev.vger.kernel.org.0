Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1933838B9B0
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 00:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhETWve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 18:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232018AbhETWvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 18:51:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 70E1760FEE;
        Thu, 20 May 2021 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621551011;
        bh=TlbujBwosZcEbvno1gYcliyLeXQrLT4k1fJ01oFG/Ds=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hpPImhjy1tmSMR3vWg5ANUhlpTt1mwIY8/1yMvL4Ex2OzGJHK3VohkI8kTo8Flwr0
         lYg1REwcG97UqJSKgENvT4Dn4nd+PJFFt5ySAK7HfZiuYHqZ1WBW1w0adybGC5U/ap
         dTAg4/RTMYiQGcEaqb90E7PSjJqI1tKKOGV8UKcLBCTYQS6skFXTTihklQtAt19NyK
         AK5rwAXRbCJHdf1QtG28e8dvLMruq9GlQIoaa3T7a1MuoGCQf1Lci5IBVcoR1Bw+R8
         oEkwqky8NIIzugdsTEC5b14WpNt/+0+oXgm6d7PaaO5k+7F5hpoROMIjfuszUj/cxp
         uKKuF9qHu4e8A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6B80060982;
        Thu, 20 May 2021 22:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: bonding: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162155101143.27401.18427129434670481232.git-patchwork-notify@kernel.org>
Date:   Thu, 20 May 2021 22:50:11 +0000
References: <1621491515-53459-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1621491515-53459-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        tanhuazhong@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 20 May 2021 14:18:31 +0800 you wrote:
> This patchset cleans up some code style issues.
> 
> Yufeng Mo (4):
>   net: bonding: add some required blank lines
>   net: bonding: fix code indent for conditional statements
>   net: bonding: remove unnecessary braces
>   net: bonding: use tabs instead of space for code indent
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: bonding: add some required blank lines
    https://git.kernel.org/netdev/net-next/c/86a5ad0a4608
  - [net-next,2/4] net: bonding: fix code indent for conditional statements
    https://git.kernel.org/netdev/net-next/c/8ce390bb9859
  - [net-next,3/4] net: bonding: remove unnecessary braces
    https://git.kernel.org/netdev/net-next/c/52333512701b
  - [net-next,4/4] net: bonding: use tabs instead of space for code indent
    https://git.kernel.org/netdev/net-next/c/97a1111d9ca6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


