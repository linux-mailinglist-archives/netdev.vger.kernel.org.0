Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1802250A67A
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 19:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390501AbiDURDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 13:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244831AbiDURDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 13:03:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4B6BF74;
        Thu, 21 Apr 2022 10:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4F10B827BC;
        Thu, 21 Apr 2022 17:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 928D8C385A9;
        Thu, 21 Apr 2022 17:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650560413;
        bh=LqSx1ccCXr4EU6ioPYE8PZl6oVAW/e3S2k2NY6dyj8w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DsolDC4DsFFO05FD6VwwwvC86RFVT6lSPovK1o2kT4I1qfwn1jIfY2z5GUUmwY/5J
         s609K619MPjbTvHvFaTIwuZUr2nPofXIH7/HtGLJDN/DEjRLkPUFKdBPJUYCIBHeQ3
         wGWUM+TVXrRVYqSDfMaidoFq8EJB1YW8KS5ccYPko5EsbnFrrIpnd89eeqG4Xp2RfN
         MWKBOSaMSvycKcZPV0vyERNO20rCSty2hV4f8fKv8RFp+nIggkHV53ZJXclQdCjT8F
         rJn+NLBFY2GIRpKCFWMwV+Xw6scuLoXZ4OAXMMvi+qxIBEG27Po0K6RycCm270L/Su
         zRw3K9ka0Dc/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 756A9E8DBD4;
        Thu, 21 Apr 2022 17:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: fix map tests errno checks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165056041347.10585.10754473335372308106.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Apr 2022 17:00:13 +0000
References: <20220421094320.1563570-1-asavkov@redhat.com>
In-Reply-To: <20220421094320.1563570-1-asavkov@redhat.com>
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
by Andrii Nakryiko <andrii@kernel.org>:

On Thu, 21 Apr 2022 11:43:20 +0200 you wrote:
> Switching to libbpf 1.0 API broke test_lpm_map and test_lru_map as error
> reporting changed. Instead of setting errno and returning -1 bpf calls
> now return -Exxx directly.
> Drop errno checks and look at return code directly.
> 
> Fixes: b858ba8c52b6 ("selftests/bpf: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK")
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/bpf: fix map tests errno checks
    https://git.kernel.org/bpf/bpf-next/c/c14766a8a8f3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


