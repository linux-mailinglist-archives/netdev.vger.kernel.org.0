Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62AF539999
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 00:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348479AbiEaWkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 18:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238162AbiEaWkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 18:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8773F9EB4A;
        Tue, 31 May 2022 15:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23DAD61468;
        Tue, 31 May 2022 22:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F7EAC3411D;
        Tue, 31 May 2022 22:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654036812;
        bh=4cd7A12mmB7TOFG1oNOqmQmjZoSqWu2ThW8sKS2FhmY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ePU8nggokZOUGbrVKMRgoXk1AjyOxfFmbvGUNPTB+EKtObcTwS/DQ61tZNjOePdSt
         7zivQqMyoBXVO/01C0juKlMB7YWZlZ3FR0BsWEs/HJT8IpMX8CaE17jWTgjB8rQd+I
         0Ogv/AX1cBPppgI+pMZ5DDJMNzs/fXFa7LDko+7KNBhcfa+Gsw7Gih1wE+VLFb8X+F
         WFsFmx3OkC+TPqvRGVtaeV2JpMHkJK/3E+f07nbNDRTUcdZVPgEuZg37vCn12qRC9M
         s+2liPRW3TEQEkfzYODhQ4Uhur2KJXhNijZdfyD3wE6Ab2xvbwj5+0pT9WMYu3XI/P
         xON7OBoyJfBhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4D6A9F0394D;
        Tue, 31 May 2022 22:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Check for NULL ptr of btf in codegen_asserts
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165403681231.3395.15965102902497727563.git-patchwork-notify@kernel.org>
Date:   Tue, 31 May 2022 22:40:12 +0000
References: <20220523194917.igkgorco42537arb@jup>
In-Reply-To: <20220523194917.igkgorco42537arb@jup>
To:     Michael Mullin <masmullin@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Mon, 23 May 2022 15:49:17 -0400 you wrote:
> bpf_object__btf() can return a NULL value.  If bpf_object__btf returns
> null, do not progress through codegen_asserts(). This avoids a null ptr
> dereference at the call btf__type_cnt() in the function find_type_for_map()
> 
> Signed-off-by: Michael Mullin <masmullin@gmail.com>
> ---
>  tools/bpf/bpftool/gen.c | 3 +++
>  1 file changed, 3 insertions(+)

Here is the summary with links:
  - Check for NULL ptr of btf in codegen_asserts
    https://git.kernel.org/bpf/bpf-next/c/d992a11f1171

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


