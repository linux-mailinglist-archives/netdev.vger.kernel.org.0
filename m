Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96FCC4FF5B2
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 13:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbiDMLci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 07:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbiDMLcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 07:32:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7488135A9C
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 04:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3743B82266
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 11:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 486E2C385A6;
        Wed, 13 Apr 2022 11:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649849411;
        bh=omGlJJ77yuPVoqjjXz0snVSu38YsR4QIEpGOpgs4mzk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gDVc8Zw+Wy+iDH7ssTUJp+zNYtpKaSS/4ESl1Ixp0dx5BAUoYmef61kYE2ZQbfsph
         3Z1Qie2iOheoKYJWSz9DpYv+pILdp6WTv42TDpsQWE3mxLna0OakmaOfp4QSUsjqID
         wr4BZw89Srwq987Z/QIg6SbFzRXVZOHJuw4S8EWpLwtSZ0Pmw1PwJ53vOYVr0rDrgd
         4EdtEyxS7tqFDaNTNjjBAIr6zxuJIBRkOQbHm+xQ3tXjOzL06J0e4HiHZ2/VQtItM/
         zYk5H7litXgw3wh1OHRmu35p6ffZtETW5jgIMmBsESboI4ZTd9l+IpUw2ZKur9xurh
         +v1M8i1XpRoig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2EEC1E8DD5E;
        Wed, 13 Apr 2022 11:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] macvlan: Fix leaking skb in source mode with nodst option
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164984941118.14313.3401170080498389093.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 11:30:11 +0000
References: <20220412093457.22946-1-martin@strongswan.org>
In-Reply-To: <20220412093457.22946-1-martin@strongswan.org>
To:     Martin Willi <martin@strongswan.org>
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        kernel@jbeekman.nl, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 12 Apr 2022 11:34:57 +0200 you wrote:
> The MACVLAN receive handler clones skbs to all matching source MACVLAN
> interfaces, before it passes the packet along to match on destination
> based MACVLANs.
> 
> When using the MACVLAN nodst mode, passing the packet to destination based
> MACVLANs is omitted and the handler returns with RX_HANDLER_CONSUMED.
> However, the passed skb is not freed, leaking for any packet processed
> with the nodst option.
> 
> [...]

Here is the summary with links:
  - [net] macvlan: Fix leaking skb in source mode with nodst option
    https://git.kernel.org/netdev/net/c/e16b859872b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


