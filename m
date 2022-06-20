Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC4955184E
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 14:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240926AbiFTMKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 08:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240472AbiFTMKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 08:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F8F1580A;
        Mon, 20 Jun 2022 05:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31D94B8110D;
        Mon, 20 Jun 2022 12:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0673C341C6;
        Mon, 20 Jun 2022 12:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655727017;
        bh=J7B0mVGZZLWlCR9GhZlQjlFwZp9D2TPXJeVMf+HQTXU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s4YPMxf4HfTpLpMbIXk5jOumkCJkBxfsnJcARfipfdz8qdzwrcv8ZF7eZEN1Y7SEn
         vZnlP5Wl+O+EpfNfLWlCdR7JinLtlOQdz0ENZtdV3K+LGpofmM0v6Ci6smlm/nvE+X
         uMR2Q+yzPgpB94eeXCw+Hm0nVIsyY/o91mC1wAkmY9Nnj5BsIpQdgq76izXXSUhHVe
         hbxN5Jhw0na/ooielbOSUCdQHGjV1tGs73a9wBfGbEohIqbzNIz5Es+gNNipP5/31k
         xgzDL9fTADyx6eMUNpM99dSVBrqQm/jWwBoCcG8Et0cDpwANfBWyVGHtVaum2LwM+X
         mECKmc3LjFtVQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7C58E73877;
        Mon, 20 Jun 2022 12:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch bpf-next v4 0/4] sockmap: some performance optimizations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165572701688.4813.1208806792598960392.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Jun 2022 12:10:16 +0000
References: <20220615162014.89193-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20220615162014.89193-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        cong.wang@bytedance.com
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

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 15 Jun 2022 09:20:10 -0700 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> This patchset contains two optimizations for sockmap. The first one
> eliminates a skb_clone() and the second one eliminates a memset(). With
> this patchset, the throughput of UDP transmission via sockmap gets
> improved by 61%.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v4,1/4] tcp: introduce tcp_read_skb()
    https://git.kernel.org/bpf/bpf-next/c/04919bed948d
  - [bpf-next,v4,2/4] net: introduce a new proto_ops ->read_skb()
    https://git.kernel.org/bpf/bpf-next/c/965b57b469a5
  - [bpf-next,v4,3/4] skmsg: get rid of skb_clone()
    https://git.kernel.org/bpf/bpf-next/c/57452d767fea
  - [bpf-next,v4,4/4] skmsg: get rid of unncessary memset()
    https://git.kernel.org/bpf/bpf-next/c/43312915b5ba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


