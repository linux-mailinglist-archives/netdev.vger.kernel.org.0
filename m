Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14675508A7C
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 16:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344145AbiDTOTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 10:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379462AbiDTORW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 10:17:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A910C48E64
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 07:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56876B81F8E
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 14:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5904C385A1;
        Wed, 20 Apr 2022 14:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650463812;
        bh=jVxzAy2JbaHYJSjbiaR1RXhDxVsJCDQamV74N+zGyJw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nLpImoCeg9IsGtWtxSPQtxGbMRHnDueaTsaBXEoUygC3EVRCsMZNQ9dbJ23bZ6lWv
         t0GV/YKfQ06e7DMgC4etbJ0X3yhrzRJxQGhzJVHrtbMSroD2uaIeRXJv2pr+Je12bx
         uaZ7E9fduT0SHeff9ot4kG0QX0qEQnrcFH/e1f9ks8JXjKiwwzXeMLXysE0hg8JXJf
         sB9lm3J5eTksTP3aetEIBRaI7dYiF7Zo8o0Rk6f6MAhiu0KwAFY4I/OROr+U8BYcn/
         1xyz7ATFsU/Ut1RCobOLhNZZbkUFu+/wTIjLl7+ZXpQ5F01C3BMmTQJbIDT2xnWNm0
         /DvUNFBMbVuDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF256E8DBD4;
        Wed, 20 Apr 2022 14:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] selftests: mlxsw: Make VXLAN flooding tests more
 robust
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165046381177.28556.2994810445805869224.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Apr 2022 14:10:11 +0000
References: <20220419135155.2987141-1-idosch@nvidia.com>
In-Reply-To: <20220419135155.2987141-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 19 Apr 2022 16:51:53 +0300 you wrote:
> Make the VXLAN flooding tests (with IPv4 and IPv6 underlay) more robust
> by preventing flooding of unwanted packets. See detailed description of
> the problem and solution in the commit messages.
> 
> Ido Schimmel (2):
>   selftests: mlxsw: vxlan_flooding: Prevent flooding of unwanted packets
>   selftests: mlxsw: vxlan_flooding_ipv6: Prevent flooding of unwanted
>     packets
> 
> [...]

Here is the summary with links:
  - [net,1/2] selftests: mlxsw: vxlan_flooding: Prevent flooding of unwanted packets
    https://git.kernel.org/netdev/net/c/044011fdf162
  - [net,2/2] selftests: mlxsw: vxlan_flooding_ipv6: Prevent flooding of unwanted packets
    https://git.kernel.org/netdev/net/c/5e6242151d7f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


