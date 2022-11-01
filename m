Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC9861437E
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 04:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiKADKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 23:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiKADKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 23:10:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5599413F41
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 20:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07E6BB81B83
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 03:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9614CC43146;
        Tue,  1 Nov 2022 03:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667272218;
        bh=iOmsU28YY8kjDpviSEkg4LRijCi/TDh1xd9aKX9ik2Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZUt2o4rnvCK8UE0TDRoyeW9Lx55k4CdOqqpwVRg99CCEY2FknamnRsVWi+UNEATLb
         oSHKFC91hmvb5j/ZyOvBzrlKYFAQ0QzM1Eeo+WZocx2IxD2diWP+ZFXSppfdRuEF7q
         vN9aC/oiP/PWDiJ20glnhR9OIRgAsB5FZwdOfs+P1L/gKkeWg2zASTg9zv55yDutIu
         78QlL7hDe0RmiOuBauW9j9LZp2UDfs2ATrDg4B2Bx+QC99QITAGSO1Im8joSeRtiow
         zqHzA3dZSAUvtUW8n1SWGP6IEAWq99q8XdzeSQ2y4SRKNv2Ly7rYUBQs8NU/12dcSr
         uQT0OwYyHG6NA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7506EE50D71;
        Tue,  1 Nov 2022 03:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next] net: dsa: mv88e6xxx: Add RGMII delay to 88E6320
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166727221846.414.8608164785836284797.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Nov 2022 03:10:18 +0000
References: <20221028163158.198108-1-festevam@gmail.com>
In-Reply-To: <20221028163158.198108-1-festevam@gmail.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, olteanv@gmail.com,
        andrew@lunn.ch, netdev@vger.kernel.org, steffen@innosonix.de,
        festevam@denx.de
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 28 Oct 2022 13:31:58 -0300 you wrote:
> From: Steffen Bätz <steffen@innosonix.de>
> 
> Currently, the .port_set_rgmii_delay hook is missing for the 88E6320
> family, which causes failure to retrieve an IP address via DHCP.
> 
> Add mv88e6320_port_set_rgmii_delay() that allows applying the RGMII
> delay for ports 2, 5, and 6, which are the only ports that can be used
> in RGMII mode.
> 
> [...]

Here is the summary with links:
  - [v3,net-next] net: dsa: mv88e6xxx: Add RGMII delay to 88E6320
    https://git.kernel.org/netdev/net-next/c/91e87045a5ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


