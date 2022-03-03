Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07674CC146
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 16:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbiCCPa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 10:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiCCPa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 10:30:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E53F12B762;
        Thu,  3 Mar 2022 07:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20D1161CFA;
        Thu,  3 Mar 2022 15:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82D9AC340E9;
        Thu,  3 Mar 2022 15:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646321410;
        bh=TFHKdErn1efAgOUxyCbqHz8lzGpyNnKB0ee+1jr3Md0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ruNht79vN9e5Zyc5IuCVo3+CSFqgbPJGJrcGCBz5guUbgh/7WMLPrKEsxQM7uL8XH
         r3d+JhScyu9/AUU6B6lCa4fSxAK+M6/T916l0J7ASJMIPuWZNAWROB6lVDg/mSMPcf
         RW9obuz/yzKXdWhOa8G512YyKBWMwkyz8aExtTlt7QKM0Osc4v2iJfj0T55M+VRCv5
         cSeL9ss+S3U+v/6G2R4AyEklnHLjkka3XqKk7D2giXB/ePwJW5Qeb1x7gj+dG6F1JQ
         M3S1wcpgikjpsQdpdLh9i3/uZ/6YDrgk9nByo3qh7Oe4d6FOj9xIyFqBH4F9s5dP3/
         08sdxxHBrxtDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5EBE7E5D087;
        Thu,  3 Mar 2022 15:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] libbpf: Add a check to ensure that page_cnt is
 non-zero
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164632141038.18423.8019591299586086867.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 15:30:10 +0000
References: <20220303005921.53436-1-ytcoode@gmail.com>
In-Reply-To: <20220303005921.53436-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     andrii.nakryiko@gmail.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu,  3 Mar 2022 08:59:21 +0800 you wrote:
> The page_cnt parameter is used to specify the number of memory pages
> allocated for each per-CPU buffer, it must be non-zero and a power of 2.
> 
> Currently, the __perf_buffer__new() function attempts to validate that
> the page_cnt is a power of 2 but forgets checking for the case where
> page_cnt is zero, we can fix it by replacing 'page_cnt & (page_cnt - 1)'
> with 'page_cnt == 0 || (page_cnt & (page_cnt - 1))'.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] libbpf: Add a check to ensure that page_cnt is non-zero
    https://git.kernel.org/bpf/bpf-next/c/41332d6e3a43

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


