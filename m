Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D502E4F3507
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 15:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343927AbiDEJPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 05:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244017AbiDEIvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 04:51:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726ABD1CDF;
        Tue,  5 Apr 2022 01:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 108D5B81C6F;
        Tue,  5 Apr 2022 08:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9FF91C385A1;
        Tue,  5 Apr 2022 08:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649148012;
        bh=Zc1lPH1m7basa7ZzhirPvPyfn9KWw84TMvg3+N1Z3Iw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FUBoPWaBBUeCm7ZIaQtsGiOm3qmKp+ZwPu10zFqFnHisNR+OYrz2B+817AwmUTTQz
         Zwn7z1nDRS7lTzduKDR6Hb6mI4CxXmlBkEeir+RNjrzvtZUsTRg4c2qClAZ4Harj9x
         G+9hrX6/rxo7o7kXVDtEWSSQb9Wyn1kfihWlFJsayS+OPAhudymvoCBZBxkTv5HJrW
         yTIxe9fgcElmIW9hNkcLi048dH9GiRQ2ryIWs66h1FFP5AN3oYAZKSWCTgz/Xs6p2w
         uepNGF+ajKgSiM5zhxwKWAdg5/TdZibiUuDZGBtpQrEajpzd7e+9Kr8yi932mYZx8N
         tmGYwk0WOfdqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B208E85D15;
        Tue,  5 Apr 2022 08:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net] sctp: count singleton chunks in assoc user stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164914801250.9044.11217465324374083651.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Apr 2022 08:40:12 +0000
References: <c9ba8785789880cf07923b8a5051e174442ea9ee.1649029663.git.jamie.bainbridge@gmail.com>
In-Reply-To: <c9ba8785789880cf07923b8a5051e174442ea9ee.1649029663.git.jamie.bainbridge@gmail.com>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  4 Apr 2022 09:47:48 +1000 you wrote:
> Singleton chunks (INIT, HEARTBEAT PMTU probes, and SHUTDOWN-
> COMPLETE) are not counted in SCTP_GET_ASOC_STATS "sas_octrlchunks"
> counter available to the assoc owner.
> 
> These are all control chunks so they should be counted as such.
> 
> Add counting of singleton chunks so they are properly accounted for.
> 
> [...]

Here is the summary with links:
  - [v4,net] sctp: count singleton chunks in assoc user stats
    https://git.kernel.org/netdev/net/c/e3d37210df5c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


