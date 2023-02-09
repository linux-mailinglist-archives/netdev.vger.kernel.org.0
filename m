Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D4C68FC4F
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 02:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjBIBA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 20:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbjBIBAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 20:00:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA5D234E4
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 17:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8811B61853
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 01:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2B85C433AC;
        Thu,  9 Feb 2023 01:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675904417;
        bh=f6wv6Z3sr1EqLbCtrwZFX9CfSwDWie2doxRfbSYEJCs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Da1YEqgKJ8AB+NBzqfnIZ16L2DEMLaTBuzrVCrGLjZTCdNMMMu9Lau263rnuMVhdP
         Pz9XZMvcMEpjnS5ejgRLlhtyhhMRSc37MLYT0e0stPNYyX0eKo5aAoRrsTGWT8CnXm
         07ZQTEC/qKNlDFXrYP2JdL+gMZXeZp+RjkaQdz5Dy3LRLm3XJOmKOP9oisfuxI8QcZ
         5IcSePMrK0e8O6g3ZRkNuhnhsXIrp4HUreDFAo3EVGkKcXxSl/QqM80VhDQjk5pAju
         W16Dab/diMDoLWCMJg0xnWYF565jPIsZ1Cifp+kFO/JohqNlk8q1aF2pRALBqrknzn
         0ecaeDa/6pkQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C08E1E50D62;
        Thu,  9 Feb 2023 01:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: Fix failing VXLAN VNI filtering test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167590441778.22544.17117881689906032748.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Feb 2023 01:00:17 +0000
References: <20230207141819.256689-1-idosch@nvidia.com>
In-Reply-To: <20230207141819.256689-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, roopa@nvidia.com
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

On Tue,  7 Feb 2023 16:18:19 +0200 you wrote:
> iproute2 does not recognize the "group6" and "remote6" keywords. Fix by
> using "group" and "remote" instead.
> 
> Before:
> 
>  # ./test_vxlan_vnifiltering.sh
>  [...]
>  Tests passed:  25
>  Tests failed:   2
> 
> [...]

Here is the summary with links:
  - [net] selftests: Fix failing VXLAN VNI filtering test
    https://git.kernel.org/netdev/net/c/b963d9d5b943

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


