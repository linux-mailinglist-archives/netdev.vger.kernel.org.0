Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3755E64C2
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiIVOKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbiIVOK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:10:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470AD6DAE5
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 07:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 558C4B836CF
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14DCEC433D7;
        Thu, 22 Sep 2022 14:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663855816;
        bh=lvL9LYrPpTA+L4Z0EHkpATH9nM3e3/TErI9fFNh0VF0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OaDJMN6y8ROoje8xe6Mn1T5xht6/9HTqifeBLzypLFcQWx1e2GVNmlDGyotEA0pTB
         wWzs6B1HI6DuTGeL25ZsfQGN3ENUw2wiCa0Ranrove3YnfOgN/ytzPuyy+v26c6ILE
         /5rZVKsit6wsFnu1tNbwe2GOVbf8Pr0nKcWp0CC0k/Xx9yaoibjFvbBiYYiCLqHKsm
         N5oPBOqyb4qaeyFF34XWdzklF1I0uULhiD+MjfdFiHxR0X4BQW+17eOIv3+A3gAv/w
         fZ4kJlRDdTipHSK0BQWVOhf7fcFRXRlI4dkZGUznoEmZgBIKZDpKAX742Ptc6Tql9B
         Qi+FINJHtIB1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F1515E4D03C;
        Thu, 22 Sep 2022 14:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] bonding: fix NULL deref in bond_rr_gen_slave_id
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166385581598.2095.4389439130979294872.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 14:10:15 +0000
References: <cover.1663694476.git.jtoppins@redhat.com>
In-Reply-To: <cover.1663694476.git.jtoppins@redhat.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, joamaki@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 20 Sep 2022 13:45:50 -0400 you wrote:
> Fix a NULL dereference of the struct bonding.rr_tx_counter member because
> if a bond is initially created with an initial mode != zero (Round Robin)
> the memory required for the counter is never created and when the mode is
> changed there is never any attempt to verify the memory is allocated upon
> switching modes.
> 
> The first patch provides a selftest to demonstrate the issue and the
> second patch fixes the issue.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] selftests: bonding: cause oops in bond_rr_gen_slave_id
    https://git.kernel.org/netdev/net/c/2ffd57327ff1
  - [net,v2,2/2] bonding: fix NULL deref in bond_rr_gen_slave_id
    https://git.kernel.org/netdev/net/c/0e400d602f46

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


