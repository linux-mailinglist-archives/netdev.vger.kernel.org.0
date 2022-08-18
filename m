Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F35D597DFE
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 07:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243141AbiHRFUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 01:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239419AbiHRFUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 01:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0E575391
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 22:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60EC3615FF
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 05:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B435BC43141;
        Thu, 18 Aug 2022 05:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660800017;
        bh=+WlJ9JCNoGHyYTlKP/5NeKD3bbOKRdgLEpsbAegbcAY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hQ7hcvogGD/8cEG6jsFaUdLGDZDSsY9/N3ZZkYeZE2eHovtu8AW5VpLy1HomAc3Zi
         ot1blQKo9y5XtAUn4BFsn+PbGmaeqHyCA2Hgn+EPWW2al0D7Y2N1U7I+mqOhqIScO7
         aSQ1evVt/J5skVmiDWohYkgYGYz2EzWm7UR9zwSRMJt8x+WV1HuVYUOFNYHMpJCV3v
         JKlTXIFIpRlhZr+zQk7QIqn1U0Z0+Jbj7riQfNddcBqFUKoDpzywtZH6UWgQz9mE+f
         NujOmNO2ghtVPDyLsQW6jgP/BQTXI73LAKrAjHNQrv4gYqOP1/NY7Zj4myzxW6V04y
         w83FB9As2aDOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 95909E2A04D;
        Thu, 18 Aug 2022 05:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5e: Allocate flow steering storage during uplink
 initialization
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166080001760.8479.16038333541054100321.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 05:20:17 +0000
References: <ae46fa5bed3c67f937bfdfc0370101278f5422f1.1660639564.git.leonro@nvidia.com>
In-Reply-To: <ae46fa5bed3c67f937bfdfc0370101278f5422f1.1660639564.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        edumazet@google.com, lkayal@nvidia.com, netdev@vger.kernel.org,
        pabeni@redhat.com, saeedm@nvidia.com, tariqt@nvidia.com
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

On Tue, 16 Aug 2022 11:47:23 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> IPsec code relies on valid priv->fs pointer that is the case in NIC
> flow, but not correct in uplink. Before commit that mentioned in the
> Fixes line, that pointer was valid in all flows as it was allocated
> together with priv struct.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: Allocate flow steering storage during uplink initialization
    https://git.kernel.org/netdev/net/c/d515f38c1e6d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


