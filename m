Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5474D4EC5A8
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 15:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346067AbiC3NcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 09:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346043AbiC3Nb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 09:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49DB26564;
        Wed, 30 Mar 2022 06:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 509B961136;
        Wed, 30 Mar 2022 13:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5D1BC34115;
        Wed, 30 Mar 2022 13:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648647011;
        bh=lXSt1n+kUTY9e8f3TxDtywZVanJ1TBQwaQRkmU1riT4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iqi33w0ue8E32uHd5v6BHvgjcXCDi99doQWMJdPPyKIz/tPo1GI/CEtEeTuOY/WjJ
         J/3Me9NxWIY2hKyp3mQV7otYQ/hzwOE6KGYzCM4UUV0ZZU/D0Zadk4DhkvIDmgRlJz
         VQx/t7OAoGTqvryEk0AhC7wVHRXITARzMZsdTEid+xY2xbtRPAq0BZ50hKtV1XSV3B
         ilHhEeNnWT0PFV4XL9g7KI0cZCC2J42Qu+mQFmuKHyR5z3qswWAIDKiAJfevzkbwhi
         ALNWi+MzmcnF4YF92DhcLm/qaqXxjiB5NuOdBJuOHdHTkUpV70VlZi9wUCwpWwHgp+
         F0HK0F26rPzLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8235EF03848;
        Wed, 30 Mar 2022 13:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2] selftests/bpf: Fix warning comparing pointer to 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164864701152.1602.13754664724920166896.git-patchwork-notify@kernel.org>
Date:   Wed, 30 Mar 2022 13:30:11 +0000
References: <1648605588-19269-1-git-send-email-baihaowen@meizu.com>
In-Reply-To: <1648605588-19269-1-git-send-email-baihaowen@meizu.com>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed, 30 Mar 2022 09:59:48 +0800 you wrote:
> Avoid pointer type value compared with 0 to make code clear.
> 
> reported by coccicheck:
> tools/testing/selftests/bpf/progs/map_ptr_kern.c:370:21-22:
> WARNING comparing pointer to 0
> tools/testing/selftests/bpf/progs/map_ptr_kern.c:397:21-22:
> WARNING comparing pointer to 0
> 
> [...]

Here is the summary with links:
  - [V2] selftests/bpf: Fix warning comparing pointer to 0
    https://git.kernel.org/bpf/bpf/c/2609f635a20d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


