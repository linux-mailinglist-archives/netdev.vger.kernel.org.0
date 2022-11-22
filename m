Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE31633F4F
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbiKVOuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbiKVOuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C7F68C55
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02A82B81BA6
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 14:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F934C433B5;
        Tue, 22 Nov 2022 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669128616;
        bh=u4ZsDBQtinkJ4gv0CdvKeeCkme03rtx3stQP8typ7Go=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mw5Q8oy9f7mfvMxsBBvxLotlzfJCLjt9b9U+D/spB8jnYO/s3lZ8vcxeXeCtqusHk
         C/KeN9PWjtsIEPNB9AxIXwvNvWDdgZwEbKLX0mS1G67xKZ2iJ1x0zCAzxvu+H4S72A
         Dua8dg3Ia/Y70SBFe82nX1KuSZTdZpwsi4Y9LwN2pjMNXcD7BxEApp0vfHqebb5/Rt
         JWXvsbcYUPkFW2LK5VoamRNHxc/Y5ptDBEPL68NrSKQEy0WyZL1h+XFZPa4B4WS2Qx
         wpxiiH4JgvgjE8d0BXVwBdqhe4YfvV9/BRhg50YqATv62YgGBDFrzUfoazl5Q6jtho
         NhMysrlJQX2GA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A0FEE270E3;
        Tue, 22 Nov 2022 14:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tsnep: Fix rotten packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166912861649.6329.4270267510965104538.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 14:50:16 +0000
References: <20221119211825.81805-1-gerhard@engleder-embedded.com>
In-Reply-To: <20221119211825.81805-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 19 Nov 2022 22:18:25 +0100 you wrote:
> If PTP synchronisation is done every second, then sporadic the interval
> is higher than one second:
> 
> ptp4l[696.582]: master offset        -17 s2 freq   -1891 path delay 573
> ptp4l[697.582]: master offset        -22 s2 freq   -1901 path delay 573
> ptp4l[699.368]: master offset         -1 s2 freq   -1887 path delay 573
>       ^^^^^^^ Should be 698.582!
> 
> [...]

Here is the summary with links:
  - [net-next] tsnep: Fix rotten packets
    https://git.kernel.org/netdev/net/c/2dc4ac91f845

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


