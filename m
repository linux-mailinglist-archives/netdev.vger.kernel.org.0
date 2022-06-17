Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E8A54F5A6
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381919AbiFQKkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381609AbiFQKkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD5D6AA6A
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 03:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB856B82998
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 10:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64C97C341C0;
        Fri, 17 Jun 2022 10:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655462414;
        bh=EjYX/RW9LMtydDvJ31mwRfXEh1nfL2f3cg6+sd8lquM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pnk0CZcn19I+ZBkkGkmP1OsFMGiW3f5bR0ljrFw7Mwh4xLZ/Cb59aVyNAKd4QbhhZ
         kdgj3UrJd+FrAJPpYdblLUj/Mw5lTzb0bcPAXM8KWWwqEfd39qdwkFcYrMQ/EDgIPX
         AbdLIKroDWJjf3pcBghxK95TV1oC99FNLbjaQ7Tv8f4Pput0vZop7n30e8Yvv+D0/3
         6HnNWHgOxneI52HVESqP2py9QhBYVpcD3LwGTY30i6rQs+dUC7SPBYxogk1dhDnN4B
         jSELASOCuJmRxxLah7LsMzAnsqlv4MTrCZGhoZdwGY6cvvjIMrepvfUqFir41qwoaI
         Z8Xv3CsONF/qA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4AF31E7386E;
        Fri, 17 Jun 2022 10:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] veth: Add updating of trans_start
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165546241430.18293.16871375971208743351.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 10:40:14 +0000
References: <9088.1655407590@famine>
In-Reply-To: <9088.1655407590@famine>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, jtoppins@redhat.com,
        vfalico@gmail.com, andy@greyhouse.net
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Jun 2022 12:26:30 -0700 you wrote:
> Since commit 21a75f0915dd ("bonding: Fix ARP monitor validation"),
> the bonding ARP / ND link monitors depend on the trans_start time to
> determine link availability.  NETIF_F_LLTX drivers must update trans_start
> directly, which veth does not do.  This prevents use of the ARP or ND link
> monitors with veth interfaces in a bond.
> 
> 	Resolve this by having veth_xmit update the trans_start time.
> 
> [...]

Here is the summary with links:
  - [net] veth: Add updating of trans_start
    https://git.kernel.org/netdev/net/c/e66e257a5d83

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


