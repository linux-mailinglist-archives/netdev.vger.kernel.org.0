Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7603F6C9C71
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbjC0HlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbjC0Hks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:40:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D00272C;
        Mon, 27 Mar 2023 00:40:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EC5BB80E02;
        Mon, 27 Mar 2023 07:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C2C0C4339E;
        Mon, 27 Mar 2023 07:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679902837;
        bh=O81AEUAE7Ix3JSMowN+5LARyvkSgyoh0zakTCOnsRMA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mSPXgYXzP2EYiC53+Uf234rir9Z9v9M8MCyJkYqQ23XuGjE7NXSpICMHj+gCiOHpu
         6b39eyLpqcTJXw5KG2/PApHT6zqGBpsylt1lNdvnIQDEoJtaimJ0bVnrcNUpmDHK69
         p2gcosWQUcun1URNU90FxnwWe00vVjydS7o6jXaYKhNwT+t3aYtjK+6OQLf081VH0A
         BuqLw9uyKY94nXdEfhOs2o6gBtXHelGVmBu088XM1UW/QjhgS9GhbfPLCpXduYI3HL
         /INgCGCHFSjSE+4IdwCmw8wycmLbp13tmHpD2Iv//VwabG3r4lXEtop2Yro6O+ErIq
         ufYZeg5d1i3Fw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 258DDE4D029;
        Mon, 27 Mar 2023 07:40:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: b53: mmap: add phy ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167990283714.16393.16621515115052475500.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Mar 2023 07:40:37 +0000
References: <20230323194841.1431878-1-noltari@gmail.com>
In-Reply-To: <20230323194841.1431878-1-noltari@gmail.com>
To:     =?utf-8?q?=C3=81lvaro_Fern=C3=A1ndez_Rojas_=3Cnoltari=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     f.fainelli@gmail.com, jonas.gorski@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 23 Mar 2023 20:48:41 +0100 you wrote:
> Implement phy_read16() and phy_write16() ops for B53 MMAP to avoid accessing
> B53_PORT_MII_PAGE registers which hangs the device.
> This access should be done through the MDIO Mux bus controller.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  drivers/net/dsa/b53/b53_mmap.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

Here is the summary with links:
  - net: dsa: b53: mmap: add phy ops
    https://git.kernel.org/netdev/net/c/45977e58ce65

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


