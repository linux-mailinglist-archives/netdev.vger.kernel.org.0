Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187A963E304
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiK3WAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiK3WAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963F27CABA;
        Wed, 30 Nov 2022 14:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55878B81D12;
        Wed, 30 Nov 2022 22:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE438C433C1;
        Wed, 30 Nov 2022 22:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669845617;
        bh=Mr/RVyOnCFGBZw3YsJAapeaNt05hDD/LJYzWuVyT0lQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DcmGlCh7osx/s+CAs8tOn9Hs7xcgjx5RDSg57VNFInbaS/Ad0DdrF/mT4VzZv90ef
         DWY0Kl/TbyV2F2CHK7jkD4UB8yP1Ikr9Tik0ZF+EKVL1LPb9yvm8lifoHKoVkQfbQk
         t6KLyVnBvX82PBEql8oxQRfiLWcxhdLPY3infWAySwLt0Am9w5Dx8MN1RlHs6LusQr
         SQ+XzdRXx0wl9AEax0EVAQNV+704a5IjL7mLk4GxOYaUWFIYA6TohRPgSzgYYgzuWh
         6gzWFqAbotIOLzhjX/rnIiE5VO49HaaHtdknKJz6IUHUANsX1TUGcXgBQVjaLTqTGi
         sJk7lonqzXXtw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C6F58C5C7C6;
        Wed, 30 Nov 2022 22:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/7] selftests/bpf: Remove unnecessary mount/umount
 dance
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166984561780.15567.8811230443975135659.git-patchwork-notify@kernel.org>
Date:   Wed, 30 Nov 2022 22:00:17 +0000
References: <20221129070900.3142427-1-martin.lau@linux.dev>
In-Reply-To: <20221129070900.3142427-1-martin.lau@linux.dev>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, kernel-team@meta.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Mon, 28 Nov 2022 23:08:53 -0800 you wrote:
> From: Martin KaFai Lau <martin.lau@kernel.org>
> 
> Some of the tests do mount/umount dance when switching netns.
> It is error-prone like https://lore.kernel.org/bpf/20221123200829.2226254-1-sdf@google.com/
> 
> Another issue is, there are many left over after running some of the tests:
> #> mount | egrep sysfs | wc -l
> 19
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/7] selftests/bpf: Use if_nametoindex instead of reading the /sys/net/class/*/ifindex
    https://git.kernel.org/bpf/bpf-next/c/052c82dcdcbb
  - [bpf-next,2/7] selftests/bpf: Avoid pinning bpf prog in the tc_redirect_dtime test
    https://git.kernel.org/bpf/bpf-next/c/57d0863f1d28
  - [bpf-next,3/7] selftests/bpf: Avoid pinning bpf prog in the tc_redirect_peer_l3 test
    https://git.kernel.org/bpf/bpf-next/c/f1b73577bb3c
  - [bpf-next,4/7] selftests/bpf: Avoid pinning bpf prog in the netns_load_bpf() callers
    https://git.kernel.org/bpf/bpf-next/c/5dc42a7fc286
  - [bpf-next,5/7] selftests/bpf: Remove the "/sys" mount and umount dance in {open,close}_netns
    https://git.kernel.org/bpf/bpf-next/c/3084097c369c
  - [bpf-next,6/7] selftests/bpf: Remove serial from tests using {open,close}_netns
    https://git.kernel.org/bpf/bpf-next/c/9b6a77739737
  - [bpf-next,7/7] selftests/bpf: Avoid pinning prog when attaching to tc ingress in btf_skc_cls_ingress
    https://git.kernel.org/bpf/bpf-next/c/443f216448ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


