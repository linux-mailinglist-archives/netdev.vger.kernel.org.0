Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1723604F80
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiJSSUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiJSSUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E5614BB7D;
        Wed, 19 Oct 2022 11:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 321AA61990;
        Wed, 19 Oct 2022 18:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 894B7C433D6;
        Wed, 19 Oct 2022 18:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666203619;
        bh=0nHK6ALzJ2EwbBl4Pq0SzYGFU/VJn3yZFZwi9qQaDUI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NzfKN6w1TNokLrXJ/WUMs1GMFsHU3dK09uSonEY7czKpEvjGw9CGCcW+n/VVrUn9d
         E/fvwkoYuxo7xmtf7nrBJylzQncfGOk0wy/+fRGlqClpoKdiQPteLTqyBMjVp3icee
         Vvz3hzGTjLTEVNaDRzzLh16ydoWmsrAW2Tfi6XPgsgADVfG5a5a1lCNwG7K8BSw7HR
         G2sqVlI1dNqFbT9IlNsGiKoPbHiBUM82S2W+xZo2vgVT2Bm/QDlXXc2id9Lzt8Cg1V
         CH5LF3bHuyewyEqzpc1hWv+TXVp0ASbP6ZNJ7IMpzY2Cvz7p9JhHYI9pRA2JuO75v9
         l2BykECvd+/Yg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C543E270EA;
        Wed, 19 Oct 2022 18:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] samples/bpf: Fix MAC address swapping in xdp2_kern
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166620361944.19244.16270967809216519217.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 18:20:19 +0000
References: <20221015213050.65222-1-gerhard@engleder-embedded.com>
In-Reply-To: <20221015213050.65222-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     andrew.gospodarek@broadcom.com, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Martin KaFai Lau <martin.lau@kernel.org>:

On Sat, 15 Oct 2022 23:30:50 +0200 you wrote:
> xdp2_kern rewrites and forwards packets out on the same interface.
> Forwarding still works but rewrite got broken when xdp multibuffer
> support has been added.
> 
> With xdp multibuffer a local copy of the packet has been introduced. The
> MAC address is now swapped in the local copy, but the local copy in not
> written back.
> 
> [...]

Here is the summary with links:
  - [net-next] samples/bpf: Fix MAC address swapping in xdp2_kern
    https://git.kernel.org/bpf/bpf-next/c/7a698edf954c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


