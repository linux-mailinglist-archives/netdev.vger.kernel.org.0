Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524CD4F875D
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 20:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346990AbiDGSwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 14:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346971AbiDGSwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 14:52:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7D6118676;
        Thu,  7 Apr 2022 11:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15CC761DE2;
        Thu,  7 Apr 2022 18:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 713ADC385A6;
        Thu,  7 Apr 2022 18:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649357412;
        bh=1DfmZOE6cy4qc+BvIkkyjg9fe8B8HHTXkVo3mqaoYWY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jO33Uw31mF9bJmMHu+b3wqgq3ziYuwVfdxyTXNrHQh9clvHCtkELUFepEbgPKzeZS
         1wNMm9l4th46IbH1C83j3Difd3y43RUqQOlGwSDUm+LgzGhaw4DzXyd0tAWHGpokhW
         bXQK22mCl1SHyE/7AnuL17NR49/tqYfM2TLjNtef1QmXCrnGngyq8fd6FHFqoaX57p
         dXb1FTNeJOP6Yc8lag7mc9Dr9Pv4iHBqWgcakoFUxwc8s0nTB80Bz67+wR7ggpbzWZ
         Jbeh9y68oN+TcvgpsjbMPpX14+LMiIOAPPZXvjQA7z4U6obWAaGbxQ3SK58lksW+CZ
         p5q+YINOeFJDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 55E50E8DD18;
        Thu,  7 Apr 2022 18:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 0/3] libbpf: uprobe name-based attach followups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164935741234.5642.724903556157196483.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Apr 2022 18:50:12 +0000
References: <1649245431-29956-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1649245431-29956-1-git-send-email-alan.maguire@oracle.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
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
by Andrii Nakryiko <andrii@kernel.org>:

On Wed,  6 Apr 2022 12:43:48 +0100 you wrote:
> Follow-up series to [1] to address some suggestions from Andrii to
> improve parsing and make it more robust (patches 1, 2) and to improve
> validation of u[ret]probe firing by validating expected argument
> and return values (patch 3).
> 
> [1] https://lore.kernel.org/bpf/164903521182.13106.12656654142629368774.git-patchwork-notify@kernel.org/
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,1/3] libbpf: improve library identification for uprobe binary path resolution
    https://git.kernel.org/bpf/bpf-next/c/a1c9d61b19cb
  - [v2,bpf-next,2/3] libbpf: improve string parsing for uprobe auto-attach
    https://git.kernel.org/bpf/bpf-next/c/90db26e6be01
  - [v2,bpf-next,3/3] selftests/bpf: uprobe tests should verify param/return values
    https://git.kernel.org/bpf/bpf-next/c/1717e248014c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


