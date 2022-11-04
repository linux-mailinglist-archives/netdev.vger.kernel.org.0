Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3D261A544
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 00:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiKDXAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 19:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiKDXAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 19:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F022B2ED77;
        Fri,  4 Nov 2022 16:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADCCFB83020;
        Fri,  4 Nov 2022 23:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44C39C433D7;
        Fri,  4 Nov 2022 23:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667602816;
        bh=HWxljkC6hgBHG4jbsEpuHfrs2yxKF8LjpiiKVl+g9Pg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oRAWUuUzFwGHbVtkYdQwmGSpYsT0nH4OmfXritpTAghZmdDWfr3l8mqvgAtpZqt9c
         K/km4t+G/mCgT5DJIq6RMnRMD9ZQwV5TsfMfqb7nOpjSroB9fTS0bdA39Sy/qc5mGy
         4huWoYWmBcKRhruU//JK0bYrOkSSf29ptL2L0a7p6510JMyO94g5R2I0t+y4buFfPC
         srHUoMemxkJNAAAwMzYv73ETcXFDEODuAe3K7TP9xMTx7etEoul883aRVMZJQEXJRS
         F5f5RXXGzqpb37qtw+XCt1BWRqE5wgEFdBJ4q4Q+7A517RukoJgonKThE3dQGIey9I
         oApdFlwM2cIWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 27D6FE270FB;
        Fri,  4 Nov 2022 23:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: fix build-id for liburandom_read.so
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166760281615.32632.16528126406812945961.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 23:00:16 +0000
References: <20221104094016.102049-1-asavkov@redhat.com>
In-Reply-To: <20221104094016.102049-1-asavkov@redhat.com>
To:     Artem Savkov <asavkov@redhat.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ykaliuta@redhat.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  4 Nov 2022 10:40:16 +0100 you wrote:
> lld produces "fast" style build-ids by default, which is inconsistent
> with ld's "sha1" style. Explicitly specify build-id style to be "sha1"
> when linking liburandom_read.so the same way it is already done for
> urandom_read.
> 
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/bpf: fix build-id for liburandom_read.so
    https://git.kernel.org/bpf/bpf-next/c/61fc5e66f755

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


