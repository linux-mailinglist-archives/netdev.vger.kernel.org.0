Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5D83590A5
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 01:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhDHXus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 19:50:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232793AbhDHXuj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 19:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AB13C610F8;
        Thu,  8 Apr 2021 23:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617925827;
        bh=F0uP/nWIdK+V6oyBdJT4pqjUo8NRNN3upI17deigMdg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J2HgrMI1lQOIkUsYhQkTp9OpJKHBahC3silK+rCND8XenJo7916nmDnJf+9lff0s4
         fbyYFBfRB4Hd6IJ4XvBlTiKQRnC9sI/3eg0wfI4ihgCUoEH1LKthZZHIIuzMJf2Iqc
         KvMCVJO2iMOE2gfwbmJSFEsAXRqyTQU4pS17PrDMrcIjAsoEv7hhanP06hAsg0XusZ
         mR/53AJzBJdya6C9Jna84HZ0qU6+KBoupflmwO/VOFbSs04/4+FzVd1PwF9/7DGbA/
         hbYo84RNDuWQwcMK404YU4nQM88rd9jMjfaQhRlaFOpsl1dwx0J1BBtWVfNselUKKu
         FZtzlsSxX5X6A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9AC7A60975;
        Thu,  8 Apr 2021 23:50:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipv6: check for validity before dereferencing
 cfg->fc_nlinfo.nlh
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161792582762.13386.8901145268048636141.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Apr 2021 23:50:27 +0000
References: <20210408220129.GA3111136@LEGION>
In-Reply-To: <20210408220129.GA3111136@LEGION>
To:     Muhammad Usama Anjum <musamaanjum@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        colin.king@canonical.com, dan.carpenter@oracle.com,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 9 Apr 2021 03:01:29 +0500 you wrote:
> nlh is being checked for validtity two times when it is dereferenced in
> this function. Check for validity again when updating the flags through
> nlh pointer to make the dereferencing safe.
> 
> CC: <stable@vger.kernel.org>
> Addresses-Coverity: ("NULL pointer dereference")
> Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: ipv6: check for validity before dereferencing cfg->fc_nlinfo.nlh
    https://git.kernel.org/netdev/net/c/864db232dc70

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


