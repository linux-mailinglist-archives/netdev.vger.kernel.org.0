Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9239C6E8934
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 06:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbjDTEkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 00:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbjDTEkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 00:40:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FC255B7;
        Wed, 19 Apr 2023 21:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC97664282;
        Thu, 20 Apr 2023 04:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32964C433EF;
        Thu, 20 Apr 2023 04:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681965620;
        bh=EVkDgFk+gzSXEfIGqXu2Mh/eirZ1Wt0Isn7WHGFVFuU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Czp+7piA4XvkVhNtzE3DC9SmfDkRbyliWCJstJuwIu6+QPeMdT4EaoIXps1wR0Ozz
         mV0X1Ljm2Kf/hABKCRYyLzyfDjGAYlscEAdVyae+aeeAUMNNK057YroNeALfKvtFal
         7Hsn2fqgF8gKhsmEaz84mA6RqFcxOdfAbUEtZ98yzZKUw+f0xb+JJkt/OHO6mqI558
         XRGLDYmV/4RIV+EmFss6xR+Qk101MvMu5MYC+NPv2169IFcyo6uD7IWKZEbTldardp
         4v0iHUmiDKryZG9111fmtq1QundV4a07FCvbGPxugWrxOURvjEq/n+dWADgSEDduaN
         MYYsZEyaYmPXQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 13AECC395C8;
        Thu, 20 Apr 2023 04:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/2] Access variable length array relaxed for
 integer type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168196562006.24751.2408162871776218216.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Apr 2023 04:40:20 +0000
References: <20230420032735.27760-1-zhoufeng.zf@bytedance.com>
In-Reply-To: <20230420032735.27760-1-zhoufeng.zf@bytedance.com>
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, yangzhenze@bytedance.com,
        wangdongdong.6@bytedance.com, zhouchengming@bytedance.com
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

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu, 20 Apr 2023 11:27:33 +0800 you wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> Add support for integer type of accessing variable length array.
> Add a selftest to check it.
> 
> Feng Zhou (2):
>   bpf: support access variable length array of integer type
>   selftests/bpf: Add test to access integer type of variable array
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/2] bpf: support access variable length array of integer type
    https://git.kernel.org/bpf/bpf-next/c/2569c7b8726f
  - [bpf-next,v2,2/2] selftests/bpf: Add test to access integer type of variable array
    https://git.kernel.org/bpf/bpf-next/c/5ff54dedf35b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


