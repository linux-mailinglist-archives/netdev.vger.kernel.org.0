Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681D959EF43
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 00:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiHWWbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 18:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbiHWWa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 18:30:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB581DA5A;
        Tue, 23 Aug 2022 15:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD2F9B821B0;
        Tue, 23 Aug 2022 22:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7756DC433D6;
        Tue, 23 Aug 2022 22:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661293815;
        bh=ujSIJUlEVs/+oL2Im+aBRilKdGVaar+Cm/DETM614qI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BTh1fsJf5ryqGNUOZc0nfoBwfV8QKvJ465IXBa1cckNtKmZhRjQVmNkKP0hTfLGI4
         HB3wnuDDH7UkD/uIOAdCwUgLwRg7Jju0SopA7idZ2r+lHeBscJmUwTkVXDPuWcqjl1
         qPX/BUEbgVh/QbfWQTKfc03Foi2d+Q/jkrfiLQtcWWMl6UzLdNhH+3OqJVXhiH2LIz
         iIaYujP2T9mcDvsmWvuu+W3nw4cW99WCzAVQZ1KoJPOE3EJzaZknRbkQouJu08dYtR
         vTsARN5fPCpS/ENQELHcRnym1SShl9lOih4ApxE1kqvthFe/MwZNvFjr2zGMcNUeKR
         e6mtMMv0z/Qew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B044E1CF31;
        Tue, 23 Aug 2022 22:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 bpf] bpf: Fix a data-race around bpf_jit_limit.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166129381536.18992.16583576763608887925.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 22:30:15 +0000
References: <20220823215804.2177-1-kuniyu@amazon.com>
In-Reply-To: <20220823215804.2177-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kuni1840@gmail.com, bpf@vger.kernel.org, netdev@vger.kernel.org
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

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 23 Aug 2022 14:58:04 -0700 you wrote:
> While reading bpf_jit_limit, it can be changed concurrently via sysctl,
> WRITE_ONCE() in __do_proc_doulongvec_minmax().  The size of bpf_jit_limit
> is long, so we need to add a paired READ_ONCE() to avoid load-tearing.
> 
> Fixes: ede95a63b5e8 ("bpf: add bpf_jit_limit knob to restrict unpriv allocations")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> 
> [...]

Here is the summary with links:
  - [v3,bpf] bpf: Fix a data-race around bpf_jit_limit.
    https://git.kernel.org/bpf/bpf/c/0947ae112108

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


