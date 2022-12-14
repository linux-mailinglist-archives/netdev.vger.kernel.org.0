Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A0564C287
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 04:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbiLNDK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 22:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237228AbiLNDKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 22:10:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61C52705
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 19:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 154AD61732
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 03:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65FA9C433F0;
        Wed, 14 Dec 2022 03:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670987415;
        bh=0ubIxsZD3JT+4RmaCGExpMNa929HjeJgHIQrzbEFOEw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CdXsko/jPOF8Z2P8Lymuv6fpxFJmktkPPMpF8449gQWAQEC2yA0KG95QaEh4yryWQ
         ZXFIXepwlt+kAPgh6NcyrTOWMpHgsdQOeoBrNtnDCylQq3wxVJyymUrT6T3/3IsTsJ
         ga+ehPM11YqsPaHbItWtI8bSp+JbL2mimgjp+pLRfQ+qGim83o0N1uF4RhMQvBxKE6
         TJzKx1iW7BY43EckPyh8HUCGTGRtTaH7FfOeHyuBoa3B46Wgj2AciGURD3b/ACl7ta
         A4mgeTAjcUUrtM/FtgTukjK2bNR4v0Q7LRBLrAvX27ZjoEv1BZhNsEs3AFjLirL13m
         A907KIgkPEAaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A184C41612;
        Wed, 14 Dec 2022 03:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: macsec: fix net device access prior to holding a
 lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167098741529.9387.12438295894799799333.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Dec 2022 03:10:15 +0000
References: <20221211075532.28099-1-ehakim@nvidia.com>
In-Reply-To: <20221211075532.28099-1-ehakim@nvidia.com>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     netdev@vger.kernel.org, raeds@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        sd@queasysnail.net, atenart@kernel.org
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

On Sun, 11 Dec 2022 09:55:32 +0200 you wrote:
> From: Emeel Hakim <ehakim@nvidia.com>
> 
> Currently macsec offload selection update routine accesses
> the net device prior to holding the relevant lock.
> Fix by holding the lock prior to the device access.
> 
> Fixes: dcb780fb2795 ("net: macsec: add nla support for changing the offloading selection")
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net] net: macsec: fix net device access prior to holding a lock
    https://git.kernel.org/netdev/net/c/f3b4a00f0f62

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


