Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3220A50A34E
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 16:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389568AbiDUOxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 10:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390047AbiDUOxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 10:53:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632181BE94;
        Thu, 21 Apr 2022 07:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A906E61A90;
        Thu, 21 Apr 2022 14:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A648C385AA;
        Thu, 21 Apr 2022 14:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650552612;
        bh=hi1BHCF9UrqgrKaE8tKFI8d1XD0rxWot5QXbcog6rhU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vAta382Hs2CpbnAFkAMlXdGd/FCND3QVA3inG3bcNJNmV5a66iVYDFJSpS088fxw9
         SU/R4v8G8qPZ6jDglNeUwKoUQdWRfu9eDyscOs/1dYCAn5hLZ9I6DXRkLJIXiM3S+g
         p1sO4eF4jvBz0eOxEd/ZP2Quv1g1BpznzJxVJqQu15CBef68Zb6cvVHNSeh8GpD6ey
         C6/CDitsxKJBeSELkrMoJMnuifX1N4l78EKiTnCU18bh0hEFtj7ZHllHDPLDHneHhA
         iliHXPvSv/g5KHsrn5M4ao+wT9tIuqMTblK51ELSRg/SUqxg5yXxRZbwtg2Hb1E4D0
         DppWlxHXPgSYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E3D0BE8DD85;
        Thu, 21 Apr 2022 14:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: fix attach tests retcode checks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165055261192.3130.12571525492244740722.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Apr 2022 14:50:11 +0000
References: <20220421130104.1582053-1-asavkov@redhat.com>
In-Reply-To: <20220421130104.1582053-1-asavkov@redhat.com>
To:     Artem Savkov <asavkov@redhat.com>
Cc:     laoar.shao@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 21 Apr 2022 15:01:04 +0200 you wrote:
> Switching to libbpf 1.0 API broke test_sock and test_sysctl as they
> check for return of bpf_prog_attach to be exactly -1. Switch the check
> to '< 0' instead.
> 
> Fixes: b858ba8c52b6 ("selftests/bpf: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK")
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/bpf: fix attach tests retcode checks
    https://git.kernel.org/bpf/bpf-next/c/920fd5e1771d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


