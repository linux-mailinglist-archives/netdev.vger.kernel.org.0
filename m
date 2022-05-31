Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242385399CC
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 00:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348570AbiEaWuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 18:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348634AbiEaWuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 18:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B0BA0061;
        Tue, 31 May 2022 15:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B944CB8173F;
        Tue, 31 May 2022 22:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60C4CC3411C;
        Tue, 31 May 2022 22:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654037413;
        bh=4krzuHq2XEO+Dd9ce2RPc3T1kMROId1Rwx3zGEpNPUQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i4PKfPzPtVQAOzy4HWbhBkm/3pLKcDztNIn8ZnBa8jJy63wR97s5/f58Yda4G6brW
         VGxvN4qtiY+Bu85ezS7MdEdXseMnEl+wrriepRxSokq+O/eL/K4CPffCLsZ9U0WFvA
         8prUiPEivaTDON/Yow0JtusBD2TgSEud1sTP8/fv1wVLeKh/E8fyf1lkPJtFcI0uzy
         hjFasiGRZX5aGX5drplxSgzBjosmjj6GDRfI54E7G8fP2mJ7wKCCXmyQ1DaljucgIB
         Ab2+92z27dr4jtvzC1Xqm3IFrgVPxZzgO19uxlMwe/d1Vs2jLcDYTxZcX2WE0t6Bch
         KbZI+mWKZZuSA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42649F0383D;
        Tue, 31 May 2022 22:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] sample: bpf: xdp_router_ipv4: allow the kernel to
 send arp requests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165403741326.9645.206199420871428808.git-patchwork-notify@kernel.org>
Date:   Tue, 31 May 2022 22:50:13 +0000
References: <60bde5496d108089080504f58199bcf1143ea938.1653471558.git.lorenzo@kernel.org>
In-Reply-To: <60bde5496d108089080504f58199bcf1143ea938.1653471558.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Wed, 25 May 2022 11:44:27 +0200 you wrote:
> Forward the packet to the kernel if the gw router mac address is missing
> in to trigger ARP discovery.
> 
> Fixes: 85bf1f51691c ("samples: bpf: Convert xdp_router_ipv4 to XDP samples helper")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  samples/bpf/xdp_router_ipv4.bpf.c | 9 +++++++++
>  1 file changed, 9 insertions(+)

Here is the summary with links:
  - [bpf-next] sample: bpf: xdp_router_ipv4: allow the kernel to send arp requests
    https://git.kernel.org/bpf/bpf-next/c/4c7cbcc9c097

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


