Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF9066A971
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 06:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjANFkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 00:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjANFkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 00:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AD43A8E;
        Fri, 13 Jan 2023 21:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 051C360B32;
        Sat, 14 Jan 2023 05:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B480C43396;
        Sat, 14 Jan 2023 05:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673674817;
        bh=GJEDDtDl7ZFnDSTIqRsw2iU2A2L1JrS7LCb9GEhmBpo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JQcdXJRm3VPscjTlg8ulMkyFJuPu6XpLCv/3pyfFOP1ns9GSf59UHDMS63w7QBAdN
         JEHrLE8rvxEP/OoAWsdwrutYE08ewLovEfdCJaC+W6GEkdd92nVfLRQ6rodtETYFgE
         uZljtqfzLqMODO71Ubb+o2lhKv9yhxJhcGoNq943tP0hXVrJDus/UKh1hOXj7k+b+A
         Jv7lW04LiViqX28/x3T0HF25NyJkq3Mkzs245SVfN4HD+OWWWh3ooeBRdkPDPMg8dC
         Y+CUPQqSzl82j4I6NGE4gjo9Kj/41/8gPWgPvSgpSODZd94ZUjsTn+8hH9CjhoSnJT
         Y8ko7MNnxRVzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 364AFC395C8;
        Sat, 14 Jan 2023 05:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v2] ipv6: remove max_size check inline with ipv4
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167367481721.11900.11121412923866916372.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 05:40:17 +0000
References: <20230112012532.311021-1-jmaxwell37@gmail.com>
In-Reply-To: <20230112012532.311021-1-jmaxwell37@gmail.com>
To:     Jonathan Maxwell <jmaxwell37@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        martin.lau@kernel.org, joel@joelfernandes.org, paulmck@kernel.org,
        eyal.birger@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrea.mayer@uniroma2.it
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 Jan 2023 12:25:32 +1100 you wrote:
> v2: Correct syntax error in net/ipv6/route.c
> 
> In ip6_dst_gc() replace:
> 
> if (entries > gc_thresh)
> 
> With:
> 
> [...]

Here is the summary with links:
  - [net-next,v2] ipv6: remove max_size check inline with ipv4
    https://git.kernel.org/netdev/net-next/c/af6d10345ca7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


