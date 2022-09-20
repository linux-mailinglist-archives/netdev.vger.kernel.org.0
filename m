Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93AA35BE6E6
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 15:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiITNU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 09:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiITNUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 09:20:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9215F474C3;
        Tue, 20 Sep 2022 06:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AF21B8292E;
        Tue, 20 Sep 2022 13:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCDC2C433D7;
        Tue, 20 Sep 2022 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663680016;
        bh=W9g+HSFSLz4wyNoN2myIF2p7ILoeXP4guBNOOyXgpIU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZKiBxYcZwea6NE7I5f9GXfl0OSwQ02vtOVujeUGzwKiUAG5ew5Srg9shJNWT24uc8
         Q9pYCwPgGqRzD50/ekP5tkt4hgZQZlfCOoncrPAOHwUyTGKc+S3bU+BlDieLiMcqPA
         yHJB1EkiPSaHNx+u9j08OCRI6iIuDrL1Vz9srgYR808jdD8Sa2gayWWtogc2Wtj6cl
         1uWWTBkRrNVClju+PNyi0HHZiTmPHwXwVr9s6s+XQ9I9v9OZwGtF6qljrqOK4QMDLw
         J7LnRDIjqDa6pPOu2oiPJnfJDho7cRwryuEo24BI9AhMTnXe9ygKaE2Rn1sOs9aYH5
         9EIhRmGhE5iOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF597C43141;
        Tue, 20 Sep 2022 13:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v8 0/3] net: ethernet: adi: Add ADIN1110 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166368001677.22370.6651002479753262496.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 13:20:16 +0000
References: <20220913122629.124546-1-andrei.tachici@stud.acs.upb.ro>
In-Reply-To: <20220913122629.124546-1-andrei.tachici@stud.acs.upb.ro>
To:     None <andrei.tachici@stud.acs.upb.ro>
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 13 Sep 2022 15:26:26 +0300 you wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> The ADIN1110 is a low power single port 10BASE-T1L MAC-PHY
> designed for industrial Ethernet applications. It integrates
> an Ethernet PHY core with a MAC and all the associated analog
> circuitry, input and output clock buffering.
> 
> [...]

Here is the summary with links:
  - [net-next,v8,1/3] net: phy: adin1100: add PHY IDs of adin1110/adin2111
    https://git.kernel.org/netdev/net-next/c/875b718ac380
  - [net-next,v8,2/3] net: ethernet: adi: Add ADIN1110 support
    https://git.kernel.org/netdev/net-next/c/bc93e19d088b
  - [net-next,v8,3/3] dt-bindings: net: adin1110: Add docs
    https://git.kernel.org/netdev/net-next/c/9fd12e869e17

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


