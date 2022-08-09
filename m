Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E3A58DCA5
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 19:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245197AbiHIRAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 13:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245249AbiHIRAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 13:00:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F36A262F;
        Tue,  9 Aug 2022 10:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADDEDB8165D;
        Tue,  9 Aug 2022 17:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57B27C433C1;
        Tue,  9 Aug 2022 17:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660064414;
        bh=IlYt2GXL0Kv0NGOdSrr8ACS9GkgE6OyEFxzb5ToeNms=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pqg3E1B/OirUga1YLv4HjoGfoBo2z6ydtexdTSU8nI2rYwrig1za5MWCNV6Mt3W0n
         gK4ZLmbS52M4xzAT3WSxpAf39TaoDNsI/m9I2Zeqigc6e8iZ1uBbugPpVF1QYVznGz
         EeamsXztOGD7l2MOvb8yUQdUkVz3w6W6cc6wUq4BDEn5UXpNtWsdkNPzhX0BhxR6uj
         zEkuSm5/8jkGbfNeVhxtdzMmMEoUqw1UhwK5AW12w+5WA72Mz/SE9mP7M8mxQEHpQ1
         rOgjl1/jNlWjn6mgj7rD/pXSpg+iv89xT11bIMsbF17SUY5qp/REVcrpEEsHt7Z6jp
         FkbEKd12nvY0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43307C43143;
        Tue,  9 Aug 2022 17:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/2] Add BPF-helper for accessing CLOCK_TAI
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166006441427.21395.6653949715858271839.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Aug 2022 17:00:14 +0000
References: <20220809060803.5773-1-kurt@linutronix.de>
In-Reply-To: <20220809060803.5773-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        joannelkoong@gmail.com, jolsa@kernel.org, davemarchevsky@fb.com,
        lorenzo@kernel.org, geliang.tang@suse.com, jakub@cloudflare.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, tglx@linutronix.de,
        maciej.fijalkowski@intel.com, brouer@redhat.com
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

On Tue,  9 Aug 2022 08:08:01 +0200 you wrote:
> Hi,
> 
> add a BPF-helper for accessing CLOCK_TAI. Use cases for such a BPF helper
> include functionalities such as Tx launch time (e.g. ETF and TAPRIO Qdiscs),
> timestamping and policing.
> 
> Patch #1 - Introduce BPF helper
> Patch #2 - Add test case (skb based)
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/2] bpf: Add BPF-helper for accessing CLOCK_TAI
    https://git.kernel.org/bpf/bpf-next/c/c8996c98f703
  - [bpf-next,v2,2/2] selftests/bpf: Add BPF-helper test for CLOCK_TAI access
    https://git.kernel.org/bpf/bpf-next/c/64e15820b987

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


