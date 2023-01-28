Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D541E67F541
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 07:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbjA1GkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 01:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjA1GkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 01:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DD74955F;
        Fri, 27 Jan 2023 22:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94454B81218;
        Sat, 28 Jan 2023 06:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3179CC4339B;
        Sat, 28 Jan 2023 06:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674888019;
        bh=6K4T5PC8pKdNIra0MXhuxuw6rocF7vfI9KplzQUXcx0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I8nb+1Gi/ht9nqIiYkOvMUkrUSxrnCI6i7AuIhk5lhoDCrvy0/jVX9vXOsy3DY9Ek
         ZvlZH3/VlKE0BCbpfZ2uxiEplXp0h7LbkWyQ+sBIcBtAP7Mp/0PVnjFiMonZnHFwsR
         OyHKlxhU2hKAVCGITARlJLktkR5raDw8jbyFDhhgXEKkg34zYBiYv4/qNY8AAHuVG9
         22rxmJ7r0J1bgqkaUFvCGl5AcW6Ig1d3ourLBQ5HF9Bqfkbzhp7vr11hHEecvsA0Q2
         OLrmTiDFE96OOh6mcZ93GTodnijTvlUpaAz2+ZOOk30IpX6yKJHAahEdUvR+0+RDUi
         Bwex8w/Nr65PQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15659F83ECD;
        Sat, 28 Jan 2023 06:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mt7530: fix tristate and help description
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167488801907.1883.686729711834531157.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Jan 2023 06:40:19 +0000
References: <20230126190110.9124-1-arinc.unal@arinc9.com>
In-Reply-To: <20230126190110.9124-1-arinc.unal@arinc9.com>
To:     None <arinc9.unal@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, arinc.unal@arinc9.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, erkin.bozoglu@xeront.com
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

On Thu, 26 Jan 2023 22:01:11 +0300 you wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Fix description for tristate and help sections which include inaccurate
> information.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mt7530: fix tristate and help description
    https://git.kernel.org/netdev/net/c/ff445b839774

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


