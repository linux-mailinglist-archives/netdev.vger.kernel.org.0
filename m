Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACFE55222B4
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 19:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348204AbiEJReO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 13:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245083AbiEJReN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 13:34:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFFB2BF332;
        Tue, 10 May 2022 10:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12A84B81E74;
        Tue, 10 May 2022 17:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9A39C385C9;
        Tue, 10 May 2022 17:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652203812;
        bh=ZqJI+Ky/W416jqB8rjrXqQ8wZtVnl7Mpn4gSi6p96W8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YLwSVKC4MnOlb+ZejszvnwwO8SI3BeZ43DUrI93rA8VY9B73CHR5d9hqvTWxKDHt4
         IAT4mt0vVOYe7A/z+0MdHVYnyULKDYS6c05yzaK68okZYCEDKS/kcwxGoh6gLDj9uR
         Y6GfJHYmfPIhng7bgH0JMF5onGwyiC8JumF8DBVVESLSohJ1QgiM3ql/djXO9tqzL6
         LPgnMc2Vr/pOpuIFZxHT+YUyHRSp1UR3TbymLEQBXuIv+ZqqJqrME+Bwf1hPRlgq9t
         8oukD6VQKewm0TwMz+xOOdauCVvxije+NRVeEnretlxee1w+43PYt09z69ZjCk7TXL
         uIiHHvxJajlPg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8C37EF03876;
        Tue, 10 May 2022 17:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/2] Modify some code in sysctl_net_core.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165220381256.21854.15122506494053007856.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 17:30:12 +0000
References: <1652153703-22729-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1652153703-22729-1-git-send-email-yangtiezhu@loongson.cn>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        lixuefeng@loongson.cn, netdev@vger.kernel.org, bpf@vger.kernel.org,
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

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Tue, 10 May 2022 11:35:01 +0800 you wrote:
> Tiezhu Yang (2):
>   net: sysctl: Use SYSCTL_TWO instead of &two
>   bpf: Print some info if disable bpf_jit_enable failed
> 
>  net/core/sysctl_net_core.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [bpf-next,v2,1/2] net: sysctl: Use SYSCTL_TWO instead of &two
    https://git.kernel.org/bpf/bpf-next/c/f922c8972fb5
  - [bpf-next,v2,2/2] bpf: Print some info if disable bpf_jit_enable failed
    https://git.kernel.org/bpf/bpf-next/c/174efa781165

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


