Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4824BB107
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 06:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiBRFAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 00:00:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiBRFAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 00:00:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EF82BAA08;
        Thu, 17 Feb 2022 21:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88B8DB82580;
        Fri, 18 Feb 2022 05:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23CEAC340EF;
        Fri, 18 Feb 2022 05:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645160412;
        bh=SUvNkdAPHKRLHby8PNM4g4iD5DZS84CR2ccSdHXAe7g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UAWwWCL+ANy91suzOItQUDGzlXIUiIkemRPC8dpp7nwcTIBjoEIKz488HdhEyydFC
         uNBA46m3dl9vttUnRhvDInO8fcMr+gP9ycbY+IsExfZ4k3ZCKNbEtZe24b996YyPzS
         oMe7B2CQnrzyX7tMoVUmYzRXxCIzHWv2XpfwrCIcz05HEkAEjpEMHSAsUPOkRoCUE1
         ajggmbJKciqPX0VpaYxoHmNVuBAxfY/4e2fA9m7mnCCjQL2ubIt6/dFq1N+OIldi4a
         baF7noKhYJOrF0Pf08PnhndWnNVj/RrGAJtA4y6dQCzDCoVFqJZTl+/zAyk78ii9O+
         MO6mytIeKkdOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02086E5D07D;
        Fri, 18 Feb 2022 05:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: nixge: Use GFP_KERNEL instead of GFP_ATOMIC when
 possible
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164516041200.28752.1269210032576115440.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 05:00:12 +0000
References: <28d2c8e05951ad02a57eb48333672947c8bb4f81.1645043881.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <28d2c8e05951ad02a57eb48333672947c8bb4f81.1645043881.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Feb 2022 21:38:11 +0100 you wrote:
> NIXGE_MAX_JUMBO_FRAME_SIZE is over 9000 bytes and RX_BD_NUM 128.
> 
> So this loop allocates more than 1 Mo of memory.
> 
> Previous memory allocations in this function already use GFP_KERNEL, so
> use __netdev_alloc_skb_ip_align() and an explicit GFP_KERNEL instead of a
> implicit GFP_ATOMIC.
> 
> [...]

Here is the summary with links:
  - net: nixge: Use GFP_KERNEL instead of GFP_ATOMIC when possible
    https://git.kernel.org/netdev/net-next/c/6b48bece871e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


