Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA2E4DCEF2
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 20:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiCQTlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 15:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiCQTl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 15:41:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF94C23454F;
        Thu, 17 Mar 2022 12:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74379618D2;
        Thu, 17 Mar 2022 19:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CAEAEC340EE;
        Thu, 17 Mar 2022 19:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647546011;
        bh=G2/OHyI1QVguA0I8hcOq7WeM8ez8ASwa+HK+VjjVu+o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=REp7NA7j0BInULFWx6ZzHMiOl87ibQPZVok/JT5Zi+PzezGG/sBMyp9qxh5RYMfZn
         a1SbKbR+kzCQU08yH5/wCvYR7wSFWuzwRc1FY6v5WcnyKTmKmpBjHGwF4UedIh73P1
         KeGjs+DvzriCQmFcenrDT8d55mXZBV3JSRAYDiV4yxOKnLcr+3FN02nJegXXI+iEr1
         c3x3Cgv/L2m4DMOIVyePsQB/y1nXxE8JCZOELxWYgV/89YeolXBI4Pa0R7YkTGF4lN
         3O/VQLUeLXG/QTpKJ9GrZXaFMGsSodmArKwMKPpHQgzlR2o889TyJ2dBdRkYQB51Hw
         RXVh8fTYElvRg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A69D9E8DD5B;
        Thu, 17 Mar 2022 19:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 bpf-next 0/3] introduce xdp frags support to veth driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164754601167.22518.17164915202075705789.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 19:40:11 +0000
References: <cover.1646989407.git.lorenzo@kernel.org>
In-Reply-To: <cover.1646989407.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        brouer@redhat.com, toke@redhat.com, pabeni@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        toshiaki.makita1@gmail.com, andrii@kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 11 Mar 2022 10:14:17 +0100 you wrote:
> Introduce xdp frags support to veth driver in order to allow increasing the mtu
> over the page boundary if the attached xdp program declares to support xdp
> fragments.
> This series has been tested running xdp_router_ipv4 sample available in the
> kernel tree redirecting tcp traffic from veth pair into the mvneta driver.
> 
> Changes since v4:
> - remove TSO support for the moment
> - rename veth_convert_skb_from_xdp_buff to veth_convert_skb_to_xdp_buff
> 
> [...]

Here is the summary with links:
  - [v5,bpf-next,1/3] net: veth: account total xdp_frame len running ndo_xdp_xmit
    https://git.kernel.org/bpf/bpf-next/c/5142239a2221
  - [v5,bpf-next,2/3] veth: rework veth_xdp_rcv_skb in order to accept non-linear skb
    https://git.kernel.org/bpf/bpf-next/c/718a18a0c8a6
  - [v5,bpf-next,3/3] veth: allow jumbo frames in xdp mode
    https://git.kernel.org/bpf/bpf-next/c/7cda76d858a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


