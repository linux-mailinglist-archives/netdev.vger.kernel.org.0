Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04364BA6F9
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 18:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238905AbiBQRU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 12:20:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiBQRUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 12:20:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F32317895B;
        Thu, 17 Feb 2022 09:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD3F361866;
        Thu, 17 Feb 2022 17:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35376C340EC;
        Thu, 17 Feb 2022 17:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645118410;
        bh=x9POLU+wDHStoBUya9mqJ1+9TJG9PgMZlKShb+suG9c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VBQ3HG70I7rUKirCOmXg81Th7TudFOI9PCl/IFUa82wBiRyr1n2B3TBwZNOP3u5Eo
         LGLVi+mispjoOgbAYcliySPNueGtYJUniOKFf6dVUaaJxdC0MwBGDPIwFWuyaUFZrg
         upjom8fEDNh2nStVidAyzANLQ3+SI1doXkPK+o40Z6mIy+wPQDO7JCrs6k1TWcFR4R
         c/jOSaRElr1OZ968Bk79GhBAvBuwmV6AKJgy91OaLpsbtIdpXv5q9ZChQthtOvT4C9
         RlJKXGf9Z4svn2fucqdXJYbrenOWWdkVCqMvBvFCwC4ECBWrjjJvJJgwsWaOrtLsXQ
         4VjadBSoC8UnQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C8BAE7BB08;
        Thu, 17 Feb 2022 17:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] vsock: remove vsock from connected table when connect is
 interrupted by a signal
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164511841010.26117.4554387084228726127.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 17:20:10 +0000
References: <20220217141312.2297547-1-sforshee@digitalocean.com>
In-Reply-To: <20220217141312.2297547-1-sforshee@digitalocean.com>
To:     Seth Forshee <sforshee@digitalocean.com>
Cc:     sgarzare@redhat.com, davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 17 Feb 2022 08:13:12 -0600 you wrote:
> vsock_connect() expects that the socket could already be in the
> TCP_ESTABLISHED state when the connecting task wakes up with a signal
> pending. If this happens the socket will be in the connected table, and
> it is not removed when the socket state is reset. In this situation it's
> common for the process to retry connect(), and if the connection is
> successful the socket will be added to the connected table a second
> time, corrupting the list.
> 
> [...]

Here is the summary with links:
  - [v2] vsock: remove vsock from connected table when connect is interrupted by a signal
    https://git.kernel.org/netdev/net/c/b9208492fcae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


