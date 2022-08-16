Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB30E5963CE
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 22:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbiHPUkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 16:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237142AbiHPUkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 16:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC75C78BEF;
        Tue, 16 Aug 2022 13:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B742B81A7A;
        Tue, 16 Aug 2022 20:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0BC6CC433D6;
        Tue, 16 Aug 2022 20:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660682414;
        bh=6Kdy2sX6SfzqIoarDDxH5HjCQdKlh11iDu5No703RFg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ME/r3ZAgPHsKu7kppV616PrCqBJ6Q4eNm5IUjpp2kTThw1MrV9ASwKUrUE0iVWp+U
         zS5UDw8E7DbU5216k9NxuGae04t7M9V76y72+cycmSv/w2fYhMccNVGX7V3HSj63y6
         kT9R8YN6TPjXDHEXQ9zAw2+HgrvAI49AODrReRYtPk8m63SBDQfYx1m3sJpH4OQCv6
         x9E2SEZh15M+W2ZE89MPk7rmH72T5oTXkbxWqY6WHKyf98Ph9p/EHXJXewUTqdql4m
         EqRpOeBp7K3svT8x/ogAi9DwGD9ZkDOq0vQko/DI24P+mz7823ie5c6vdjR9WdIIX5
         +mdYemvOutD/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E711BE2A04D;
        Tue, 16 Aug 2022 20:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] selftests/bpf: fix attach point for non-x86
 arches in test_progs/lsm
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166068241394.3762.3527471181032772772.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Aug 2022 20:40:13 +0000
References: <20220816055231.717006-1-asavkov@redhat.com>
In-Reply-To: <20220816055231.717006-1-asavkov@redhat.com>
To:     Artem Savkov <asavkov@redhat.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Tue, 16 Aug 2022 07:52:31 +0200 you wrote:
> Use SYS_PREFIX macro from bpf_misc.h instead of hard-coded '__x64_'
> prefix for sys_setdomainname attach point in lsm test.
> 
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> ---
>  tools/testing/selftests/bpf/DENYLIST.s390x | 2 +-
>  tools/testing/selftests/bpf/progs/lsm.c    | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [bpf-next,v2] selftests/bpf: fix attach point for non-x86 arches in test_progs/lsm
    https://git.kernel.org/bpf/bpf-next/c/807662cac66a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


