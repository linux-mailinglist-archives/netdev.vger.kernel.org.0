Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2B14F6458
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbiDFPvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbiDFPvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:51:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCE636232C;
        Wed,  6 Apr 2022 06:10:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35B1660B86;
        Wed,  6 Apr 2022 13:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A623C385A7;
        Wed,  6 Apr 2022 13:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649250613;
        bh=2f9TXryQX88BfGLeS1wrIpQufJc4BFunKKjnkay1p1Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i2yX3528T6uYEPcFtWSjIF294BAhtOUIjPXkuGLkz7TemaVwp8K6Wd6gz5XCtrv+U
         9ejEJ784aw8zh64BOG+BRkHMWqFCzoOj5bAUQw4vU0+XWBb+FV7r/Ro3fkogacdWo9
         OL/qz2vhCk3hRvcv3TncmbaIOYlOnRDpSzCZE5pcmoQSEPybxUkGSvG2ygj1nmMN0d
         QbuqGgp4ieY+DkLDCHZ41D/aBiVoKVGOYxHTBsm/b/dg5XwJtljoZeOLjdKwGWqspJ
         rx1ehDU5mVVa6jB3eRBv4IJhyG1BQTG+kg3by3W+xCrkWyeVJ91Ph6NIRcNRr5j2R0
         3USrHI6XnBgmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6B340E85D15;
        Wed,  6 Apr 2022 13:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v8 net-next 0/4] Fix broken link on Xilinx's AXI Ethernet in
 SGMII mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164925061343.5679.9164861216578295317.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 13:10:13 +0000
References: <20220405091929.670951-1-andy.chiu@sifive.com>
In-Reply-To: <20220405091929.670951-1-andy.chiu@sifive.com>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     davem@davemloft.net, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, andrew@lunn.ch, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org, krzk+dt@kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  5 Apr 2022 17:19:25 +0800 you wrote:
> The Ethernet driver use phy-handle to reference the PCS/PMA PHY. This
> could be a problem if one wants to configure an external PHY via phylink,
> since it use the same phandle to get the PHY. To fix this, introduce a
> dedicated pcs-handle to point to the PCS/PMA PHY and deprecate the use
> of pointing it with phy-handle. A similar use case of pcs-handle can be
> seen on dpaa2 as well.
> 
> [...]

Here is the summary with links:
  - [v8,net-next,1/4] net: axienet: setup mdio unconditionally
    https://git.kernel.org/netdev/net/c/d1c4f93e3f0a
  - [v8,net-next,2/4] net: axienet: factor out phy_node in struct axienet_local
    https://git.kernel.org/netdev/net/c/ab3a5d4c6081
  - [v8,net-next,3/4] dt-bindings: net: add pcs-handle attribute
    https://git.kernel.org/netdev/net/c/dc48f04fd656
  - [v8,net-next,4/4] net: axiemac: use a phandle to reference pcs_phy
    https://git.kernel.org/netdev/net/c/19c7a43912c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


