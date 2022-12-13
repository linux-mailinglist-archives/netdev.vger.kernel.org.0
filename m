Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F2164ABE3
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 01:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbiLMAAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 19:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiLMAAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 19:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A6BE0D2;
        Mon, 12 Dec 2022 16:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0AF3612B3;
        Tue, 13 Dec 2022 00:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 442CCC433F1;
        Tue, 13 Dec 2022 00:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670889617;
        bh=LWzJf9uXF09kZEe6TumIskn1pNTh2fW2T0Q4w5scBfk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hN2PiY97ijyVI3r4quA4QrzprBhAew5dMKJgvmY5VpxATF9Y2t9D/kO48umIdXgNC
         3XPrc4vE4GPekYWiP58bjBVn4jV65EYSDGJRmBfgoBhGvfnHjSs1Z2Fc2kc3tKPZ6R
         m/roNYjIqaZGd1XMEVGV0CBPJFyTyFerIrL2aJHi2emJ74JDD80x9pCmT9VfiVn0US
         OLM2e0eAwz8cR4Ha1/c4qhLXeXWDtvSF/4f2i2Z/BOC4ed6swURPSdbBYMw288FwSu
         fgvPEbt2p9JQqY4UuXBU0/d8/24grrRmwPzkwnbeCW4IcdNFri1JcTdZib8yI1RXvS
         cro5zLPloX5uQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24746E21EF1;
        Tue, 13 Dec 2022 00:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 1/2] IPv6/GRO: generic helper to remove temporary
 HBH/jumbo header in driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167088961714.16932.15471195808501226642.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Dec 2022 00:00:17 +0000
References: <20221210041646.3587757-1-lixiaoyan@google.com>
In-Reply-To: <20221210041646.3587757-1-lixiaoyan@google.com>
To:     Coco Li <lixiaoyan@google.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 10 Dec 2022 04:16:45 +0000 you wrote:
> IPv6/TCP and GRO stacks can build big TCP packets with an added
> temporary Hop By Hop header.
> 
> Is GSO is not involved, then the temporary header needs to be removed in
> the driver. This patch provides a generic helper for drivers that need
> to modify their headers in place.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/2] IPv6/GRO: generic helper to remove temporary HBH/jumbo header in driver
    https://git.kernel.org/netdev/net-next/c/89300468e2b2
  - [RFC,net-next,v6,2/2] bnxt: Use generic HBH removal helper in tx path
    https://git.kernel.org/netdev/net-next/c/b6488b161ab2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


