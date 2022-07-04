Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F71556521D
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 12:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbiGDKWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 06:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiGDKVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 06:21:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A601A5
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 03:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6749B80E88
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 10:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F8F6C3411E;
        Mon,  4 Jul 2022 10:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656930012;
        bh=zbrMMXb+EM4eoStMJShecXPYQXb8nOzu2BGAKNnp9Ls=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JKtO82IksueGzj6c3DCZtB/jse6MprUmdX32ugklyNy9/DAZET/bKKXre7a7JUSTK
         IdReaLdRfBZdVIdgR5xZYf0eEnzrUGiZYVPhWcA7NLQ2b+W+1QOukL6En99Wt9wJGo
         shkKSFtfUQjUrYN21oL8947X/+Doly4epJ8kjrBrCsG/6nVsYNBhi0G/SadV4lLeFr
         hls5PsO9QK7bEVha6DA8+7zXecyZ80PyL5V+UDidDsrXpv/NrOJ1YjtFSakNLjtU3X
         s60bPL05qgSV3pN7yD/GR+LoYgUoNRqljEXg1e0Jf2S6mr9VUjQCyrjLyaus/0JCMa
         sOsw63JeN/SFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 888FEE45BDE;
        Mon,  4 Jul 2022 10:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ibmvnic: Properly dispose of all skbs during a
 failover.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165693001255.5222.4741080488026243148.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Jul 2022 10:20:12 +0000
References: <20220702103711.4036357-1-ricklind@us.ibm.com>
In-Reply-To: <20220702103711.4036357-1-ricklind@us.ibm.com>
To:     Rick Lindsley <ricklind@us.ibm.com>
Cc:     netdev@vger.kernel.org, bjking1@linux.ibm.com, haren@linux.ibm.com,
        nnac123@linux.ibm.com, mmc@linux.ibm.com, ricklind@linux.ibm.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  2 Jul 2022 03:37:12 -0700 you wrote:
> During a reset, there may have been transmits in flight that are no
> longer valid and cannot be fulfilled.  Resetting and clearing the
> queues is insufficient; each skb also needs to be explicitly freed
> so that upper levels are not left waiting for confirmation of a
> transmit that will never happen.  If this happens frequently enough,
> the apparent backlog will cause TCP to begin "congestion control"
> unnecessarily, culminating in permanently decreased throughput.
> 
> [...]

Here is the summary with links:
  - [net,v2] ibmvnic: Properly dispose of all skbs during a failover.
    https://git.kernel.org/netdev/net/c/1b18f09d31cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


