Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDA85E5775
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 02:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiIVAkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 20:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiIVAkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 20:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3C567CBB;
        Wed, 21 Sep 2022 17:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E61ADB8338B;
        Thu, 22 Sep 2022 00:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EE27C433B5;
        Thu, 22 Sep 2022 00:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663807214;
        bh=dDXS6E9mDuwjouF994xVa3KdzW2QLTRlr9y2ZHE9RXU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N5Pp7+4MD738kgNDgLorAnoNSmmLAd/B+XIg76NKVXGe+mlDOEQDsyV+9u5nvhqY8
         WGMVEDkkWhkfRdRmexCA/8dooUHHIimLqubAOen0A99JYRY5EJgJiaBdSGymb6nRkg
         RA4DxwddQQaLvuyRkrsCNBf8Xkj1qgjQVBCb+G8PElGz9EKAoYg2ntwXT1AA4iQ6wy
         wzm28Yfw5q7+rsOMOuAx6WPt39MbgJpbxbY0uBLt44o32Fq34hWc4t/I9Wo44lfDL5
         URAc4ybNcUhuwjXLLE9HQo8HOylAANEncaVfQDGfkzlWuU+F01VdwdXS03hAb/6J45
         wTSyKTPcEYPDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6DBC8E4D03D;
        Thu, 22 Sep 2022 00:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] libbpf: Support raw btf placed in the default path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166380721444.7808.9756811358401247254.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 00:40:14 +0000
References: <3f59fb5a345d2e4f10e16fe9e35fbc4c03ecaa3e.1662999860.git.chentao.kernel@linux.alibaba.com>
In-Reply-To: <3f59fb5a345d2e4f10e16fe9e35fbc4c03ecaa3e.1662999860.git.chentao.kernel@linux.alibaba.com>
To:     Tao Chen <chentao.kernel@linux.alibaba.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, yhs@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Andrii Nakryiko <andrii@kernel.org>:

On Tue, 13 Sep 2022 00:43:00 +0800 you wrote:
> Now only elf btf can be placed in the default path(/boot), raw
> btf should also can be there.
> 
> Signed-off-by: Tao Chen <chentao.kernel@linux.alibaba.com>
> ---
> v2->v1: Remove the locations[i].raw_btf check
> 
> [...]

Here is the summary with links:
  - [v2] libbpf: Support raw btf placed in the default path
    https://git.kernel.org/bpf/bpf-next/c/01f2e36c959c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


