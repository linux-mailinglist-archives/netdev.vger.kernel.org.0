Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1874C06E7
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 02:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbiBWBaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 20:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbiBWBaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 20:30:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93E449F81
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 17:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C141B81D9B
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 01:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28CB9C340EB;
        Wed, 23 Feb 2022 01:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645579810;
        bh=LZE+jPzeH8b00214wcyrMUJskTXKm9lgzct6q2w82/o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=osK2TUMC6Acgw3JlYQHatDQ8LrNvfwH7QKQrWdPx38oNQTMu+NzRlK/rPX8QWhklC
         j0Y0dnS53ZsuxLczGVlmcVbSst4L6fAbsDhJd01xRkeqvuiieYwGKXjzZaO8wesap1
         2kfI2EKMv/EQmvrWJsI0lrA84Tnav3pn9bLzd6aSsX+ua9XKCGD5fTAlIcNcUBM05R
         lHhWn7F1DKaSO7FU5mbBTq7ecMHI9G7YTkop/Q6KfF8cpQK4FXx8K7nmPTW9G+6G6k
         r3NY3c1aUiIWpHCYC9Xen66kEgVQ+wRPhOAHBRtf/FZZgDXIH/Xd9ix0PDl2w5xDJi
         B0ECw1YGylQvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0CB10EAC081;
        Wed, 23 Feb 2022 01:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ibmvnic: schedule failover only if vioctl fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164557981004.7747.15413251407020699194.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 01:30:10 +0000
References: <20220221210545.115283-1-drt@linux.ibm.com>
In-Reply-To: <20220221210545.115283-1-drt@linux.ibm.com>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, cforno12@outlook.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 21 Feb 2022 15:05:45 -0600 you wrote:
> From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> 
> If client is unable to initiate a failover reset via H_VIOCTL hcall, then
> it should schedule a failover reset as a last resort. Otherwise, there is
> no need to do a last resort.
> 
> Fixes: 334c42414729 ("ibmvnic: improve failover sysfs entry")
> Reported-by: Cris Forno <cforno12@outlook.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> Signed-off-by: Dany Madden <drt@linux.ibm.com>
> 
> [...]

Here is the summary with links:
  - [net] ibmvnic: schedule failover only if vioctl fails
    https://git.kernel.org/netdev/net/c/277f2bb14361

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


