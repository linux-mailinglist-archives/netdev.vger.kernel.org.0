Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D953B4B906D
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 19:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237732AbiBPSka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 13:40:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237717AbiBPSk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 13:40:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B742AC923;
        Wed, 16 Feb 2022 10:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 218B0B81FC5;
        Wed, 16 Feb 2022 18:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4B5AC340ED;
        Wed, 16 Feb 2022 18:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645036809;
        bh=ntq/Fw9GV4QP9NL+oK+oVjBsMSwxz33xX0Eh6dmJR7U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hzS49fyAMr/Mz/R/fDtjqpCnhVpDrPRDtUKFA+sPSEwsH8rHkULBTZ2CXZA9fJf4f
         HzzGXBBlWa1OYXoiJesIm1aLfMGcw5g52TCBdLFbFdqiJoOhJvE7OOnGCDIwSpvd1X
         QPCNW5w7JV1vYx6VNfJt7wAV7OG1EQG3OZE1rDcgEAEJ6WvtxYxJvARE+NOwrcnRj7
         S5gSh1Jtvi4KBC0HxsZ8E36M+LoSJoje8xx/dwDiufM9fb7Aayiz7sDcDm7wHIfYrf
         OXeZZrDKrnF+QF8aZdCAMmAwPuy83A3Zq8Wb0NxUJPCVh+VRrayLoqfUOqZE6mYhLU
         IFkdZiFm6Xd5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 914C7E5D07D;
        Wed, 16 Feb 2022 18:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpftool: Fix pretty print dump for maps without BTF
 loaded
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164503680959.7965.12987975510885594675.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Feb 2022 18:40:09 +0000
References: <20220216092102.125448-1-jolsa@kernel.org>
In-Reply-To: <20220216092102.125448-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        yinjun.zhang@corigine.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Andrii Nakryiko <andrii@kernel.org>:

On Wed, 16 Feb 2022 10:21:02 +0100 you wrote:
> The commit e5043894b21f ("bpftool: Use libbpf_get_error() to check error")
> fails to dump map without BTF loaded in pretty mode (-p option).
> 
> Fixing this by making sure get_map_kv_btf won't fail in case there's
> no BTF available for the map.
> 
> Cc: Yinjun Zhang <yinjun.zhang@corigine.com>
> Fixes: e5043894b21f ("bpftool: Use libbpf_get_error() to check error")
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpftool: Fix pretty print dump for maps without BTF loaded
    https://git.kernel.org/bpf/bpf-next/c/2e3f7bed2837

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


