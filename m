Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61D66DAFAD
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbjDGPaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240611AbjDGPaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:30:18 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD55213B
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:30:17 -0700 (PDT)
Received: (Authenticated sender: gregory.clement@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7E18E100015;
        Fri,  7 Apr 2023 15:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680881416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0RMVMT5ckzzCSx3TeI17ZVRfO4YKG2ryxv7iAsQGvLA=;
        b=V+d7ZYzQp1FU6nLxUAHUBgafCMOtXTUaSVut8p94caCKwzQx24SP3Y75Q4ymTN/yYIjYlW
        Nq0nsdbUqI/qAk+ymi5ag/6+/orw65UoAfQBjkcAAETYmX5ru4nCynTDL62aL22pzOcU2Y
        RRCvYK0gxEQYe/sSFtnaONrcsk2ZMRkGiJe1NoLl3dzoalnOXqRtLQePUWB7WeAox0COPC
        zo1vRYUKwVMvB4Ez4I8sY6mHPJnTa9ECbKIlgDyPkfC4vnnPIK19Uc2J3prJcflq4wnjbd
        lyH1KNLFFnyVCM9azr8LEg2WmEE95h1qrHhR/orLlNhS7wWcJ0ZceHOry12QVQ==
From:   Gregory CLEMENT <gregory.clement@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 0/3] Add missing DSA properties for marvell switches
In-Reply-To: <20230407151722.2320481-1-andrew@lunn.ch>
References: <20230407151722.2320481-1-andrew@lunn.ch>
Date:   Fri, 07 Apr 2023 17:30:06 +0200
Message-ID: <87mt3j3e2p.fsf@BL-laptop>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn <andrew@lunn.ch> writes:

> The DSA core has become more picky about DT properties. This patchset
> add missing properties and removes some unused ones, for Marvell ARM
> boards.
>
> Once all the missing properties are added, it should be possible to
> simply phylink and the mv88e6xxx driver.
>
> Andrew Lunn (3):
>   ARM: dts: kirkwood: Add missing phy-mode and fixed links
>   ARM: dts: orion5: Add missing phy-mode and fixed links
>   ARM: dts: armada: Add missing phy-mode and fixed links

Applied on mvebu/dt

(if there are comments I am still abel to fix the commit in mvebu/dt.=

Thanks,

Gregory


>
>  arch/arm/boot/dts/armada-370-rd.dts               | 2 +-
>  arch/arm/boot/dts/armada-381-netgear-gs110emx.dts | 2 +-
>  arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dts  | 7 ++++++-
>  arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dts  | 7 ++++++-
>  arch/arm/boot/dts/armada-385-linksys.dtsi         | 2 +-
>  arch/arm/boot/dts/armada-385-turris-omnia.dts     | 2 --
>  arch/arm/boot/dts/armada-xp-linksys-mamba.dts     | 2 +-
>  arch/arm/boot/dts/kirkwood-dir665.dts             | 3 ++-
>  arch/arm/boot/dts/kirkwood-l-50.dts               | 2 +-
>  arch/arm/boot/dts/kirkwood-linksys-viper.dts      | 3 ++-
>  arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts    | 3 ++-
>  arch/arm/boot/dts/kirkwood-rd88f6281.dtsi         | 2 +-
>  arch/arm/boot/dts/orion5x-netgear-wnr854t.dts     | 7 ++++++-
>  13 files changed, 30 insertions(+), 14 deletions(-)
>
> -- 
> 2.40.0
>

-- 
Gregory Clement, Bootlin
Embedded Linux and Kernel engineering
http://bootlin.com
