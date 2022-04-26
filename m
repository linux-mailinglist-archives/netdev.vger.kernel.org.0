Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4124F50ED36
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 02:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbiDZANV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 20:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiDZANU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 20:13:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1AF3B3E9;
        Mon, 25 Apr 2022 17:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4166CB8074E;
        Tue, 26 Apr 2022 00:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00ECCC385A9;
        Tue, 26 Apr 2022 00:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650931811;
        bh=DRSpxPd7qVaVXTjpoytPMwyKvcZ5Q5VPUYa2gyc4as8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t1LfkDkPmm3u3cpQCAVVWLfHxXKpuQsCtOTlRhiym/2QtbtYitcSEGOnQhRcADJBn
         B8JmlXEvYGb/t/6ge1QRv/tO9bWy32YHnPrDMOV5P9KXxCR28774X9TvxLAJ5Xy0tb
         9bVr5BQnW/HIHIc+cdrJFewIG0+u/3G3w7+KoDaQoWUzx7ab0Szvh5dYZdFIzGQiTQ
         qFvhPczqamQDtgkeLVpAaXv85SpBsZ+fPMxXXpdFCeYjmKhcf5G2t6iuP8CT7XBA3B
         1h4YRKnr7HJrCRS+49HOUPbVLlVnn8to6pohg9dcsJRatjqnHtByUx4pNPdKHAGY8N
         zXyOPk4dFGxbw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D97B1E8DD85;
        Tue, 26 Apr 2022 00:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] bpf: use bpf_prog_run_array_cg_flags everywhere
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165093181088.15811.2672901359924239994.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Apr 2022 00:10:10 +0000
References: <20220425220448.3669032-1-sdf@google.com>
In-Reply-To: <20220425220448.3669032-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com
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
by Alexei Starovoitov <ast@kernel.org>:

On Mon, 25 Apr 2022 15:04:48 -0700 you wrote:
> Rename bpf_prog_run_array_cg_flags to bpf_prog_run_array_cg and
> use it everywhere. check_return_code already enforces sane
> return ranges for all cgroup types. (only egress and bind hooks have
> uncanonical return ranges, the rest is using [0, 1])
> 
> No functional changes.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] bpf: use bpf_prog_run_array_cg_flags everywhere
    https://git.kernel.org/bpf/bpf-next/c/d9d31cf88702

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


