Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D046629192
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 06:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiKOFkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 00:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiKOFkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 00:40:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D806463
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 21:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B794D61546
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 015B9C4347C;
        Tue, 15 Nov 2022 05:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668490815;
        bh=GwnNhfeA3c5dVglce6IKYW9ifavJ37CHhAEOf9z1Vys=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nOvLecjwkOIqsYH5YM4kmvMAyJymC6v3DdIFpqZjbfaMwZtOY4zhT/8F7rQ/Ua9wx
         hblrcmTboGaGGB/T6UMDV8CXRz1uoY5MYVy+Zms/mJOSjaLlITu0JMuvGHvcsHDNi9
         N+Uim9IpqpoV37fApTVDO/jCmnhOTamCeOjtlTuG1YxOxvjV8uvccyLuYpxhEVHOki
         ZuHbKnLXvcTZCsCs+99NAabGpO22t4KDq/Loi1PzzB2wq/9ukLBzY7cLruiTkYwFa3
         JV+VUbAUc3PyXNLFoKDMycCtP2jtMEzR3GyjaLlRjH0zdHyx+Am7pY0xIeV0Q1YE/x
         ofBDMdXlaDyHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1ACBC395FE;
        Tue, 15 Nov 2022 05:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mlxsw: Avoid warnings when not offloaded FDB entry with
 IPv6 is removed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166849081492.10793.2796648065104558849.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Nov 2022 05:40:14 +0000
References: <c186de8cbd28e3eb661e06f31f7f2f2dff30020f.1668184350.git.petrm@nvidia.com>
In-Reply-To: <c186de8cbd28e3eb661e06f31f7f2f2dff30020f.1668184350.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, idosch@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 11 Nov 2022 18:03:27 +0100 you wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> FDB entries that perform VXLAN encapsulation with an IPv6 underlay hold
> a reference on a resource - the KVDL entry where the IPv6 underlay
> destination IP is stored. For that, the driver maintains two hash tables:
> 1. Maps IPv6 to KVDL index
> 2. Maps {MAC, FID index} to IPv6 address
> 
> [...]

Here is the summary with links:
  - [net] mlxsw: Avoid warnings when not offloaded FDB entry with IPv6 is removed
    https://git.kernel.org/netdev/net/c/30f5312d2c72

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


