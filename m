Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9174E5800
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 19:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343899AbiCWSBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 14:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235384AbiCWSBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 14:01:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ABE37A04
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 11:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 815F6612C6
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 18:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C304EC340F4;
        Wed, 23 Mar 2022 18:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648058413;
        bh=rFVWctD55QKeEoAnrN62RPzl2gtC9D119rMY+WbdD8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kGPJWV6N+N7mxVFzcUVBPTQe745dFpoBGVGYDXkZ0UDGWJjjPsHGqwCpbTpny6ihr
         FD7/rar6yQ+1IYAuUWQkS096+/jWLOD0mdSxe1PrTXrU4zpYW0F5YlmaLEQ5hroU4j
         xqtZcvqbMScp+m/QC6Vy/0SYC7P9p1YwIcSjsTptqj2dLQYg/wFZ9TC02A0NyymHyq
         JwdSb3tkYOtMJ+8+5bvBLTYB+XEjJXX05hcKiZi+XCNaJd0dTQ4ircd9XiA3h3b0g1
         dQ39WlG8f6/a3Yx1UvL1gbB5VaQKL6owiUVYc0gSSA/2xsZzg8MuNk6Yoz3dp2tCOI
         E+9S5AROCh3Tw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F185F0383F;
        Wed, 23 Mar 2022 18:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] llc: fix netdevice reference leaks in llc_ui_bind()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164805841364.28459.17956752631062934175.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Mar 2022 18:00:13 +0000
References: <20220323004147.1990845-1-eric.dumazet@gmail.com>
In-Reply-To: <20220323004147.1990845-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com, beraphin@gmail.com,
        smanolov@suse.de
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 22 Mar 2022 17:41:47 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Whenever llc_ui_bind() and/or llc_ui_autobind()
> took a reference on a netdevice but subsequently fail,
> they must properly release their reference
> or risk the infamous message from unregister_netdevice()
> at device dismantle.
> 
> [...]

Here is the summary with links:
  - [net-next] llc: fix netdevice reference leaks in llc_ui_bind()
    https://git.kernel.org/netdev/net-next/c/764f4eb6846f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


