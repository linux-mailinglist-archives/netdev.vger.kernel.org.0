Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5676148D820
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 13:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbiAMMkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 07:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiAMMkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 07:40:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6225CC06173F
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 04:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23942B8226B
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7895C36AE9;
        Thu, 13 Jan 2022 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642077610;
        bh=b9TFXylpdVM3DFpvuqH0V58mLdofGU+Z+5LZrd8BUW8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kOMBIu8Zb/7JFn9fB7LTVq0Cye7EDwEY3meJXIPXrVqjCnNWj9yjjFD77l0nkFaSD
         yOEIWr8+CUZI69wJhutLjxBCmpySTJcqC9vlcGxb0jWLdYoEkLMhuyedGuBZ1bWJN8
         luLq1L5x2xzw3OV6ZsVq9V0neOo4KcFRsHOh0T26KKPI6E/sbA7v5uxTfrQ6oaclCF
         1hQdmgHTX9uASADQ6SnT1ibHDmltGsZpGxaRt575BKQDec/PZLKPHvuFisH75jW3ZW
         FywEh8U2g9rYSzk/+GEUzBosMz2Bll8P8QotHunK8/8w8uCeSsrWdcz/cInjco5i7C
         86gTYCtwqWFHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D201BF6079B;
        Thu, 13 Jan 2022 12:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sch_api: Don't skip qdisc attach on ingress
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164207760985.15302.5418949660280999123.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Jan 2022 12:40:09 +0000
References: <20220112102805.488510-1-maximmi@nvidia.com>
In-Reply-To: <20220112102805.488510-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     edumazet@google.com, eric.dumazet@gmail.com, davem@davemloft.net,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, tariqt@nvidia.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 12 Jan 2022 12:28:05 +0200 you wrote:
> The attach callback of struct Qdisc_ops is used by only a few qdiscs:
> mq, mqprio and htb. qdisc_graft() contains the following logic
> (pseudocode):
> 
>     if (!qdisc->ops->attach) {
>         if (ingress)
>             do ingress stuff;
>         else
>             do egress stuff;
>     }
>     if (!ingress) {
>         ...
>         if (qdisc->ops->attach)
>             qdisc->ops->attach(qdisc);
>     } else {
>         ...
>     }
> 
> [...]

Here is the summary with links:
  - sch_api: Don't skip qdisc attach on ingress
    https://git.kernel.org/netdev/net/c/de2d807b294d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


