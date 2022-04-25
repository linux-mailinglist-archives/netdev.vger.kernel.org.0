Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FE250DE5F
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 13:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241614AbiDYLDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 07:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238315AbiDYLDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 07:03:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A945B8CCFF;
        Mon, 25 Apr 2022 04:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F373FB815BE;
        Mon, 25 Apr 2022 11:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94204C385B0;
        Mon, 25 Apr 2022 11:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650884411;
        bh=Qu5ATgLDxCPCLmOegobXU0UXuqRM25UYt4vqDM5wPEk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HewJ+/wmSRJrkZmtRRJwrff8RPtBMQozqRN4Klg3a1Pr6x831M961CGNEqC9y1thY
         AnhlBrcdsYSiAcm6NB3h/2bbfXdOVhESiIEUPyVKA0TZwvPcuEvoS+RCyWi1yKQHep
         KxQlqFKcC7Z7TGVHakW0fWqoVwGQqFO1lIIN3DMpHflvqXRwQLgWhpDs3Zv9bndwVm
         sXPODyBe3uxKTeYJXPNP4Ioag6TBDsgftyuceP9XnC0SyoOcinov3HVdA2Cvl3uETR
         wq1/iLomHiu1PXDCCvNgICd32ikoenQbAhr36seZitROjQgV5io8/6m2cSy+fgrEL5
         hTch38yUA3jdA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F2F3E6D402;
        Mon, 25 Apr 2022 11:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] arp: fix unused variable warnning when
 CONFIG_PROC_FS=n
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088441151.15733.12108814407313013302.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 11:00:11 +0000
References: <20220422061431.1905579-1-yajun.deng@linux.dev>
In-Reply-To: <20220422061431.1905579-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com
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

On Fri, 22 Apr 2022 14:14:31 +0800 you wrote:
> net/ipv4/arp.c:1412:36: warning: unused variable 'arp_seq_ops' [-Wunused-const-variable]
> 
> Add #ifdef CONFIG_PROC_FS for 'arp_seq_ops'.
> 
> Fixes: e968b1b3e9b8 ("arp: Remove #ifdef CONFIG_PROC_FS")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> 
> [...]

Here is the summary with links:
  - [net-next] arp: fix unused variable warnning when CONFIG_PROC_FS=n
    https://git.kernel.org/netdev/net-next/c/b0e653b2a0d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


