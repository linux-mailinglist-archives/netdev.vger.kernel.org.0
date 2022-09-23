Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231DB5E76B4
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 11:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiIWJUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 05:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIWJUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 05:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7030ECDCD0;
        Fri, 23 Sep 2022 02:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A7CA6148B;
        Fri, 23 Sep 2022 09:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59A74C433B5;
        Fri, 23 Sep 2022 09:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663924816;
        bh=TvQUkU9wLBDJe9UEXwaoYiDBAF49/D8jb+Tu/1pZPSg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IOYhfcsiBYPoSULBGzttWGuqDNqw32h/TvddzwcYhrtQHEnetZ0Snqg8dKnTe45sk
         x26OuThyh9GcuIIJqDVcKZSylDXFRba3/qzVnFQ3+1AJmRQwXfHvp+OeNZGsKaNC+s
         boxCSCeomjcHQufoIl8w+9wqTRIHRID9mtjxN+LtKuCtU8l38G36UKlR5ovefuUd+9
         gzPH2rJUnrJ0QlqYNLzsmIarLqZcRcGDBOmAgCcja6CWILWR92olfUy/PA9sO+MTf7
         ROEjDPtBhs1tlCKTEcZ2og75twhJsU190yRo8uAsMajNgyKjoFNbggXjzewesL06Lz
         2Dug9ADyKTUVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3CEC2E50D69;
        Fri, 23 Sep 2022 09:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] Add QoS offload support for sparx5
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166392481624.15254.1338546530470864801.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 09:20:16 +0000
References: <20220920101432.139323-1-daniel.machon@microchip.com>
In-Reply-To: <20220920101432.139323-1-daniel.machon@microchip.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, casper.casan@gmail.com,
        horatiu.vultur@microchip.com, rmk+kernel@armlinux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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

On Tue, 20 Sep 2022 12:14:27 +0200 you wrote:
> This patch series adds support for offloading QoS features with the tc
> command suite, to the sparx5 switch. The new offloadable QoS features
> introduced in this patch series are:
> 
>   - tc-mqprio for mapping traffic class to hardware queue. Queues are by
>     default mapped 1:1  in hardware, as such the mqprio qdisc is used as
>     an attachment point for qdiscs tbf and ets.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] net: microchip: sparx5: add tc setup hook
    https://git.kernel.org/netdev/net-next/c/65ec1bbe0297
  - [net-next,v2,2/5] net: microchip: sparx5: add support for offloading mqprio qdisc
    https://git.kernel.org/netdev/net-next/c/ab0e493e75bd
  - [net-next,v2,3/5] net: microchip: sparx5: add support for offloading tbf qdisc
    https://git.kernel.org/netdev/net-next/c/e02a5ac6bf77
  - [net-next,v2,4/5] net: microchip: sparx5: add support for offloading ets qdisc
    https://git.kernel.org/netdev/net-next/c/211225428d65
  - [net-next,v2,5/5] maintainers: update MAINTAINERS file.
    https://git.kernel.org/netdev/net-next/c/d91a6d049010

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


