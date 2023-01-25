Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D680A67A8E4
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbjAYCkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjAYCkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC43849547
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 18:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A59D4B81887
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 401A8C4339B;
        Wed, 25 Jan 2023 02:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674614417;
        bh=xfaOMW8TyikfClFt9jI+lB2+SzqM84515/jGNSoC1gk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hqlsdxwRmWT+BBY3PZ+A5CzUKvLXuT/W5ENKGdMOsxV9rwjYFf8gi+waM9Gh03p6K
         ScTR1koPB9MuTmsICeYKUzzcoYP0jjv6kvX6UULbfNH14JtlF+QAD7c6N8iz5sFcf6
         Fl9yA7dZblYYLE8TsZje5j4zgNOhAAO6GY2Qu2RH7ObxEhpcV9ijE7l3tuLJMv+Dx9
         hamRGrFfLZueIJxAYd278Z+peu9+xUv8B/+CgolDVuxyIS1FbR2ftjTevIDWA6IRqf
         1vNbyx30hHMZ25wokgNYcGDqVI7OfA/bxHgUrZtxLJlA/OD3oGd6Y7OyXRbjwpWm+d
         wGoEvAS/qsC3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24F6FF83ECD;
        Wed, 25 Jan 2023 02:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: sch_taprio: do not schedule in taprio_reset()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167461441714.2895.3296174945529154857.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 02:40:17 +0000
References: <20230123084552.574396-1-edumazet@google.com>
In-Reply-To: <20230123084552.574396-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, vinicius.gomes@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 23 Jan 2023 08:45:52 +0000 you wrote:
> As reported by syzbot and hinted by Vinicius, I should not have added
> a qdisc_synchronize() call in taprio_reset()
> 
> taprio_reset() can be called with qdisc spinlock held (and BH disabled)
> as shown in included syzbot report [1].
> 
> Only taprio_destroy() needed this synchronization, as explained
> in the blamed commit changelog.
> 
> [...]

Here is the summary with links:
  - [net] net/sched: sch_taprio: do not schedule in taprio_reset()
    https://git.kernel.org/netdev/net/c/ea4fdbaa2f77

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


