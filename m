Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3D35B7823
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 19:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbiIMRh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 13:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiIMRhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 13:37:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5313A6AD1;
        Tue, 13 Sep 2022 09:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VO3bIZikhwN+qWKolijxv49yLjJJ8SBIM5ucx6vMUF8=; b=Q675HhmXFpZUqgxY6QFo74IkC5
        +MixMcWO9mUhfgShUSe6CuWaglR4AE9Ph9NQapnOzW7BCiFXfTEM2dmEYPkHxOFEII2o83dGR1LU4
        w8Dc+aQvZTgjCH8+p2zsCrQK2QJQwus5fDEIisLyZUDmOwjeB0YLlGHTqBENkQIUMAzhCNoxvf0Wi
        F7ajX2dlCumHMRgiX0Alc5MPihXvHM4SYRqNEb1pKe0RET5/9erTGquetzKdZK1VPNLjHhoVfN5e4
        /CAnU4yUtrJMRyqorLHq5T0KZ1/MkhJLpTMAGkzUvL49GJ1n1UHiVzsiKbPIaR+vebQp0+ED5WbuA
        /hZKpCbg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34294)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oY8la-0003DR-OW; Tue, 13 Sep 2022 17:28:06 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oY8lW-0000oJ-CS; Tue, 13 Sep 2022 17:28:02 +0100
Date:   Tue, 13 Sep 2022 17:28:02 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Rafa__ Mi__ecki <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        SHA-cyfmac-dev-list@infineon.com, Sven Peter <sven@svenpeter.dev>
Subject: Re: [PATCH net-next 12/12] arm64: dts: apple: Add WiFi module and
 antenna properties
Message-ID: <YyCvkrDgsFLYNZ9t@shell.armlinux.org.uk>
References: <YxhMaYOfnM+7FG+W@shell.armlinux.org.uk>
 <E1oVpne-005LCR-RJ@rmk-PC.armlinux.org.uk>
 <87zgfb8uqx.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgfb8uqx.fsf@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 11:16:22AM +0300, Kalle Valo wrote:
> Russell King (Oracle) <rmk+kernel@armlinux.org.uk> writes:
> 
> > From: Hector Martin <marcan@marcan.st>
> >
> > Add the new module-instance/antenna-sku properties required to select
> > WiFi firmwares properly to all board device trees.
> >
> > Signed-off-by: Hector Martin <marcan@marcan.st>
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> >  arch/arm64/boot/dts/apple/t8103-j274.dts  | 4 ++++
> >  arch/arm64/boot/dts/apple/t8103-j293.dts  | 4 ++++
> >  arch/arm64/boot/dts/apple/t8103-j313.dts  | 4 ++++
> >  arch/arm64/boot/dts/apple/t8103-j456.dts  | 4 ++++
> >  arch/arm64/boot/dts/apple/t8103-j457.dts  | 4 ++++
> >  arch/arm64/boot/dts/apple/t8103-jxxx.dtsi | 2 ++
> >  6 files changed, 22 insertions(+)
> 
> Is it ok to take this via wireless-next? Can I get an ack from the
> maintainers of these files?

I'm not sure who you're expecting to get an ack from. If it's the
maintainers of these files, that'll be Hector himself, and as he
authored the change, there seems to be little point in also having
an Acked-by from him too.

I just asked Hector on #asahi-dev:
17:21 < rmk> also, I think Kalle Valo is waiting on an answer on the arm64 DTS
             changes for brcmfmac:
17:21 < rmk> Is it ok to take this via wireless-next? Can I get an ack from the
17:21 < rmk> maintainers of these files?
17:21 <@marcan> ah yeah, merging via wireless-next is fine, let me give you an
                ack

If on the other hand, you're wanting Arnd, then I think he would
need to be asked directly.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
