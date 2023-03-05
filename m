Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF9A6AB176
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 18:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjCERAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 12:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCERAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 12:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71BC1423D
        for <netdev@vger.kernel.org>; Sun,  5 Mar 2023 09:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E50460B0A
        for <netdev@vger.kernel.org>; Sun,  5 Mar 2023 17:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF4E1C4339B;
        Sun,  5 Mar 2023 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678035617;
        bh=InRRDPmzS4gjO5pedD+NI3Y7bgPmcRASo6sbKGo9xPk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e29Pem7qpd/e/68MvqKlWnqmeLNdpDGg9JP83T8Tndfjf4fj2bak0ErPRm4zSkgqQ
         mUJ/wAv4Bi1u4j0uYd81yv8XUDSrzyhq056BBejjogtkTA0eQXxOn7rI3ghl/93PMH
         WzHClaPSf5p5diHIhe86BhOMt0P2XALx7HVgIMrvd2cWI8IQUXIFxY9jSljRCySDFY
         yjgGJjDjPdwW1ui5WAXWMvfKKGBlHhjY00VmumOIpTk43FWrLCG4Ng62pwgjB1gbCe
         FcqEVROrQC0QMLqStYwY117PRhknYxY3vLc5IDc64VbF975cfQ9zklGHkYFLCPcgdI
         5JmyXGJBTPrnA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 924CCC41679;
        Sun,  5 Mar 2023 17:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2 v2 0/3] tc: parse index argument correctly
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167803561759.1759.10330960403184292446.git-patchwork-notify@kernel.org>
Date:   Sun, 05 Mar 2023 17:00:17 +0000
References: <20230227184510.277561-1-pctammela@mojatatu.com>
In-Reply-To: <20230227184510.277561-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com,
        stephen@networkplumber.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Mon, 27 Feb 2023 15:45:07 -0300 you wrote:
> Following the kernel side series, we fix the iproute2 side to parse the
> index argument correctly.
> It's valid in the TC architecture to pass to create a filter that
> references an action object:
> "tc filter ... action csum index 1"
> 
> v1->v2:
> - Don't use matches()
> 
> [...]

Here is the summary with links:
  - [iproute2,v2,1/3] tc: m_csum: parse index argument correctly
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=89d7346aa908
  - [iproute2,v2,2/3] tc: m_mpls: parse index argument correctly
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=af6fd6b84554
  - [iproute2,v2,3/3] tc: m_nat: parse index argument correctly
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=7375ab684228

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


