Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B426DAFCC
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjDGPld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDGPlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:41:32 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CBE8A42
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:41:31 -0700 (PDT)
Received: (Authenticated sender: gregory.clement@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 553D310000F;
        Fri,  7 Apr 2023 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680882089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ctp5ewvvJd4/i0x2qAH99DqCFdX3bl4wosIeyAbx/Mo=;
        b=G7fpDzrjzbgXMH1RiKh3DjVFPLaKyTy5/xc7esC4yQfSTqlK6d6vlAfso3ns6dM0auuCfl
        HCeX3F4Jq6nUjSULTJgdbr7194qNDe17/TDmP4YhpUcX6qogzvs2ZKURnzHyNZqNh81BCU
        2zXh0goyl+MAcyIbX3kitksZ59qy5DCxyWxhyRM8km0ontBdxg090j1h+E/yE+tZ7Vbm77
        iUsPDDTF9hTPtqzX6x0eScQ3TMh8UTCmsImI9MrORgOGwL46GRswbdoL1sB07mMCGc7I2y
        3rOe7zhczB+/6WUzZIt0ERjgmfyYdqnt/Y7xW0iLw7WFPhW6/2Fqo7c8wYuYYQ==
From:   Gregory CLEMENT <gregory.clement@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] ARM64: dts: marvell: cn9310: Add missing phy-mode
In-Reply-To: <20230407151839.2320596-1-andrew@lunn.ch>
References: <20230407151839.2320596-1-andrew@lunn.ch>
Date:   Fri, 07 Apr 2023 17:41:14 +0200
Message-ID: <87bkjz3dk5.fsf@BL-laptop>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn <andrew@lunn.ch> writes:

> The DSA framework has got more picky about always having a phy-mode
> for the CPU port. The SoC Ethernet is being configured to
> 10gbase-r. Set the switch phy-mode based on this. Additionally, the
> SoC Ethernet is using in-band signalling to determine the link speed,
> so add same parameter to the switch.
>
> Additionally, the cpu label has never actually been used in the
> binding, so remove it.
>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied on mvebu/dt64

Thanks,

Gregory
> ---
>  arch/arm64/boot/dts/marvell/cn9130-crb.dtsi | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi b/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
> index 8e4ec243fb8f..32cfb3e2efc3 100644
> --- a/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
> +++ b/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
> @@ -282,8 +282,9 @@ port@9 {
>  
>  			port@a {
>  				reg = <10>;
> -				label = "cpu";
>  				ethernet = <&cp0_eth0>;
> +				phy-mode = "10gbase-r";
> +				managed = "in-band-status";
>  			};
>  
>  		};
> -- 
> 2.40.0
>

-- 
Gregory Clement, Bootlin
Embedded Linux and Kernel engineering
http://bootlin.com
