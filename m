Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74D367B300
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 14:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbjAYNKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 08:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbjAYNKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 08:10:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305E148A39
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 05:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9E1AB819C2
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61110C433D2;
        Wed, 25 Jan 2023 13:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674652218;
        bh=4HtDQ+DPw6m9aHa63F516IY/XD6l1jZeMXJn97QTR5E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CGeD9xKf3S6rumQ9oh1EUs3r7Uo7b/z36eoIkh6dtwq17b80lLLc5K8mqzK/kpC9u
         2EQJYT1n3CmVozpRFmnxFVUJsTTTJ/AQj9RoNhiEFKcKrzsZ7jTrsyDvX7nTL7Lyjx
         dSGx42kEJeSQkVk6qkMqgC1jk0d1aNl2BAbh1wfdu+Ril80rVOhi03WCfJasiHCweL
         xi3Fpjd72+Vt2whPfegAZ8euj/VKZnllgZgAduGeDMaQKuJthosiwdXaaNIRA5sTqO
         32PYNFR1GmzfWKNvZYzK1sA/hf5x5Io45Q2ZfSMtJlSFhknb9J/rKcJOObhG2lKq1V
         BIrwbJR5aDsJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47199F83ED3;
        Wed, 25 Jan 2023 13:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] net: mctp: struct sock lifetime fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167465221828.7884.5467954248621980921.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 13:10:18 +0000
References: <20230124020106.743966-1-jk@codeconstruct.com.au>
In-Reply-To: <20230124020106.743966-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, matt@codeconstruct.com.au,
        pabeni@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, noamr@ssd-disclosure.com
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
by David S. Miller <davem@davemloft.net>:

On Tue, 24 Jan 2023 10:01:02 +0800 you wrote:
> This series is a set of fixes for the sock lifetime handling in the
> AF_MCTP code, fixing a uaf reported by Noam Rathaus
> <noamr@ssd-disclosure.com>.
> 
> The Fixes: tags indicate the original patches affected, but some
> tweaking to backport to those commits may be needed; I have a separate
> branch with backports to 5.15 if that helps with stable trees.
> 
> [...]

Here is the summary with links:
  - [net,1/4] net: mctp: add an explicit reference from a mctp_sk_key to sock
    https://git.kernel.org/netdev/net/c/de8a6b15d965
  - [net,2/4] net: mctp: move expiry timer delete to unhash
    https://git.kernel.org/netdev/net/c/5f41ae6fca9d
  - [net,3/4] net: mctp: hold key reference when looking up a general key
    https://git.kernel.org/netdev/net/c/6e54ea37e344
  - [net,4/4] net: mctp: mark socks as dead on unhash, prevent re-add
    https://git.kernel.org/netdev/net/c/b98e1a04e27f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


