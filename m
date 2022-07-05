Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB66567412
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 18:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbiGEQUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 12:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbiGEQUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 12:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1687917A87
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 09:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A698161BD5
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 16:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09B23C341CB;
        Tue,  5 Jul 2022 16:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657038013;
        bh=s4nDol/A2atAPW6vCsODQE03Lu0r+t7jZI4437WuBLI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kh6Ipc3d4FJ4bFnyPTQSZcEvanZ6LgZ8Y0u4O6ZrOt4AM+teOrI5EGYR2XaeVu2J6
         1KHQq41kxzv05t1UR88/1eOfa3M2xhNr0yQWJ3HUAkzTkFGCaujV5wvo6QSaPzB2IX
         7XNur88DumI3HZMOqBEheZlv+pn5Q8ZtlMpibkrvWwMxObmp59WwR7BO09IaD1gg+E
         b6qAFuZy4vQ5teUMP9CVWOyw5own05OzCeBrK8IkevXIruKwVxsaLHgPKbuPnqmUEX
         jhSAtvyg9oqB33j2+6kqubzRIPlZ/T/ZafIshY8OgyeoD83RcX8rlByIyjn5PDUReW
         YHwKAbgXYrtBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0B9AE45BD8;
        Tue,  5 Jul 2022 16:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] man: tc-fq_codel: add drop_batch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165703801291.4255.1024212036009540878.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Jul 2022 16:20:12 +0000
References: <1656411171-6314-1-git-send-email-inoguchi.yuki@fujitsu.com>
In-Reply-To: <1656411171-6314-1-git-send-email-inoguchi.yuki@fujitsu.com>
To:     Yuki Inoguchi <inoguchi.yuki@fujitsu.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        edumazet@google.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Tue, 28 Jun 2022 19:12:51 +0900 you wrote:
> Let's describe the drop_batch parameter added to tc command
> by Commit 7868f802e2d9 ("tc: fq_codel: add drop_batch parameter")
> 
> Signed-off-by: Yuki Inoguchi <inoguchi.yuki@fujitsu.com>
> ---
>  man/man8/tc-fq_codel.8 | 7 +++++++
>  1 file changed, 7 insertions(+)

Here is the summary with links:
  - [iproute2] man: tc-fq_codel: add drop_batch
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=2a00a4b1e9d8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


