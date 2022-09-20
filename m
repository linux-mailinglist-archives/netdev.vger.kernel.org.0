Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C2A5BEAA5
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 18:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiITQA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 12:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiITQAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 12:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219901EED5
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 09:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87C3761FB4
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 16:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDE00C433D6;
        Tue, 20 Sep 2022 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663689614;
        bh=hb+Iqmw1WvTD9/STg9i251pexvJbPAyYKxtdHFSrtBw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M2wmz65grKAOyGWnrqyZ4belPdnqaMy3l5Hm+MZFQYGLuRMkv3gI3QPBeMttVTvkw
         pspwEMc2bXjPc0bT05313eVEX5y1XMP28WSXjw06SRAlh/QvdlI8oCrhXvf87ewH8Q
         JGfflDfJxU5KhESUNRB6FDgXk+8payOXgj03NqXMtZeCMisII5jDQlqyiNEea9qVzf
         EsIcYWJS9LaqfKv//QXLyjnWGUIJA6AUboHOT44iMtmAUcKc+TYkEqPAxoTs8BfHmS
         p3W6t/gmc7DLeF9Ta0tCq5Ij8MO2Vi5uIChhLVYpJSIF72P4Wz3YJXtgJ3+V4MdNDa
         EA2bUuLzi7Umg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BB711E21EDF;
        Tue, 20 Sep 2022 16:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH (repost) net-next] selftests/bonding: add a test for bonding
 lladdr target
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166368961475.21932.16139222412956023753.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 16:00:14 +0000
References: <20220920033047.173244-1-liuhangbin@gmail.com>
In-Reply-To: <20220920033047.173244-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, davem@davemloft.net,
        kuba@kernel.org, jtoppins@redhat.com, pabeni@redhat.com,
        dsahern@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 20 Sep 2022 11:30:47 +0800 you wrote:
> This is a regression test for commit 592335a4164c ("bonding: accept
> unsolicited NA message") and commit b7f14132bf58 ("bonding: use unspecified
> address if no available link local address"). When the bond interface
> up and no available link local address, unspecified address(::) is used to
> send the NS message. The unsolicited NA message should also be accepted
> for validation.
> 
> [...]

Here is the summary with links:
  - [(repost),net-next] selftests/bonding: add a test for bonding lladdr target
    https://git.kernel.org/netdev/net-next/c/152e8ec77640

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


