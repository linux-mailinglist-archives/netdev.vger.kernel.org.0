Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23EA4E3D42
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 12:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbiCVLLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 07:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiCVLLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 07:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038086D86B
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 04:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89882612B2
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 11:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E17B5C340EE;
        Tue, 22 Mar 2022 11:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647947410;
        bh=E0hJZsB6XLdptOQhirA0FBCL5LVIyux/+DfxQvVyV1w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fUSsqE5yzLJGXMqfZmlo6cF00DPqEz+EUTEC0as7W4SjOCZBCYncuDKpEU20T7LA5
         O22kAo4YoPUO/RJobm54M5ITzDVE98NLD07jhuhYzAXc0O6yFFGgALjh7vyAiZ+xCH
         gFTevB7aOedhzrfjFMFsyvr1rzEivkdU78gRU/LYMZ9rbcdJy8NSLPVVTvwp2h4KOK
         IpT2beX0X9dIkZOgi5nejH9zpgxCNbFJbHKfezi6yM2MqNsMkvqCr8qV94RQyqYORV
         xVXuHWoAXDDu7p0d2E5aWaOKT1vGHxZZ8leLRIl5VDoHdbzHEp7lcE69jqHMmqzTgF
         W+eWy3nghtIDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C40A6E6D402;
        Tue, 22 Mar 2022 11:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] selftests: forwarding: Locked bridge port fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164794741079.5645.11338710914155427500.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Mar 2022 11:10:10 +0000
References: <20220321175102.978020-1-idosch@nvidia.com>
In-Reply-To: <20220321175102.978020-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, schultz.hans@gmail.com, razor@blackwall.org,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 21 Mar 2022 19:51:00 +0200 you wrote:
> Two fixes for the locked bridge port selftest.
> 
> Ido Schimmel (2):
>   selftests: forwarding: Disable learning before link up
>   selftests: forwarding: Use same VRF for port and VLAN upper
> 
>  .../selftests/net/forwarding/bridge_locked_port.sh   | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

Here is the summary with links:
  - [net-next,1/2] selftests: forwarding: Disable learning before link up
    https://git.kernel.org/netdev/net-next/c/917b149ac3d5
  - [net-next,2/2] selftests: forwarding: Use same VRF for port and VLAN upper
    https://git.kernel.org/netdev/net-next/c/f70f5f1a8fff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


