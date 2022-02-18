Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59ABC4BAF34
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 02:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbiBRBqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 20:46:13 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiBRBqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 20:46:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CE1195040;
        Thu, 17 Feb 2022 17:45:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2038061CAE;
        Fri, 18 Feb 2022 01:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 762E1C340EC;
        Fri, 18 Feb 2022 01:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645148756;
        bh=yPCf3NleS7lyxt9W6EULBVhYVvRccwymn8EC8BsE4ok=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KcjXQI+VO1p13TobLJVasUAtOQk7MAIfI1sHVJO6VK+jUq4Qcz8gaoctUQOoW9pu3
         QmxBPxSqUiPl4hwuAF4p2HykufbZ3jINvXlUcbZO0Am33OsCqud/uUKYWigOk4ElXR
         rhRBoigJ/t1+0A8Q/NFdS5F+EnK1E38OPsKaGG9KXKzKQAbcD5w662tKspaLpOej6R
         wH7kRnM/IE+z0RboBDHL5z2J+FW5yP0rlnL8YFlDPP23SnXFbs954zVYSUl1I8ylIV
         Lr8o9GnY8s2ZC5XWmS52m+crU/fUFlOUuwCwTJ6eK2uzyv2jqSNyakp2ikT9D6XlGB
         00AepzPXqIosA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 633E9E6D447;
        Fri, 18 Feb 2022 01:45:56 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-02-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164514875640.23246.1698080683417187339.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 01:45:56 +0000
References: <20220217232027.29831-1-daniel@iogearbox.net>
In-Reply-To: <20220217232027.29831-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to bpf/bpf.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Feb 2022 00:20:27 +0100 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 29 non-merge commits during the last 8 day(s) which contain
> a total of 34 files changed, 1502 insertions(+), 524 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-02-17
    https://git.kernel.org/bpf/bpf/c/7a2fb9128515

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


