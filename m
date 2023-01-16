Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6BE66C015
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjAPNuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjAPNuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B151F5C5
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 05:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E758CB80F03
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 13:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90C4AC433D2;
        Mon, 16 Jan 2023 13:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877016;
        bh=nzf2otbHCxuLRHphkL+1gzPPjA3GsV2GVV35sLnUim8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ik10OzstdDUDVP4sXKhSHaTfrfGjKuStDTo58B3sSJUXAU+HVqzvm2Ws/67RjkjUl
         CAWp3OfJdyULE4bqjUzDtqi+ZeObX3RmLtITWgSWjDLOu8NFbx4Oi0ZaO5fNIU6UCN
         cekzf0LeH3AV1p9tJWW01/xm5rnpig8csmRJmQ+PoGmEuEGvFdUhEqEnPLq+fDQQ+Q
         Fs66R2FnvyidtP95l2nTrEFtT2WWm+r+svkg4Tjp/9bWcOUw72bHv/gOQE/lBqNJPg
         UwJzJCb8SeKDfuZSwLTKoBGjQQK/Sm9nyPp2waXFS4RAob3NaIQXXKTNE0pgc+rNHG
         SCb78/uSk/swA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7382DE54D2E;
        Mon, 16 Jan 2023 13:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net v3 0/2] l2tp: fix race conditions in
 l2tp_tunnel_register()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167387701646.13526.1819803351438649697.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Jan 2023 13:50:16 +0000
References: <20230114030137.672706-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20230114030137.672706-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, saeed@kernel.org, gnault@redhat.com,
        tparkin@katalix.com, cong.wang@bytedance.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 13 Jan 2023 19:01:35 -0800 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> This patchset contains two patches, the first one is a preparation for
> the second one which is the actual fix. Please find more details in
> each patch description.
> 
> I have ran the l2tp test (https://github.com/katalix/l2tp-ktest),
> all test cases are passed.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] l2tp: convert l2tp_tunnel_list to idr
    https://git.kernel.org/netdev/net/c/c4d48a58f32c
  - [net,v3,2/2] l2tp: close all race conditions in l2tp_tunnel_register()
    https://git.kernel.org/netdev/net/c/0b2c59720e65

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


