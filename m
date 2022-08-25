Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31D25A0761
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbiHYCk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbiHYCkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:40:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009CC491E7;
        Wed, 24 Aug 2022 19:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B02E0B82731;
        Thu, 25 Aug 2022 02:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62627C433D6;
        Thu, 25 Aug 2022 02:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661395219;
        bh=brwVWbfKcz1OKdMhOJBkHODIYTzZuM3+32ngS8gNJM4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OjJLUfFG8PBkWTjNyD7B3tV/qlygNiosz0EhuNWgpiiwq8qx9vcXiwWtAz6ysJS9C
         Lvh/yceGm3Ntw/tnrEaU0aXjQ3x5Q6Zn7FNHw7VB9ewHROwrLb0H7D1rIgIF+92+N4
         NVwPW0zwoVW1aUbYCrn0w+NqN46hPtXgMQi809QsIemNU1K1mK7cqW9Q59xMGAA/la
         x4yAqE379zM6Fsua4Cbyp9bsK3KCg1Pc31/WH6JvC+R7VgUgrKO+sb+eA7wRkPPVn4
         QSZ/51VtrhY1kBIcVG3WaGVGV/Qcx/qGYEpMxp5Wj7OzVrYCNGT4Cx++bJZDSlknJD
         RKixprbN19vxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4CCD8C04E59;
        Thu, 25 Aug 2022 02:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next v4 0/3] Add a second bind table hashed by port
 and address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166139521930.434.1076457897005126686.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 02:40:19 +0000
References: <20220822181023.3979645-1-joannelkoong@gmail.com>
In-Reply-To: <20220822181023.3979645-1-joannelkoong@gmail.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, kafai@fb.com,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        dccp@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 Aug 2022 11:10:20 -0700 you wrote:
> Currently, there is one bind hashtable (bhash) that hashes by port only.
> This patchset adds a second bind table (bhash2) that hashes by port and
> address.
> 
> The motivation for adding bhash2 is to expedite bind requests in situations
> where the port has many sockets in its bhash table entry (eg a large number
> of sockets bound to different addresses on the same port), which makes checking
> bind conflicts costly especially given that we acquire the table entry spinlock
> while doing so, which can cause softirq cpu lockups and can prevent new tcp
> connections.
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next,v4,1/3] net: Add a bhash2 table hashed by port and address
    https://git.kernel.org/netdev/net-next/c/28044fc1d495
  - [RESEND,net-next,v4,2/3] selftests/net: Add test for timing a bind request to a port with a populated bhash entry
    https://git.kernel.org/netdev/net-next/c/c35ecb95c448
  - [RESEND,net-next,v4,3/3] selftests/net: Add sk_bind_sendto_listen and sk_connect_zero_addr
    https://git.kernel.org/netdev/net-next/c/1be9ac87a75a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


