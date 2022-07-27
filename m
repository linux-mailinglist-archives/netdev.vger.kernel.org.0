Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5AB5826A1
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiG0MbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbiG0Max (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:30:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1E9DED8;
        Wed, 27 Jul 2022 05:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28979B82079;
        Wed, 27 Jul 2022 12:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6F86C43141;
        Wed, 27 Jul 2022 12:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658925014;
        bh=f5AJxP6vd3oTSMKZOl9+kEqsHXwzsoOifz5qBPWfD6g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MQ6DajxM+o3xZuNlbsi4rXGCEO7sXnCWCuRqoSFvARa+tMw2bspiwIilAZWUpuF57
         iIy9379M9frHKYuqRfFdgehcLn88ivpZBb/7recb4OIX9J3160PkIRTbS+4vSW5kHB
         Hxk/CY6i2DUpf2oJvrV9b0ZaPWEYfI6pw8gHehOKB914KBdgM2B9J+8UDWjrtR9133
         gsMNeY8fD2tJ+pM131T37ELzznJrD7sZhiEZzef9VfB5dHZTOC5SwW7ClSGhRFhIAj
         9QRKiogO6ZwocTevfnwKrfUL7hEnmbeMl2oSS57Q8Dcz5e8cv58UA8Sv/sdr4Vpcgj
         fw8C9Iu2seLdw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3208C43143;
        Wed, 27 Jul 2022 12:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net/smc: updates 2022-7-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165892501479.3549.10641686148790679354.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jul 2022 12:30:14 +0000
References: <20220725141000.70347-1-wenjia@linux.ibm.com>
In-Reply-To: <20220725141000.70347-1-wenjia@linux.ibm.com>
To:     Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        kgraul@linux.ibm.com, wintera@linux.ibm.com, raspl@linux.ibm.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Jul 2022 16:09:56 +0200 you wrote:
> Hi Dave & Jakub,
> 
> please apply the following patches to netdev's net-next tree.
> 
> These patches do some preparation to make ISM available for uses beyond
> SMC-D, and a bunch of cleanups.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net/smc: Eliminate struct smc_ism_position
    https://git.kernel.org/netdev/net-next/c/eb481b02bd18
  - [net-next,2/4] s390/ism: Cleanups
    https://git.kernel.org/netdev/net-next/c/0a2f4f9893c8
  - [net-next,3/4] net/smc: Pass on DMBE bit mask in IRQ handler
    https://git.kernel.org/netdev/net-next/c/8b2fed8e2712
  - [net-next,4/4] net/smc: Enable module load on netlink usage
    https://git.kernel.org/netdev/net-next/c/28ec53f3a830

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


