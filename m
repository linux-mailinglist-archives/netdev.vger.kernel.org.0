Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB175F2FC6
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 13:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiJCLkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 07:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJCLkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 07:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03CF1A820
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 04:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 568F4B8107B
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 11:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B70CC433D7;
        Mon,  3 Oct 2022 11:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664797215;
        bh=5s3jzhAgZ3AVV3wNb35ZszbhMAgtljidYaS28nv9Adw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XrRjjGvVo9w8ybb5vA4rDw3GSvBugoV9yXMDkenZJ729ncEeuJ0snuo4kM05PepMp
         gdfgpSje53igZP5v1Wwc+wUCXuzsXi31WY9F8WC+9ttNgv8KplLGq9/LI6U1/nz/br
         W65jGYF0hbWhe7vMttlBMvwnENoPnFCSS5LGS0ZBuIjyqn32kGyj5iMWX+j5Dt8Dlr
         2lrQVU/5zfad1I02inUjm65cOr9X/eTIgvBvCPEvrKfrv7m0tv4Kg/S4gEA1UYkRvN
         LWJ48CBJO1y6/W2BrlQ/wlENndk+t0+CeDoMC1TY/AEw7OFS93mKyxVwAuqhD8UzVD
         VKsNgpb3//thQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E96EBE49FA3;
        Mon,  3 Oct 2022 11:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] gro: add support of (hw)gro packets to gro stack
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166479721495.20474.5436625882203781290.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 11:40:14 +0000
References: <20220930220905.2019461-1-eric.dumazet@gmail.com>
In-Reply-To: <20220930220905.2019461-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com, lixiaoyan@google.com
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
by David S. Miller <davem@davemloft.net>:

On Fri, 30 Sep 2022 15:09:05 -0700 you wrote:
> From: Coco Li <lixiaoyan@google.com>
> 
> Current GRO stack only supports incoming packets containing
> one frame/MSS.
> 
> This patch changes GRO to accept packets that are already GRO.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] gro: add support of (hw)gro packets to gro stack
    https://git.kernel.org/netdev/net-next/c/5eddb24901ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


