Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09F94D99CF
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 12:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347682AbiCOLB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 07:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346366AbiCOLBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 07:01:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D093CFCA;
        Tue, 15 Mar 2022 04:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABD12B8124F;
        Tue, 15 Mar 2022 11:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5706BC340ED;
        Tue, 15 Mar 2022 11:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647342010;
        bh=kDQWyzWHjEfc1TeDn57Grt8MlkW4FWC9TeYH/FtQvx0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Oh61pApuSMjpczUhciycTDjE+7VUHt2CiueVxPpy8jfLmxVlnPCrLOvPAByUIb3Cw
         ealu7XnyacEDUJq/EpmzAsViaGs/X7rejPUiK/jghGWQxh5wcKizF0GyeswzAnZAXJ
         jMfTvDMAW1W2XBsKxftDLdyPHumWu0srA2Mks+Jyx4y04I93ac110yP0FsEyGRdjT2
         U4tty29skXhupUmSClcldqMrPU+yYeJwSVTEkdG0NpCsPYY61VTTeIsYWc9xeGxN3t
         d3CLJHlXeZdb6q7zg7nfvS8588AfYN1NWHQbloXh4tKW4STkTBZVbpdGH5i14HyUbm
         H31xNq6NEPLEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B29EE8DD5B;
        Tue, 15 Mar 2022 11:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sfp: add 2500base-X quirk for Lantech SFP
 module
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164734201023.7606.243447323111934862.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Mar 2022 11:00:10 +0000
References: <20220312205014.4154907-1-michael@walle.cc>
In-Reply-To: <20220312205014.4154907-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 12 Mar 2022 21:50:14 +0100 you wrote:
> The Lantech 8330-262D-E module is 2500base-X capable, but it reports the
> nominal bitrate as 2500MBd instead of 3125MBd. Add a quirk for the
> module.
> 
> The following in an EEPROM dump of such a SFP with the serial number
> redacted:
> 
> [...]

Here is the summary with links:
  - [net-next] net: sfp: add 2500base-X quirk for Lantech SFP module
    https://git.kernel.org/netdev/net-next/c/00eec9fe4f3b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


