Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BE14E7BB2
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiCZALu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 20:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiCZALs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 20:11:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBD94CD5F
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 17:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 131ACB82ACB
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 00:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3643C34100;
        Sat, 26 Mar 2022 00:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648253410;
        bh=0qEA5Bc3t15yLVuB7GH3dcMrLeCO7mkN6+SDGk1VlvY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hsnrNG8gspkS7n+kRGqM6Xi3xHpqCztDKFyU2A9wNyRhSzBQx6PR1vu6lxzqQwVYp
         RBrovKNxT3KVpnw6kXBAQSRO9GifwtbiOl282nuAAHvhoqXul/acQ2uCSHFs0y5VLA
         Thhzf5te6SrfZyN5j1SazEp7ExNFJnpF6tOsw2Nmj/q4nex7KSy57G1HQgdZaCwYJY
         UlczrqQ80CksMtzkfIrtwjOP8HcZbRLPFQ6x1BMTSa4V0g62Q8mLqcIaBfcxrinS9M
         RPqblPhkGDyunyS9aJvZ9trS5MDwTElhwVFBDI0F4Rf4uzug0xkladZAa/me6FkGu5
         /NYYsPe5EI4JQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AAE8BE6BBCA;
        Sat, 26 Mar 2022 00:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: test_vxlan_under_vrf: Fix broken test case
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164825341069.1855.10834978451792889324.git-patchwork-notify@kernel.org>
Date:   Sat, 26 Mar 2022 00:10:10 +0000
References: <20220324200514.1638326-1-idosch@nvidia.com>
In-Reply-To: <20220324200514.1638326-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, abauvin@scaleway.com, akherbouche@scaleway.com,
        dsahern@gmail.com, mlxsw@nvidia.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 24 Mar 2022 22:05:14 +0200 you wrote:
> The purpose of the last test case is to test VXLAN encapsulation and
> decapsulation when the underlay lookup takes place in a non-default VRF.
> This is achieved by enslaving the physical device of the tunnel to a
> VRF.
> 
> The binding of the VXLAN UDP socket to the VRF happens when the VXLAN
> device itself is opened, not when its physical device is opened. This
> was also mentioned in the cited commit ("tests that moving the underlay
> from a VRF to another works when down/up the VXLAN interface"), but the
> test did something else.
> 
> [...]

Here is the summary with links:
  - [net] selftests: test_vxlan_under_vrf: Fix broken test case
    https://git.kernel.org/netdev/net/c/b50d3b46f842

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


