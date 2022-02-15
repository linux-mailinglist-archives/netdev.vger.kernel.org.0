Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B225A4B6F3B
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 15:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238781AbiBOOk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 09:40:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238775AbiBOOkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 09:40:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9195B102438;
        Tue, 15 Feb 2022 06:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AC22B81A63;
        Tue, 15 Feb 2022 14:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBD14C340F2;
        Tue, 15 Feb 2022 14:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644936010;
        bh=vMbrYYO0+ci8RMWm8C3NGaZ1G9KEdLy0vSHN463Z5qI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t0SQTqVYw/Futkl1LGPObQdL308pzaSktsgXLpVGh1JR8+t6Hj5q1+opZTBKTeqhL
         jYXWfwraiBIeccje1ZXzY9Jh7s2ju4M5zeM8b0ht2KlPyVlww6ecqgd4SoloCmpms/
         +GGTHbxfgAJK5CED09RCF48cbRXnjifdBxRKmk57BwNEKdh+yfCg7qv6P8vCPWIFd/
         cIkdxXZfYrEYr6i65Gq0Eulven88zn5fi+LxHc+6oDP6Y1oOwDXZJEtQP5bq6BgF2j
         QvqnMu1CLr4olpnXB05nmVQ1UOpS2PvX6g9oMwAAzm0BQhT5zvemLxNkKcuZc76i9b
         w92ZTbAVO3TQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7E49E74CC2;
        Tue, 15 Feb 2022 14:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] crypto: af_alg - get rid of alg_memory_allocated
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164493601081.31968.16251483649939634719.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Feb 2022 14:40:10 +0000
References: <20220213190607.183394-1-eric.dumazet@gmail.com>
In-Reply-To: <20220213190607.183394-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, weiwan@google.com,
        syzkaller@googlegroups.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Sun, 13 Feb 2022 11:06:07 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> alg_memory_allocated does not seem to be really used.
> 
> alg_proto does have a .memory_allocated field, but no
> corresponding .sysctl_mem.
> 
> [...]

Here is the summary with links:
  - crypto: af_alg - get rid of alg_memory_allocated
    https://git.kernel.org/netdev/net/c/25206111512d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


