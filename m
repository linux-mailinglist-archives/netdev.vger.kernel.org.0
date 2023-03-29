Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCC26CD419
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjC2IKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbjC2IK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:10:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6D54239;
        Wed, 29 Mar 2023 01:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5625561B5A;
        Wed, 29 Mar 2023 08:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D206C433EF;
        Wed, 29 Mar 2023 08:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680077426;
        bh=jlhpbxOg9G4XA6mXvTUL0TMYClhDe77zuebhO7J62LE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=luJqRGOpwpjMI9TaEfuG4hQXT4HQlc3qivS3w3CYcAtmMA2fA7djiY6PQhpbyq17U
         JdDXeGdlIlrekERYHdzAZx/T1jg+gOs07dFT9YigZWoi/xTTSbxwxCpE50AklLASn1
         k4ZSqIzSqgeg51ATTc8e74kffHBuFj1wQo77beWvbLu8oZLMbi0+H+KFKenfrqupTY
         YTp68UW5NCJ6vModFtODC6+dnMTKCyvSqTrjDpmeVPiGoHPJ+ZF9Dh06GENN7BXLIW
         oSx0TPp09LtmzpWOi+yecWKQ5Zk/HIpfpkk+Kx1hMwNarYwueT4uGPSD5gL0tCu6Rp
         9VXPdt5RkvO2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 88381C41612;
        Wed, 29 Mar 2023 08:10:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] mptcp: a couple of cleanups and
 improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168007742655.16006.993088598018364960.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Mar 2023 08:10:26 +0000
References: <20230324-upstream-net-next-20230324-misc-features-v2-0-fca1471efbaa@tessares.net>
In-Reply-To: <20230324-upstream-net-next-20230324-misc-features-v2-0-fca1471efbaa@tessares.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     mptcp@lists.linux.dev, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, geliang.tang@suse.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 27 Mar 2023 12:22:20 +0200 you wrote:
> Patch 1 removes an unneeded address copy in subflow_syn_recv_sock().
> 
> Patch 2 simplifies subflow_syn_recv_sock() to postpone some actions and
> to avoid a bunch of conditionals.
> 
> Patch 3 stops reporting limits that are not taken into account when the
> userspace PM is used.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] mptcp: avoid unneeded address copy
    https://git.kernel.org/netdev/net-next/c/2bb9a37f0e19
  - [net-next,v2,2/4] mptcp: simplify subflow_syn_recv_sock()
    https://git.kernel.org/netdev/net-next/c/a88d0092b24b
  - [net-next,v2,3/4] mptcp: do not fill info not used by the PM in used
    https://git.kernel.org/netdev/net-next/c/e925a0322ada
  - [net-next,v2,4/4] selftests: mptcp: add mptcp_info tests
    https://git.kernel.org/netdev/net-next/c/9095ce97bf8a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


