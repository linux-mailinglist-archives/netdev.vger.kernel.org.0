Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86AC687BBE
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbjBBLKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbjBBLKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:10:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BE49754;
        Thu,  2 Feb 2023 03:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4109761AE4;
        Thu,  2 Feb 2023 11:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98283C4339C;
        Thu,  2 Feb 2023 11:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675336217;
        bh=i1XmpH5nFD5KatiJd8PdfMED3WBVaS8RfChHbqKsLq8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uDRejtrbeDiNTQ/ZGplqCfS5zDJxYXOWI03wW8o5MosfAkGHU444SKC1zaWkX3m7l
         hjofhYHR6KBVDCYxBTAo+2ECwX7a0Qw5iCyakdvKamHESwSEHczfe4MxpFIN0oZICP
         DjMCOw1Sf06SNDJTPFLh68aHOBKZq04/gFV3GR+28Ej6IuhHW1dG3Zx88sshZ1INVc
         4eEoXZd+gRP6LmhlgRYg8wfS9nttzfimKoBK98rAfZ4Oo+vnA3EjlAAVDQGdRls2FZ
         vAREUfnhCc6guZ7YRffetldFa7sddnl/s/UE9YwdzLNZ+XCxdaJt6IB9wqXrvGosUl
         ApHFCVRA/S+MQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 75FA5E50D67;
        Thu,  2 Feb 2023 11:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: =?utf-8?q?=5BPATCH=5D_selftests/bpf=3A_remove_duplicate_include_hea?=
        =?utf-8?q?der_in_files?=
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167533621747.1751.226846406285857027.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 11:10:17 +0000
References: <202301311440516312161@zte.com.cn>
In-Reply-To: <202301311440516312161@zte.com.cn>
To:     <ye.xingchen@zte.com.cn>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, mykolal@fb.com, shuah@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 31 Jan 2023 14:40:51 +0800 (CST) you wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> linux/net_tstamp.h is included more than once.
> 
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> ---
>  tools/testing/selftests/bpf/xdp_hw_metadata.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - selftests/bpf: remove duplicate include header in files
    https://git.kernel.org/bpf/bpf-next/c/4bc32df7a9c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


