Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDD65BE2F2
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 12:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiITKUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 06:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiITKUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 06:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B017448CBE;
        Tue, 20 Sep 2022 03:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45895B82711;
        Tue, 20 Sep 2022 10:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC633C43470;
        Tue, 20 Sep 2022 10:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663669215;
        bh=CuV4ZhXnyzj8Z3Dvy2jDCEyiGeRVrDoc9otxQBBjYL0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iUyeh5XzHnV9XYAcA6o7AiddhLEN2JJ3euKPFCA3PH07TvePLPvPOaQ/HiCiCWDq4
         TJWR1LYK3c2v3+3laSm637eABdpkyNFqRGNwJB5tX+WnKbE0xzOntnvfjCQBG7NSuk
         B/YKYWslNSeXsm75+i4mzWgmBLg70IuwbKy4EZddBoBwSNpg1ODvDR/9v39Zm91Wj1
         1xXgNbV4AlOccBwET70BWVqePaaDjJijBOUyCYGYk19VDDqxhnqy3pwxoZt+QXblzN
         CSFjlUPmQ1xM4Uo2oYJCCkxtSe3OPne8MGzK+Yj4/AMgrgTMEwvMH9/rwqYAq+tnKG
         S1Jv0a2XO4F3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C26F6E21EE0;
        Tue, 20 Sep 2022 10:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net] net: dsa: microchip: lan937x: fix maximum frame length
 check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166366921479.11231.1109250514261906383.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 10:20:14 +0000
References: <20220912051228.1306074-1-rakesh.sankaranarayanan@microchip.com>
In-Reply-To: <20220912051228.1306074-1-rakesh.sankaranarayanan@microchip.com>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, arun.ramadoss@microchip.com
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

On Mon, 12 Sep 2022 10:42:28 +0530 you wrote:
> Maximum frame length check is enabled in lan937x switch on POR, But it
> is found to be disabled on driver during port setup operation. Due to
> this, packets are not dropped when transmitted with greater than configured
> value. For testing, setup made for lan1->lan2 transmission and configured
> lan1 interface with a frame length (less than 1500 as mentioned in
> documentation) and transmitted packets with greater than configured value.
> Expected no packets at lan2 end, but packets observed at lan2.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: microchip: lan937x: fix maximum frame length check
    https://git.kernel.org/netdev/net/c/807e5eda2078

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


