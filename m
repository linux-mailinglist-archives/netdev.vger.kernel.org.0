Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CE3617B7D
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 12:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiKCLaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 07:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiKCLaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 07:30:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2BD11A19;
        Thu,  3 Nov 2022 04:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58C73B826F0;
        Thu,  3 Nov 2022 11:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF911C433C1;
        Thu,  3 Nov 2022 11:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667475015;
        bh=9u70mGjOAD1g0Chwx79K2kSsz8HLuYRGmzPc5JQrNbU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E1jwbxiS+YjMo+t4OE7fXIlKDVcJNYRYgb4UD3ha/VpS42iGmCEgYCuM59hQTyABu
         0/cYQhlIQ4jFPjIwyn1PP4NB/eX5QkyyDZpnQCVC2HdOkc30bFQ3idrB+5UcMUV7Pn
         gr0Ocd814KRrKpr+mg5PXve2C6W4Rx0fZmFYNQnWCFbnIUTThIeDTr72fKVTlkqu5a
         ghKmXuTkvHteGRQUcl3CVha4vWhz9zc7FeflPCrqQvL6nrKIGYmoQbz0UaHHHijAkP
         XO5WFlSiBFNMv/bW0gJrkoivyU7okEAX7ekUeI4zN6PX/uLcqoco026V/aQLLmgswI
         UfcZLObahznag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2C3FE29F4C;
        Thu,  3 Nov 2022 11:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mana: Assign interrupts to CPUs based on NUMA nodes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166747501485.8781.10763947245396462930.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 11:30:14 +0000
References: <1667282761-11547-1-git-send-email-ssengar@linux.microsoft.com>
In-Reply-To: <1667282761-11547-1-git-send-email-ssengar@linux.microsoft.com>
To:     Saurabh Sengar <ssengar@linux.microsoft.com>
Cc:     ssengar@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        colin.i.king@googlemail.com, vkuznets@redhat.com,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikelley@microsoft.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 31 Oct 2022 23:06:01 -0700 you wrote:
> In large VMs with multiple NUMA nodes, network performance is usually
> best if network interrupts are all assigned to the same virtual NUMA
> node. This patch assigns online CPU according to a numa aware policy,
> local cpus are returned first, followed by non-local ones, then it wraps
> around.
> 
> Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
> 
> [...]

Here is the summary with links:
  - net: mana: Assign interrupts to CPUs based on NUMA nodes
    https://git.kernel.org/netdev/net-next/c/71fa6887eeca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


