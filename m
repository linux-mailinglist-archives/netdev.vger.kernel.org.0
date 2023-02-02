Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8BA6875C9
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 07:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjBBGUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 01:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjBBGUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 01:20:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3D180144;
        Wed,  1 Feb 2023 22:20:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70592B824DC;
        Thu,  2 Feb 2023 06:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C0F0C4339B;
        Thu,  2 Feb 2023 06:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675318817;
        bh=Y3+sWGAJZtwleWjt+mvtOp49cUAgQ3K8d5MIS6vDfMg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DfSPoPfU9vvy4jp8oktahjbh4sZyndvvILjAReMNmGB7aEw+wRdaLZu+VYIHThLtu
         PF4C6qBMOD2sgC6z5hvfLowQPtNDQ4iFON/Px2O7zJeE5SLoEgIe+ppjh4L4TFSPyd
         bjBJWlaILsA6RTjhD+iYDamizdSwORLzqjy8XtgfA7SYTQ/Kt6ga6AWg2FGOec6kZ2
         k2k3onk6sVOQ7rPl7JPdspVqzWAl2zSe5qcLzjRS414TCNwypSpoaewoUocn5sXJJZ
         qV0asa4YogvE6AfffiBw9MuCNnt3kui4tkskLwlR5RQfACHgs2d8GZ3CAPSqmdmk9V
         1zYg8A/Euh1vg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F1386E270CC;
        Thu,  2 Feb 2023 06:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] virtio-net: fix possible unsigned integer
 overflow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167531881698.1809.4464102208743775598.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 06:20:16 +0000
References: <20230131085004.98687-1-hengqi@linux.alibaba.com>
In-Reply-To: <20230131085004.98687-1-hengqi@linux.alibaba.com>
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, mst@redhat.com,
        jasowang@redhat.com, pabeni@redhat.com, kuba@kernel.org,
        john.fastabend@gmail.com, davem@davemloft.net,
        daniel@iogearbox.net, ast@kernel.org, edumazet@google.com,
        xuanzhuo@linux.alibaba.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 31 Jan 2023 16:50:04 +0800 you wrote:
> When the single-buffer xdp is loaded and after xdp_linearize_page()
> is called, *num_buf becomes 0 and (*num_buf - 1) may overflow into
> a large integer in virtnet_build_xdp_buff_mrg(), resulting in
> unexpected packet dropping.
> 
> Fixes: ef75cb51f139 ("virtio-net: build xdp_buff with multi buffers")
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] virtio-net: fix possible unsigned integer overflow
    https://git.kernel.org/netdev/net-next/c/981f14d42a7f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


