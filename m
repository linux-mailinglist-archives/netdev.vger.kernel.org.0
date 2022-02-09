Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B954AF113
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbiBIMLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbiBIMLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:11:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543ADE024636;
        Wed,  9 Feb 2022 04:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19244B8205F;
        Wed,  9 Feb 2022 12:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFF02C340F2;
        Wed,  9 Feb 2022 12:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644408012;
        bh=tChG/APlgYgZmnRpBwfOs6TarG6PM4SafK7lke/LOvM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kKReQhYkKAA+T13w64DGmRbXp21ku5CA3djY0YFDvmd925uyujS8ujxRDM8PYZbNT
         zGt52KRqH4v6F77zpTydarRKkn2HOdv5hr2XTg8LgqnjdfSO9FbO10+UuyFS5ve8bu
         Axi7HTAK16fVWOAFrBp459C/DxWr8nPXaleOAoHgmvpqIsEEAXntaXc+ne58422C0q
         c6qj+Syrd1S5mhBQvskbKCbRyZWTvJxvwPQBBulkfWvt3W8f3ZmMpPMmtxMunHga8f
         F2Q1X5LiaGio4Am3FBjld1qvFQVA3Yz2zmprmSS8ip3QXHqgLiFyItYPhK6N55cxHg
         mOpBJJrWYcy0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B79ACE6D4A1;
        Wed,  9 Feb 2022 12:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2] Netvsc: Call hv_unmap_memory() in the
 netvsc_device_remove()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164440801274.11178.3026998691832829876.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 12:00:12 +0000
References: <20220208142652.186260-1-ltykernel@gmail.com>
In-Reply-To: <20220208142652.186260-1-ltykernel@gmail.com>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, michael.h.kelley@microsoft.com,
        Tianyu.Lan@microsoft.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Tue,  8 Feb 2022 09:26:52 -0500 you wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> netvsc_device_remove() calls vunmap() inside which should not be
> called in the interrupt context. Current code calls hv_unmap_memory()
> in the free_netvsc_device() which is rcu callback and maybe called
> in the interrupt context. This will trigger BUG_ON(in_interrupt())
> in the vunmap(). Fix it via moving hv_unmap_memory() to netvsc_device_
> remove().
> 
> [...]

Here is the summary with links:
  - [V2] Netvsc: Call hv_unmap_memory() in the netvsc_device_remove()
    https://git.kernel.org/netdev/net-next/c/b539324f6fe7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


