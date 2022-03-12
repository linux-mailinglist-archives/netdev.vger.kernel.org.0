Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE3A4D6D25
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 08:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiCLHBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 02:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbiCLHBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 02:01:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2A226C29C;
        Fri, 11 Mar 2022 23:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 054BA60C0A;
        Sat, 12 Mar 2022 07:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D1FEC340F9;
        Sat, 12 Mar 2022 07:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647068411;
        bh=Tw9Wws9w4XXadh+LgkTKJDwTWUhmP76jqrOKBZ5JOKE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ri7UaMsdmKWmoLcEHBi1ji450PbVgg7Hf0tEg0z9Gx93GRHOL2yXW8t7hLlrvrZ3o
         IHbllkBlcYExg5BEFBXr5Ya/jaDVuftGOnvdds8VyLMEE4JOZPdyiCNPGvta0VPFZb
         jPEoK3XirurQ0EaNE0PmKsR5kZyG3WTfEhDrNjkPHyOMIUtC/IQps3capl4ylS2lHW
         gS/CWodf3oyfm4OOLLr1lF9K/D4HO1kBOeSDam5Zk3lm4i6RhFAz64MnjVXL90qQDJ
         hNcaI757c34QZAWIQ2Bc8zINEzD+TLNXZf3PThbwK6nwfbSNMg2yMBnyHI5KojV76S
         4a+P8l3+hNX3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3E58AF0383D;
        Sat, 12 Mar 2022 07:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: netvsc: remove break after return
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164706841125.27256.8022348362682225610.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Mar 2022 07:00:11 +0000
References: <1646933534-29493-1-git-send-email-ssengar@linux.microsoft.com>
In-Reply-To: <1646933534-29493-1-git-send-email-ssengar@linux.microsoft.com>
To:     Saurabh Sengar <ssengar@linux.microsoft.com>
Cc:     ssengar@microsoft.com, haiyangz@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        davem@davemloft.net, kuba@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Mar 2022 09:32:14 -0800 you wrote:
> In function netvsc_process_raw_pkt for VM_PKT_DATA_USING_XFER_PAGES
> case there is already a 'return' statement which results 'break'
> as dead code
> 
> Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
> ---
>  drivers/net/hyperv/netvsc.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - net: netvsc: remove break after return
    https://git.kernel.org/netdev/net-next/c/8cf5ab362dce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


