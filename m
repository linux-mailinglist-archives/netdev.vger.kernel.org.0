Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2373363C2D5
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbiK2Okr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235654AbiK2Okq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:40:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11043E0A7;
        Tue, 29 Nov 2022 06:40:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 721D0B811B9;
        Tue, 29 Nov 2022 14:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A131C433D7;
        Tue, 29 Nov 2022 14:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669732843;
        bh=UIxTiuBbQF/oT9Hpk2m285apFDMknI2PrvP15UyDywI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rYfv6q94eApQX+XXVbWZRmPrcLAWn6mQtSpHFV7FssuyG7nCRXntVSFEAuPacS430
         dFROgS/bfobPKMP/ynjAhYqYE4UU6M57MIXPxQKP1FzBAN5Kyj3JBxo79xba1dKbhU
         5tA9ppUs7EfwtDxTZYVO9j4Fw02WRAga1u/6358e2pgCtBZ7457+5lhHNt2PUpoZPz
         9ztfQZYa5h8MLcldE7y0s8tRoyP1xgqMBJFQOueicEmN0RkilqVGNVaMybX3vrDdz7
         R7vLs/b80tnzvSCzEcdQXx5gOLmzQJ6E8e4q/8p9x8Bqb7A8vWpkMQHMTiftcUxrtD
         HRejR54o2vfzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DCDA8E29F38;
        Tue, 29 Nov 2022 14:40:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-11-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166973284289.21597.300737036751163588.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 14:40:42 +0000
References: <20221125012450.441-1-daniel@iogearbox.net>
In-Reply-To: <20221125012450.441-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to bpf/bpf.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 25 Nov 2022 02:24:50 +0100 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 101 non-merge commits during the last 11 day(s) which contain
> a total of 109 files changed, 8827 insertions(+), 1129 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-11-25
    https://git.kernel.org/bpf/bpf/c/4f4a5de12539

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


