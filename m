Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF8458F06E
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 18:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbiHJQaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 12:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiHJQaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 12:30:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18321C90E;
        Wed, 10 Aug 2022 09:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C304B81DAC;
        Wed, 10 Aug 2022 16:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B97EC433B5;
        Wed, 10 Aug 2022 16:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660149017;
        bh=/ge8eXJjSRXJk7F9+f4QoYVS3kECFUflxoC7imgUrdw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Meomu0zxwnJBSYG6zTIAjuFky8hOkycAOEGQcypzHAPExj7F4MGTZ4b6WNUFmnbYR
         h6wAKHfAE+k3b3uhOB0a9m4jl9HYu0Ex3ohFkkN/KSve56mA9LXwkZigOVciLa0ksn
         hIUUXxGPbeY6lMdTIEkmwvo8Di7JiJvQSM0pc4glgZuninkSxJRIdnLUo13PVnY0iL
         gPCumeMGnq/O1zpjfqadrKvCYDlvuj0OZEFWXezdDdoXqYmNa9/MTBTRb6OXb1Kdvq
         En4HkrAFlC3iSoc92wh83h3+dJ43s5qfHBqtp/si56bf0lMGb1psGDYjRxtzvd6Ur4
         0FCjIkfyYuBvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F1CD1C43143;
        Wed, 10 Aug 2022 16:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v5 0/3] destructive bpf_kfuncs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166014901698.26898.12684147799083436971.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Aug 2022 16:30:16 +0000
References: <20220810065905.475418-1-asavkov@redhat.com>
In-Reply-To: <20220810065905.475418-1-asavkov@redhat.com>
To:     Artem Savkov <asavkov@redhat.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, aarcange@redhat.com,
        dvacek@redhat.com, olsajiri@gmail.com, song@kernel.org,
        dxu@dxuuu.xyz, memxor@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 10 Aug 2022 08:59:02 +0200 you wrote:
> eBPF is often used for kernel debugging, and one of the widely used and
> powerful debugging techniques is post-mortem debugging with a full memory dump.
> Triggering a panic at exactly the right moment allows the user to get such a
> dump and thus a better view at the system's state. Right now the only way to
> do this in BPF is to signal userspace to trigger kexec/panic. This is
> suboptimal as going through userspace requires context changes and adds
> significant delays taking system further away from "the right moment". On a
> single-cpu system the situation is even worse because BPF program won't even be
> able to block the thread of interest.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v5,1/3] bpf: add destructive kfunc flag
    https://git.kernel.org/bpf/bpf-next/c/4dd48c6f1f83
  - [bpf-next,v5,2/3] bpf: export crash_kexec() as destructive kfunc
    https://git.kernel.org/bpf/bpf-next/c/133790596406
  - [bpf-next,v5,3/3] selftests/bpf: add destructive kfunc test
    https://git.kernel.org/bpf/bpf-next/c/e33894581675

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


