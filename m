Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F52E51295D
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 04:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbiD1CN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 22:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbiD1CN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 22:13:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7A3167E2;
        Wed, 27 Apr 2022 19:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52D94614FD;
        Thu, 28 Apr 2022 02:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56C50C385AE;
        Thu, 28 Apr 2022 02:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651111811;
        bh=0WuR48jqZYSi0jXnzmj/Yy1hr4bMel3wjpJQh9AZ0SU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b5GDmLY8qbgpAjxd0/yggHdEwqkOr4gygmy7PLkisGkbrYTD0U8rwXQvqe7xiSrVJ
         CP/sHcVLCaHFr3ph7xRmh1VvxD4TuIE7Z+jjhsFTm8hkv7Kgj0vt5cVQLxSqj/TBTM
         1EOASGZ56NF6LzsVIz9PHPuOd5e1p8EbEl2c0B6pZNsik1AhpCT1LbRLomb8RxTkEe
         V5BeXFZ8tIapHbHUe2tUbL1KH2o+lKBnrcKXqNracNZEo1mZTjDULYoWBj2gl3UF8s
         w8i9N+QSj212WKgpizUOt4uW04jxAvyZ3Yv8vXda85SWr6LjdovjYWgd9sNTpqp36L
         P4PujujgQsc4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 38C7CF03840;
        Thu, 28 Apr 2022 02:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2,bpf-next] samples/bpf: detach xdp prog when program exits
 unexpectedly in xdp_rxq_info_user
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165111181122.23123.4291776273920701411.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 02:10:11 +0000
References: <20220427062338.80173-1-shaozhengchao@huawei.com>
In-Reply-To: <20220427062338.80173-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Wed, 27 Apr 2022 14:23:38 +0800 you wrote:
> When xdp_rxq_info_user program exits unexpectedly, it doesn't detach xdp
> prog of device, and other xdp prog can't be attached to the device. So
> call init_exit() to detach xdp prog when program exits unexpectedly.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  samples/bpf/xdp_rxq_info_user.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [v2,bpf-next] samples/bpf: detach xdp prog when program exits unexpectedly in xdp_rxq_info_user
    https://git.kernel.org/bpf/bpf-next/c/d1c57439e4f3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


