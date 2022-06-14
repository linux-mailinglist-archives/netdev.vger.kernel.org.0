Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B50854BBE2
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 22:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238534AbiFNUhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 16:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238908AbiFNUhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 16:37:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF983617A;
        Tue, 14 Jun 2022 13:37:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9C02615A1;
        Tue, 14 Jun 2022 20:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 238AAC341CB;
        Tue, 14 Jun 2022 20:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655239035;
        bh=kOfdMYH3VWcT2Z/Ep++LxfNeY1lDo8Xl0lLYoxu+QKc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G0e8X3kU6tVSEssl1e64dcn48aei6oMwI+vlhQdz7n+UzydxTU8KaqLnZYFB8anVA
         S9eIMNTSKV5SmbbBTJcBfr0OdMV7i3RrQtzCRLlowgz28/wb0Q7ieyByeCdFAUhwUH
         N03xmzIx1/WzZygn3Y2cx4/jU2/7+zJyX8d9RDwO3Ga5iWUZtPJgBhXMgKnfOpFr1I
         ScuB2F0zov/XU5wlqErQtmBuEoB+nPyQhzdtukAAdBzCqY7XBDm53wiDq9qT3OWuTK
         xn72e/SO8jxSAU8+QDuJE3sRUTkwbqHKoEnvYmG99R76CZhn0UeeueYkfwZPInDYNJ
         qv8p6ykOi5Aqw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F456E73856;
        Tue, 14 Jun 2022 20:37:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/2] bpftool: Restore memlock rlimit bump
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165523903505.29335.14557399406891586610.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Jun 2022 20:37:15 +0000
References: <20220610112648.29695-1-quentin@isovalent.com>
In-Reply-To: <20220610112648.29695-1-quentin@isovalent.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        laoar.shao@gmail.com, harshmodi@google.com, paul@cilium.io,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 10 Jun 2022 12:26:46 +0100 you wrote:
> We recently removed the uncondtional rlimit bump from bpftool, deferring it
> to libbpf to probe the system for memcg-based memory accounting and to
> raise the rlimit if necessary.
> 
> This probing is based on the availability of a given BPF helper, and his
> known to fail on some environments where the helper, but not the memcg
> memory accounting, has been backported.
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/2] Revert "bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK"
    https://git.kernel.org/bpf/bpf-next/c/6b4384ff1088
  - [bpf-next,2/2] bpftool: Do not check return value from libbpf_set_strict_mode()
    https://git.kernel.org/bpf/bpf-next/c/93270357daa9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


