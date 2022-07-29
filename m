Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66000584F78
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 13:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbiG2LUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 07:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbiG2LUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 07:20:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1869FD7;
        Fri, 29 Jul 2022 04:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14B92B8277A;
        Fri, 29 Jul 2022 11:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8063C43143;
        Fri, 29 Jul 2022 11:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659093614;
        bh=Y57jwLF17yKH6ire5XQJto2UeyP9tKC9ZU+RXx+jAGk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pfy4CLPHAIwi5MkFwPPlZmCie+1khVGK8OkW4Lddf5LRFLyWfiTFcTmj6HI3zAfPA
         LP8AlPw3EmQ7B6JDU6LPLIsb3W2d+EWnfDpbRRn2vd36+mDAyqyDwR5M2xZiYSJXs5
         ueA+AU78PnHKAd8BbKiAyzAfOXTdO+ScQJUZtsNDbh/6O+HPYMqjQUBL7CJ3CFsyn3
         5ExZlLcYTadL8V2ljMS5lIboazRaz9zE59N8eNfcs4U5JlRVhAFZJ5MVHJTg5zG+SH
         /0QgZnfhp3Apnag3v/ttTaCMuI+WNWJrQvjA21WZQq1EOa5epTAkv+6rqSOpZ4hWXV
         0brdSNPyHWF3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A4E14C43143;
        Fri, 29 Jul 2022 11:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Documentation: Describe net.ipv4.tcp_reflect_tos.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165909361467.23060.8772702357602230882.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 11:20:14 +0000
References: <4376126910096258f0a9da93ec53cad99a072afc.1658920560.git.gnault@redhat.com>
In-Reply-To: <4376126910096258f0a9da93ec53cad99a072afc.1658920560.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Jul 2022 13:18:21 +0200 you wrote:
> The tcp_reflect_tos option was introduced in Linux 5.10 but was still
> undocumented.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 10 ++++++++++
>  1 file changed, 10 insertions(+)

Here is the summary with links:
  - [net-next] Documentation: Describe net.ipv4.tcp_reflect_tos.
    https://git.kernel.org/netdev/net-next/c/1c7249e4af8e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


