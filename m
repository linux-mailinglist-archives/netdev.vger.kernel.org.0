Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C436584AED
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbiG2FAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234171AbiG2FAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2F8167DA
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 22:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59ABDB826D2
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 05:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07E9DC433C1;
        Fri, 29 Jul 2022 05:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659070816;
        bh=bmeRjbgmF/BYwcNwXoRtrPe3Svp9HwLZZhzPhOWA/sk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rFkMq5T57N+GmqvW4rT4WvbaEmSQnj8of81X0V89xbFaN4xXL0OL/LVVNFPGyVhNY
         sRTDGH6gEfVacXLy+DIlO219Z8j5izC9GmJZ6amybvi1aiuG/vcP/UyJEUQGJzVLkx
         r6QemvmEMFcsRFmcHCUBpIIe0qUcqnOtW5pjCztZKuEZ3YQrkW3r/Sz6nYSw9RFsLf
         3FsAH7DjDXVXqmLUyFJQrMcb7Z5IIGea8Mp4X5+gAuS3GR2Usousm+7UhTV4Q58RSo
         vjRkSI+HibKyLwkt+zAkdZtzBg0X6DCoRqmmdrRDMxZsG1ENxNZfQ/ayFF8MdrBLrr
         934+Ng8Hw4PFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7437C43143;
        Fri, 29 Jul 2022 05:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] tls: rx: follow ups to rx work
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165907081587.3346.17648225664118232297.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 05:00:15 +0000
References: <20220727031524.358216-1-kuba@kernel.org>
In-Reply-To: <20220727031524.358216-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
        maximmi@nvidia.com, tariqt@nvidia.com, vfedorenko@novek.ru
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Jul 2022 20:15:20 -0700 you wrote:
> A selection of unrelated changes. First some selftest polishing.
> Next a change to rcvtimeo handling for locking based on an exchange
> with Eric. Follow up to Paolo's comments from yesterday. Last but
> not least a fix to a false positive warning, turns out I've been
> testing with DEBUG_NET=n this whole time.
> 
> Jakub Kicinski (4):
>   selftests: tls: handful of memrnd() and length checks
>   tls: rx: don't consider sock_rcvtimeo() cumulative
>   tls: strp: rename and multithread the workqueue
>   tls: rx: fix the false positive warning
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] selftests: tls: handful of memrnd() and length checks
    https://git.kernel.org/netdev/net-next/c/86c591fb9142
  - [net-next,2/4] tls: rx: don't consider sock_rcvtimeo() cumulative
    https://git.kernel.org/netdev/net-next/c/70f03fc2fc14
  - [net-next,3/4] tls: strp: rename and multithread the workqueue
    https://git.kernel.org/netdev/net-next/c/d11ef9cc5a67
  - [net-next,4/4] tls: rx: fix the false positive warning
    https://git.kernel.org/netdev/net-next/c/e20691fa36c4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


