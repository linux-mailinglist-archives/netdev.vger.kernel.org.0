Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7F34ECD3E
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 21:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344547AbiC3TcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 15:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350728AbiC3Tb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 15:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCAF2FFDB
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 12:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29EE1614FC
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 19:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A83EC340F0;
        Wed, 30 Mar 2022 19:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648668612;
        bh=/nNRV6VTgQIod6WMGXIU0ef7ICU38PhttEwJ53tu68k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HgT7treHkgzWkQo9A/hJIY8LCWUcb8EWmfODWryaPSwVvS8lDwIO2Hoq8IUsdphOx
         th2PYAFFK4xnJaSIBDXHWanfElgy7GpWOjdHdwGrQz7YNi3ZGGeR6jNR/H+6jdMF5L
         7JOLjCM/MntpJWufbkAU/RsSNdloyJ8ZXjKRQChzBgYxayujtGPiUyL7sYXinOyDJH
         HcSzRkJwhgPeLXM0WnTx7BP505nqj/HDW7iTMLGhv6jsppmdMWIzM1aSF/HCQD++Ik
         CcLclQbrdkyW7GK5MGaBbPeUZeEMGRWMWueUr9X5PFx3T6z1Qx3S5LBUZSCfgM1CjL
         quAL7fd3uG50A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 622B0F03849;
        Wed, 30 Mar 2022 19:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc: Avoid NULL pointer dereference on systems without
 numa awareness
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164866861239.12292.14168964282725341727.git-patchwork-notify@kernel.org>
Date:   Wed, 30 Mar 2022 19:30:12 +0000
References: <164857006953.8140.3265568858101821256.stgit@palantir17.mph.net>
In-Reply-To: <164857006953.8140.3265568858101821256.stgit@palantir17.mph.net>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, ihuguet@redhat.com, ecree.xilinx@gmail.com
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

On Tue, 29 Mar 2022 17:07:49 +0100 you wrote:
> On such systems cpumask_of_node() returns NULL, which bitmap
> operations are not happy with.
> 
> Fixes: c265b569a45f ("sfc: default config to 1 channel/core in local NUMA node only")
> Fixes: 09a99ab16c60 ("sfc: set affinity hints in local NUMA node only")
> Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] sfc: Avoid NULL pointer dereference on systems without numa awareness
    https://git.kernel.org/netdev/net/c/c9ad266bbef5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


