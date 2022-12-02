Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF1563FF5D
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 05:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbiLBEKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 23:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiLBEKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 23:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F47D11E4;
        Thu,  1 Dec 2022 20:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C93C460EB6;
        Fri,  2 Dec 2022 04:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24E16C433D6;
        Fri,  2 Dec 2022 04:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669954217;
        bh=pvbdrw2uluSXvI2wJT4YA58zebBGLGSd7PXpdZyX6+0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RsNRda0WhkrTeppGrYiJ5vwc/zZvxcZWwuveJvFAiU55h/eA3WQYp5WL375lxJDQU
         A/nZofR3gZtf9nJD10jEOMy3QmmET359TnlNDd9tslsnTYvDpPkWF9Dodqaw7gojKH
         SamaKgNxc+0Uj07F3gJVbaTIkhD0OIubPwiNQiCrTTv4TsWOhVXxMry//SvZH10NOK
         BKmb6Ss2gQ1+0ePzmuupYrdsRQL5xbRqkKHMzynl94Z9abcZqo7/epDCKrep/yIvsD
         JJfdQzs2xcGKtpQWn230V4yB1h9TpN/Pv7uxR3ZXWC0vX6DNL9ZWOEXMONaB2e7mrt
         oKSkrlnBqm5qA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0350BE270C8;
        Fri,  2 Dec 2022 04:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 0/5] net/tcp: Dynamically disable TCP-MD5 static key
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166995421700.16716.17446147162780881407.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Dec 2022 04:10:17 +0000
References: <20221123173859.473629-1-dima@arista.com>
In-Reply-To: <20221123173859.473629-1-dima@arista.com>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, dsahern@kernel.org,
        edumazet@google.com, peterz@infradead.org, ardb@kernel.org,
        gilligan@arista.com, davem@davemloft.net, 0x7f454c46@gmail.com,
        fruggeri@arista.com, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        jbaron@akamai.com, jpoimboe@kernel.org, pabeni@redhat.com,
        noureddine@arista.com, rostedt@goodmis.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 23 Nov 2022 17:38:54 +0000 you wrote:
> Changes from v5:
> - Corrected comment for static_key_fast_inc_not_negative() (Peter)
> - Renamed static_key_fast_inc_not_negative() =>
>   static_key_fast_inc_not_disabled() (as suggested by Peter)
> - static_key_fast_inc_not_disabled() is exported and declared in the
>   patch 1 that defines it, rather than in patch 3 that uses it (Peter)
> 
> [...]

Here is the summary with links:
  - [v6,1/5] jump_label: Prevent key->enabled int overflow
    https://git.kernel.org/netdev/net-next/c/eb8c507296f6
  - [v6,2/5] net/tcp: Separate tcp_md5sig_info allocation into tcp_md5sig_info_add()
    https://git.kernel.org/netdev/net-next/c/f62c7517ffa1
  - [v6,3/5] net/tcp: Disable TCP-MD5 static key on tcp_md5sig_info destruction
    https://git.kernel.org/netdev/net-next/c/459837b522f7
  - [v6,4/5] net/tcp: Do cleanup on tcp_md5_key_copy() failure
    https://git.kernel.org/netdev/net-next/c/b389d1affc2c
  - [v6,5/5] net/tcp: Separate initialization of twsk
    https://git.kernel.org/netdev/net-next/c/c5b8b515a211

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


