Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A482616DFF
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 20:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiKBTua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 15:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiKBTu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 15:50:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F77E0EC;
        Wed,  2 Nov 2022 12:50:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FF7F61BB2;
        Wed,  2 Nov 2022 19:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94904C433D7;
        Wed,  2 Nov 2022 19:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667418626;
        bh=f7hyN8uMWR9JNUrhh7YAT+bUNDnqx/5h9w+EU16t4pg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lmYt6ndPFyzH37zKSnOnfBQqRwnLIj5VRJQr2xmr74/s/ObEqoAnmnBrAMzM/FrIk
         Kh2jH8g2RxdoVdYfnfF1nmEMxdK/E+dTdqXmoCl+cB0+h0+/5IkLR9RHvpNZL8z+0e
         uJlMAx3mkZQyeGdYV44idndsqHrsyRM837ixru5NYDTrNCc8oy28htMEWRbmTt/5Aw
         RBhCApydE52598dgN891h6QXULG1aCUeXI6X+pyL69Obzsko7EUSBWw+RHHHJ5ow7h
         6NXOdyui3jryWyyLq2afORFFSk80ESYsfXw6MHJ6V5B/4iY+/JFTMYbxXHAzogk4At
         4njdEqMEkkMBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C0B6E270D5;
        Wed,  2 Nov 2022 19:50:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-11-02
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166741862642.19739.7056656158057973602.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Nov 2022 19:50:26 +0000
References: <20221102062120.5724-1-daniel@iogearbox.net>
In-Reply-To: <20221102062120.5724-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  2 Nov 2022 07:21:20 +0100 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 70 non-merge commits during the last 14 day(s) which contain
> a total of 96 files changed, 3203 insertions(+), 640 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-11-02
    https://git.kernel.org/netdev/net-next/c/b54a0d4094f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


