Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033B9494CFE
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiATLaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:30:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55844 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiATLaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE13CB81D2F
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 11:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36662C340E5;
        Thu, 20 Jan 2022 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642678210;
        bh=lBQ7cwzxXDV7jfTFlMn9SKkOMdaVwNAQfZOZdsut+CQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Df4UqLQxAK6kjaiSMzDOtERmFLmU8IH//P90SirM0rtfSFsf++9iwojNQB/okFLOa
         7q+CSgatuSTeDGRuDZ+Ik5rluNUicCaN1501TRj1MsnIp5hrpmLey9YRbrCqU0j+f2
         NXhJ2dPKoa33PjXOyw6IphUMA4xAjxU1QH9NTNvVuw3KSdCTvmoLzm9VABljlXcvkH
         2QlwHD/bcOFKcltF9+SoU/WDEim66AjpuCx7HjtTjmzwjM/nfWG/u46AsnUfGuxxAs
         ob/ITxFReSq6FIvVVirtnBSYs3/ZTt0Unt0urucXNybK+G+3z7xuvSfgaXbU0c5UJR
         HeR9HoQJNUdCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C867F6079B;
        Thu, 20 Jan 2022 11:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: Clarify error message when qdisc kind is
 unknown
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164267821011.14873.185387662344856992.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Jan 2022 11:30:10 +0000
References: <20220118171909.4375-1-victor@mojatatu.com>
In-Reply-To: <20220118171909.4375-1-victor@mojatatu.com>
To:     Victor Nogueira <victor@mojatatu.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        kernel@mojatatu.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 18 Jan 2022 14:19:09 -0300 you wrote:
> When adding a tc rule with a qdisc kind that is not supported or not
> compiled into the kernel, the kernel emits the following error: "Error:
> Specified qdisc not found.". Found via tdc testing when ETS qdisc was not
> compiled in and it was not obvious right away what the message meant
> without looking at the kernel code.
> 
> Change the error message to be more explicit and say the qdisc kind is
> unknown.
> 
> [...]

Here is the summary with links:
  - [net-next] net: sched: Clarify error message when qdisc kind is unknown
    https://git.kernel.org/netdev/net/c/973bf8fdd12f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


