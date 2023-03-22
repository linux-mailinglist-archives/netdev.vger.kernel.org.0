Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598396C50EE
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjCVQk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjCVQkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:40:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C58618149;
        Wed, 22 Mar 2023 09:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D52E621DB;
        Wed, 22 Mar 2023 16:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF4FAC4339B;
        Wed, 22 Mar 2023 16:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679503219;
        bh=sVg4yxbpimgOSm9EVuuZNoWc5/53ZSGdfgZotNj8i8Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mGybP9mb8vj5RNmyqhUvS7TQ6vaz2Bi3mJFSCVdjnPnKMFJrfnPQ/jB/ZhGqc0p2U
         Or3f0eMtfNEZERgmHpvpwqH4emFdQS3JDl4m3XSEOZnk4i5lK6S+31w+TSvbanTXuQ
         7RIqzeXRGJpv/BW5KMhL2+ch4g1S821ErKRUkCO2A+DfGZrAb3L5U0lnzRc1TA8GRd
         WjkzEdf993pL36SudRb3FlQ9jLzznQ97Y4lPqykMSvyLI7nn1CHQcbg7ImyG/r6Pam
         +AnpwDPBPwTHnuDOiJ9zlaqF3qj/QUwRCy/cLj9KUsRRejCNd2NC49HxZbsbayUTH1
         Q7A/xnQR6TlUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CC215E4F0DA;
        Wed, 22 Mar 2023 16:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 0/4] bpf: Support ksym detection in light
 skeleton.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167950321882.15421.17050507774988368715.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Mar 2023 16:40:18 +0000
References: <20230321203854.3035-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20230321203854.3035-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, void@manifault.com, davemarchevsky@meta.com,
        tj@kernel.org, memxor@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Tue, 21 Mar 2023 13:38:50 -0700 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> v1->v2: update denylist on s390
> 
> Patch 1: Cleanup internal libbpf names.
> Patch 2: Teach the verifier that rdonly_mem != NULL.
> Patch 3: Fix gen_loader to support ksym detection.
> Patch 4: Selftest and update denylist.
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,1/4] libbpf: Rename RELO_EXTERN_VAR/FUNC.
    https://git.kernel.org/bpf/bpf-next/c/a18f721415b4
  - [v2,bpf-next,2/4] bpf: Teach the verifier to recognize rdonly_mem as not null.
    https://git.kernel.org/bpf/bpf-next/c/1057d2994596
  - [v2,bpf-next,3/4] libbpf: Support kfunc detection in light skeleton.
    https://git.kernel.org/bpf/bpf-next/c/708cdc5706a4
  - [v2,bpf-next,4/4] selftests/bpf: Add light skeleton test for kfunc detection.
    https://git.kernel.org/bpf/bpf-next/c/3b2ec2140fa2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


