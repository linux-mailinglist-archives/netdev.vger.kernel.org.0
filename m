Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD2E5AB3D8
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 16:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbiIBOku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 10:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236881AbiIBOkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 10:40:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7401C12484B;
        Fri,  2 Sep 2022 07:00:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64F8CB82C03;
        Fri,  2 Sep 2022 14:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1AE3CC433D7;
        Fri,  2 Sep 2022 14:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662127216;
        bh=6FkOE0V4Xl0gp19KmvjJh3tYe8TXuJxNaJXe5cYKWtY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QwevnPlVKT8sKyLUXOmFC3g8jLH3mwyfHt2ULozsHipTdWaNetXQIgZLubI6v789S
         by009iQSOMS11/xX/tVlKUyTnYoqRxIITAu7X9eTVFk/nuftkOx96+aeIsQhor1MHz
         l6yhZ1vEnPAOGFFVfk//OweyVjp+oU8gPOszu9XLwvdUHQUzMy++UmTGTgtbxPZDlU
         JsGMsul8wM8KStocJnEwWeya+1aAN4brXciTrlpRiktODdhG0Mv7GvJAVhmdYASBT5
         24H1WRL/J0eieDR18h5zDUYU0li3u9TMEKadsYyzB0s7RaD4XNDx+qmlWrwbyjWVhR
         ihxU86cWFOJmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EFF0DC4166F;
        Fri,  2 Sep 2022 14:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1] selftests/xsk: Avoid use-after-free on ctx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166212721597.8214.1758586217041951809.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Sep 2022 14:00:15 +0000
References: <20220901202645.1463552-1-irogers@google.com>
In-Reply-To: <20220901202645.1463552-1-irogers@google.com>
To:     Ian Rogers <irogers@google.com>
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, mykolal@fb.com,
        shuah@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu,  1 Sep 2022 13:26:45 -0700 you wrote:
> The put lowers the reference count to 0 and frees ctx, reading it
> afterwards is invalid. Move the put after the uses and determine the
> last use by the reference count being 1.
> 
> Fixes: 39e940d4abfa ("selftests/xsk: Destroy BPF resources only when ctx refcount drops to 0")
> Signed-off-by: Ian Rogers <irogers@google.com>
> 
> [...]

Here is the summary with links:
  - [v1] selftests/xsk: Avoid use-after-free on ctx
    https://git.kernel.org/bpf/bpf-next/c/af515a5587b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


