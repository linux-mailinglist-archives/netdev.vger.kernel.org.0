Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F4B4F6B2D
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbiDFUVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 16:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbiDFUUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 16:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9F3D64EB;
        Wed,  6 Apr 2022 10:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36C5B61877;
        Wed,  6 Apr 2022 17:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84880C385A6;
        Wed,  6 Apr 2022 17:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649265011;
        bh=xSrCEBSsJnPxdLsw5PcYQS2kSjcI4PZfvNGUBFUwlrs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mPyuQURaz43BGAfoc/4yXG7KVpPCzEMIhuwU2Rd6+DHmP6VuRZltEwz0s8dY/9yni
         wVuclD0XeanW5IQbiIa2p+fb8hx0Vg11jqToogG7pFOBhrlOa/ezzxyDpCvaIdaO69
         R7DarjErfpYgSq653U/nAe1lQzOB7Y0X+4C+XNBZ2o4xzN6H+N7WFl5OdYps2J5sAT
         u3UFZF26ocahqlBy9zw9f5cZts0njMYo1vJlODKGe0sNcPzFds433mYc11YMiDng1Y
         lmZ3d0erguNOiYGsWM1lbIahNkurrwuEvVKHYb+H5lbSaYk0i3xcqRYd3vpvwRT+ne
         uzJmMmIaRF/Hg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B4EDE85D53;
        Wed,  6 Apr 2022 17:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] net: netfilter: reports ct direction in CT lookup
 helpers for XDP and TC-BPF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164926501135.17190.3211103529600690232.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 17:10:11 +0000
References: <aa1aaac89191cfc64078ecef36c0a48c302321b9.1648908601.git.lorenzo@kernel.org>
In-Reply-To: <aa1aaac89191cfc64078ecef36c0a48c302321b9.1648908601.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, lorenzo.bianconi@redhat.com, brouer@redhat.com,
        toke@redhat.com, memxor@gmail.com, netfilter-devel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Alexei Starovoitov <ast@kernel.org>:

On Sat,  2 Apr 2022 16:19:14 +0200 you wrote:
> Report connection tracking tuple direction in
> bpf_skb_ct_lookup/bpf_xdp_ct_lookup helpers. Direction will be used to
> implement snat/dnat through xdp ebpf program.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/netfilter/nf_conntrack_bpf.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)

Here is the summary with links:
  - [bpf-next] net: netfilter: reports ct direction in CT lookup helpers for XDP and TC-BPF
    https://git.kernel.org/bpf/bpf-next/c/1963c740dc2b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


