Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D379423FF2
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238960AbhJFOWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238832AbhJFOWA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 10:22:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F380A61212;
        Wed,  6 Oct 2021 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633530008;
        bh=DfS+HcRP041Um9Ci6sK0gVX3hcF+M1et5Y57ysL+ngY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FKU2kqr8iRFyCKVM+qo4HUkri2RBoS9gJGjKcdHaCHU09TFxVWGqb1myvQnxG2Qnx
         QPkF4ryLw6GUi1abmZ/9KM2QHkOMU2YadqwyTk7hF9ourGYGD69gV3+yPkOn7SpQx0
         DYYBru8khcGzLLqfsTzJl8xHEvEjbC0gPHSASiAipwfa7ikfLLlVQWVt2W44X9nWQU
         a1PH3lV59LNGZjVoJDR5sU7K1pOSfdoNsEly7FVTJi0sI9Wcy1U3I5wBMGBYvuGBAW
         AqQhtgXBusOqE1a/iNssWpLeRtVFNJB7X10tc9xc5tztoUte5D+RbARu4pJyjaB9dp
         5qsy4EIQkwTqg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EE78E609F4;
        Wed,  6 Oct 2021 14:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] gtp: use skb_dst_update_pmtu_no_confirm() instead of
 direct call
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163353000797.15249.17539810847769225450.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Oct 2021 14:20:07 +0000
References: <20211006035739.5377-1-kyeongun15@gmail.com>
In-Reply-To: <20211006035739.5377-1-kyeongun15@gmail.com>
To:     Gyeongun Kang <kyeongun15@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  6 Oct 2021 03:57:39 +0000 you wrote:
> skb_dst_update_pmtu_no_confirm() is a just wrapper function of
> ->update_pmtu(). So, it doesn't change logic
> 
> Signed-off-by: Gyeongun Kang <kyeongun15@gmail.com>
> ---
>  drivers/net/gtp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] gtp: use skb_dst_update_pmtu_no_confirm() instead of direct call
    https://git.kernel.org/netdev/net-next/c/5b71131b795f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


