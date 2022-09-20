Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373E65BED41
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 21:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiITTAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 15:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiITTAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 15:00:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD0C62AAC
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 12:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1112BB82CA0
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 19:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA849C4314C;
        Tue, 20 Sep 2022 19:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663700419;
        bh=r2jSfnoxRkz/dbSFLy5ER4wlTHNA2HU1xtjTeNhPkCU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uTsM+QJeLmMmlw2959F6jLPpyJnKhkQ0OEcozY8FW6JGzbJq7LVDEhmPGPao4x5Nm
         Jxg18E9xNPkhSQwpRW3iLsEA+48Ogjy5PfdbvDqOqgYzdP3Zx5dtETzqulLGojCSnT
         57RzZzU5gY4lb2WUl6RVJnos6y4hiWscd0hbRriwsObs5WaWiXZyCFgaXZZmhjshOx
         5ujuohEfwoecaPZqIDCw5rwOnUKly3Dvf//D1UymMWviKy7hevgNySd1tM1V1eMCk/
         zdA9XNTJ4vO705SFJ4j9RW/zrwOb5ETEi+g3nSJGvIwDw7Sxduq6NoeH5zgoq1HBFK
         YqT/uXVAwSVHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A3C8E5250B;
        Tue, 20 Sep 2022 19:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: Fix crash when IPv6 is administratively disabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166370041962.20640.14707705781785128996.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 19:00:19 +0000
References: <20220916084821.229287-1-idosch@nvidia.com>
In-Reply-To: <20220916084821.229287-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, rroberto2r@gmail.com, mlxsw@nvidia.com
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

On Fri, 16 Sep 2022 11:48:21 +0300 you wrote:
> The global 'raw_v6_hashinfo' variable can be accessed even when IPv6 is
> administratively disabled via the 'ipv6.disable=1' kernel command line
> option, leading to a crash [1].
> 
> Fix by restoring the original behavior and always initializing the
> variable, regardless of IPv6 support being administratively disabled or
> not.
> 
> [...]

Here is the summary with links:
  - [net] ipv6: Fix crash when IPv6 is administratively disabled
    https://git.kernel.org/netdev/net/c/76dd07281338

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


