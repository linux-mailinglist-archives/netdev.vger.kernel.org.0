Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0BD51816B
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 11:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbiECJo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 05:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234043AbiECJoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 05:44:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5767923B
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 02:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F9A561315
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 09:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98DA8C385C2;
        Tue,  3 May 2022 09:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651570811;
        bh=Mt7KJDwjjh36Mk/nGM1UNLSI3LgWSj/qAcvajJoB3co=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=edxAke0LYgZtfb8Cnosx6K/DNCz71HKTUMem8CM+eORau/I6Q+rGq8FvBKysc+k5O
         JrX000reeQYv2Vv0b/BWcUZ8Iu8UDkNh+avFe6xJjhrebGnxFb/bkGcbNd2aW2zShu
         w/IP7BU04FF5ui4mVrntDxs1jxgaKw6nfL3pmaMt+D61xn7jbtuoZpi7QabUS6DER3
         mWHaghxtLJkx9bu6YEmpt3ThKOo21P8E1VfRauk/GLDZDWS/UdbyWk8ftKmJr37cJp
         YBQzX0MM4PXBqhfGqVYrpAR3znpkW3TKN4kS6Js4aUKVGSsBd04YH9IKoogG6OHlT+
         WqdaEqwm6tOug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A0C2E7399D;
        Tue,  3 May 2022 09:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: mirror_gre_bridge_1q: Avoid changing PVID
 while interface is operational
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165157081149.23346.44778573563194679.git-patchwork-notify@kernel.org>
Date:   Tue, 03 May 2022 09:40:11 +0000
References: <20220502084507.364774-1-idosch@nvidia.com>
In-Reply-To: <20220502084507.364774-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        mlxsw@nvidia.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  2 May 2022 11:45:07 +0300 you wrote:
> In emulated environments, the bridge ports enslaved to br1 get a carrier
> before changing br1's PVID. This means that by the time the PVID is
> changed, br1 is already operational and configured with an IPv6
> link-local address.
> 
> When the test is run with netdevs registered by mlxsw, changing the PVID
> is vetoed, as changing the VID associated with an existing L3 interface
> is forbidden. This restriction is similar to the 8021q driver's
> restriction of changing the VID of an existing interface.
> 
> [...]

Here is the summary with links:
  - [net] selftests: mirror_gre_bridge_1q: Avoid changing PVID while interface is operational
    https://git.kernel.org/netdev/net/c/3122257c02af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


