Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E039D4D1043
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 07:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243548AbiCHGbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 01:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242155AbiCHGbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 01:31:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7973CA5B;
        Mon,  7 Mar 2022 22:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F290E615EA;
        Tue,  8 Mar 2022 06:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55C4AC340FC;
        Tue,  8 Mar 2022 06:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646721011;
        bh=WFHmEO+qM4oBqzX1Gg1yyznrCWEXa3Rr+pEOVmv32F8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g2Bu33U54eQsWxNVWqdPATbAlunswIhnKOcKxJ4MXLrOYEqkUmO30D4Hb8ook7+CF
         6Vym8UvnKwQ1qjSOxt17TVwLXUa3WD/1zaOgb/4U68mKB4kMhTOORC1hGKuVNYy5F4
         x5kfyNNRmHueA477h8ALKl4KvAUlJ5QakmbPwQvOq37YWX2UAd320ThvdvTP9M1R+e
         4ty4GPBOSnZXgbsR8TXJWaYhtYLktriXu7yR+v9Os/G7PHybcOEd2279w7RAEOFBcy
         CxyqmWLWJrLQUAU1MS3XlirDbeKiVfvhcplKi8kwIWLKHo8x6fJxIHuVOxrNTmWlNn
         HElMIeB4SipIw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4012EF0383A;
        Tue,  8 Mar 2022 06:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ice: xsk: fix GCC version checking against pragma
 unroll presence
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164672101125.16776.2136234286176245062.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Mar 2022 06:30:11 +0000
References: <20220307231353.56638-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220307231353.56638-1-maciej.fijalkowski@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, alexandr.lobakin@intel.com,
        sfr@canb.auug.org.au
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  8 Mar 2022 00:13:53 +0100 you wrote:
> Pragma unroll was introduced around GCC 8, whereas current xsk code in
> ice that prepares loop_unrolled_for macro that is based on mentioned
> pragma, compares GCC version against 4, which is wrong and Stephen
> found this out by compiling kernel with GCC 5.4 [0].
> 
> Fix this mistake and check if GCC version is >= 8.
> 
> [...]

Here is the summary with links:
  - [net-next] ice: xsk: fix GCC version checking against pragma unroll presence
    https://git.kernel.org/netdev/net-next/c/13d04d79701b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


