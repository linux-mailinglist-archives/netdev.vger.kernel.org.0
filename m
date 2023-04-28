Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553106F13C2
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 11:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345508AbjD1JAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 05:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345505AbjD1JAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 05:00:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939F726BA;
        Fri, 28 Apr 2023 02:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 259206421F;
        Fri, 28 Apr 2023 09:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80F49C4339B;
        Fri, 28 Apr 2023 09:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682672421;
        bh=Bc1Uwb/0zuN2VMbm3eDNwVbtJ8iIXcfsh5Kyk9iRCkk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CuspvcwqXvTbKKyMP8EVRkWLONFvnBdMwTFcaShCTQhCVPs12W4roIYn3BRSzqlzf
         AbIGqUjRYePbxiP4WRBGK0ioKgE7v3Hv4xxVXMxyiVb8jOen3nX5k5YMvlnOI8CbH2
         3W9dlwbBj9O7A8dJk3cphow9fRqvXeTsIzzadArFAUTMi6PVVT5v+tcGR1A0XgIAdl
         ybljQLEAjPuUF8VPDBv8RrgLn37sVAhGbxYkBFcu+W2bzvx++RnOYlX316ZHxLSF5U
         5yYj+nuIyeyEE41rUj9aaq4NtA5gF/1LGSjQui2FNi6BsPr/Hk6/7fffN8fusm/17X
         hbsH2J+DFUVRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 51369C41677;
        Fri, 28 Apr 2023 09:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] selftests: srv6: make srv6_end_dt46_l3vpn_test more robust
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168267242132.9185.1977179149314031503.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Apr 2023 09:00:21 +0000
References: <20230427094923.20432-1-andrea.mayer@uniroma2.it>
In-Reply-To: <20230427094923.20432-1-andrea.mayer@uniroma2.it>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, shuah@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, stefano.salsano@uniroma2.it,
        paolo.lungaroni@uniroma2.it, ahabdels.dev@GMAIL.COM,
        liuhangbin@GMAIL.COM
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 27 Apr 2023 11:49:23 +0200 you wrote:
> On some distributions, the rp_filter is automatically set (=1) by
> default on a netdev basis (also on VRFs).
> In an SRv6 End.DT46 behavior, decapsulated IPv4 packets are routed using
> the table associated with the VRF bound to that tunnel. During lookup
> operations, the rp_filter can lead to packet loss when activated on the
> VRF.
> Therefore, we chose to make this selftest more robust by explicitly
> disabling the rp_filter during tests (as it is automatically set by some
> Linux distributions).
> 
> [...]

Here is the summary with links:
  - [net] selftests: srv6: make srv6_end_dt46_l3vpn_test more robust
    https://git.kernel.org/netdev/net/c/46ef24c60f8e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


