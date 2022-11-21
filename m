Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D676320E4
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiKULlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiKULkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:40:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF4DE0B3;
        Mon, 21 Nov 2022 03:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BA98B80ED2;
        Mon, 21 Nov 2022 11:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2886CC4347C;
        Mon, 21 Nov 2022 11:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669030817;
        bh=YghOUJYQ52Xd0RISjGIJDByNTDYaKlkQluQrntT5wjU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eMffXQFSCOGQezJS4xRMYbazl+1yFlAik/RWH7pT2Y4/wMYnrbHtfFGr4c4P2l3B0
         /Ou49ZIZiCHeRE2WBY282GE3LWFkiMXP+xSX7oyeZ9BVBMrtBIxA/E/LstU1T0nX+1
         lLvc6xDEs02slJ2WfnTOSpgdg0kEpOs5pifYQnPXRbKR8ix/SaWBff7B5BDNk8t4cS
         62jF7Kh1NcyUhqAkciomIQrZf5RF26Nx0Z64e7kbqzhPFxNMlTi/oEYzCtJ93iNjy3
         Yw58LlDjar+loe2NfybQLQEnyR32jRYMGiVgpvBsWcRTYrdChZzipII2GVv7+/JN16
         s4XWeDBzZ99hQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11436C395FF;
        Mon, 21 Nov 2022 11:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/8] Add support for VCAP debugFS in Sparx5
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166903081706.14617.12205489004712356542.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Nov 2022 11:40:17 +0000
References: <20221117213114.699375-1-steen.hegelund@microchip.com>
In-Reply-To: <20221117213114.699375-1-steen.hegelund@microchip.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        rdunlap@infradead.org, casper.casan@gmail.com,
        rmk+kernel@armlinux.org.uk, wanjiabing@vivo.com, nhuck@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, horatiu.vultur@microchip.com,
        lars.povlsen@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Nov 2022 22:31:06 +0100 you wrote:
> This provides support for getting VCAP instance, VCAP rule and VCAP port
> keyset configuration information via the debug file system.
> 
> It builds on top of the initial IS2 VCAP support found in these series:
> 
> https://lore.kernel.org/all/20221020130904.1215072-1-steen.hegelund@microchip.com/
> https://lore.kernel.org/all/20221109114116.3612477-1-steen.hegelund@microchip.com/
> https://lore.kernel.org/all/20221111130519.1459549-1-steen.hegelund@microchip.com/
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/8] net: microchip: sparx5: Ensure L3 protocol has a default value
    https://git.kernel.org/netdev/net-next/c/bcddc196d481
  - [net-next,v2,2/8] net: microchip: sparx5: Ensure VCAP last_used_addr is set back to default
    https://git.kernel.org/netdev/net-next/c/277e9179efe5
  - [net-next,v2,3/8] net: microchip: sparx5: Add VCAP debugFS support
    https://git.kernel.org/netdev/net-next/c/e0305cc1d125
  - [net-next,v2,4/8] net: microchip: sparx5: Add raw VCAP debugFS support for the VCAP API
    https://git.kernel.org/netdev/net-next/c/d4134d41e3cb
  - [net-next,v2,5/8] net: microchip: sparx5: Add VCAP rule debugFS support for the VCAP API
    https://git.kernel.org/netdev/net-next/c/3a7921560d2f
  - [net-next,v2,6/8] net: microchip: sparx5: Add VCAP debugFS key/action support for the VCAP API
    https://git.kernel.org/netdev/net-next/c/72d84dd609be
  - [net-next,v2,7/8] net: microchip: sparx5: Add VCAP locking to protect rules
    https://git.kernel.org/netdev/net-next/c/71c9de995260
  - [net-next,v2,8/8] net: microchip: sparx5: Add VCAP debugfs KUNIT test
    https://git.kernel.org/netdev/net-next/c/552b7d131aa0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


