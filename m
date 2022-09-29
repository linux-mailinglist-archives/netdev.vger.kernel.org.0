Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500D15EEBA0
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbiI2CUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234677AbiI2CUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F08A1D26
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D09061F2A
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78D4AC4347C;
        Thu, 29 Sep 2022 02:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664418021;
        bh=LCXPfQfiDbm2yK1vQkFIPjTwv7T50SkRw9ycJxpglEs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lXZFcqmhGoAsdIRH7UwIdF3fBWHuLnqLHPoHmLvewqVDOf2q9j55GRoQah7fre5MQ
         OAuzhzzPgJc6OS3JkTHLTAj4efPeXZ/9JcLfTq+UncnmYfmlPRESgF1naUXjCEJXl8
         pUFXuFgHsshgnt3v/i1U5WPKaqy+z9skCjc8zAfl1zFR3FkafO7bGvJD+bov9b6T4U
         +49IwRndbPJZSRATTS05JCSL0jU1OnLtB9C6nruBe+5EJL9boulo7szBqTJYyxth+h
         4ulYy+kkg+Slba11og1FFAZO0AiHGnXTEfl8tnPtzffp11fVHYSXNSqirwqnP5AYek
         5fJJ+UophDCEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6565FE4D022;
        Thu, 29 Sep 2022 02:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] mptcp: MPTCP support for TCP_FASTOPEN_CONNECT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166441802140.18961.3793341206487817962.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 02:20:21 +0000
References: <20220926232739.76317-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220926232739.76317-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, dmytro@shytyi.net,
        benjamin.hesmans@tessares.net, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 26 Sep 2022 16:27:35 -0700 you wrote:
> RFC 8684 appendix B describes how to use TCP Fast Open with MPTCP. This
> series allows TFO use with MPTCP using the TCP_FASTOPEN_CONNECT socket
> option. The scope here is limited to the initiator of the connection -
> support for MSG_FASTOPEN and the listener side of the connection will be
> in a separate series. The preexisting TCP fastopen code does most of the
> work, so these changes mostly involve plumbing MPTCP through to those
> TCP functions.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] mptcp: add TCP_FASTOPEN_CONNECT socket option
    https://git.kernel.org/netdev/net-next/c/54635bd04701
  - [net-next,2/4] tcp: export tcp_sendmsg_fastopen
    https://git.kernel.org/netdev/net-next/c/3242abeb8da7
  - [net-next,3/4] mptcp: handle defer connect in mptcp_sendmsg
    https://git.kernel.org/netdev/net-next/c/d98a82a6afc7
  - [net-next,4/4] mptcp: poll allow write call before actual connect
    https://git.kernel.org/netdev/net-next/c/a42cf9d18278

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


