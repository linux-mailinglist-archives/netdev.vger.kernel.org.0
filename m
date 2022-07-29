Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0956584F79
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 13:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbiG2LUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 07:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235954AbiG2LUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 07:20:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAACC48;
        Fri, 29 Jul 2022 04:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 774F9CE2924;
        Fri, 29 Jul 2022 11:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB994C43140;
        Fri, 29 Jul 2022 11:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659093614;
        bh=vK2RkOC7/ydllQXE7Z4Mds0spqe58v62xZz1UnjLPmg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Wn/5eL7Fw02fIotjFYRrXyls7P+4PfZIT2VJx/I99ZCdXxs5QnF3gu4FuOO4KPNQe
         jIx0LXMflMJgwMMey2Rm1LTkLFLYHmDN/fvkMT0lZCR0N8WvuKS55dnq+wg9ojLm0E
         nyfM1YqBwGZlzf/hqYMyiVmVBaGD+9Anlj7C5VY/vY4JSdS+I2hGt4V4+pzT9BbroX
         +LNQU7bLqJBN0sn5pnPnOt5fC/q9nIO0NKRcCaoqRaRDBbQlKBvhyQcovWRCYHbnW7
         KfUVJ0syRi0mmhW9+5FM/sYgUdykPz+p+Uk44JFS4JsicvEW1X9lzj+vzM5ro2FBAU
         CBN3vWSkExDgA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9392EC43140;
        Fri, 29 Jul 2022 11:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] vmxnet3: do not reschedule napi for rx processing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165909361460.23060.5741584773905639259.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 11:20:14 +0000
References: <20220727173038.9951-1-doshir@vmware.com>
In-Reply-To: <20220727173038.9951-1-doshir@vmware.com>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     netdev@vger.kernel.org, pv-drivers@vmware.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gyang@vmware.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Jul 2022 10:30:37 -0700 you wrote:
> Commit '2c5a5748105a ("vmxnet3: add support for out of order rx
> completion")' added support for out of order rx completion. Within
> that patch, an enhancement was done to reschedule napi for processing
> rx completions.
> 
> However, it can lead to missing an interrupt. So, this patch reverts
> that part of the code.
> 
> [...]

Here is the summary with links:
  - [net-next] vmxnet3: do not reschedule napi for rx processing
    https://git.kernel.org/netdev/net-next/c/5b91884bf50b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


