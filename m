Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED01C6DC0AC
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 18:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjDIQlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 12:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDIQln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 12:41:43 -0400
X-Greylist: delayed 1572 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 09 Apr 2023 09:41:42 PDT
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54AD3AA0;
        Sun,  9 Apr 2023 09:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
        s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sdepJt36gVqn4e9O8k96DKAcVGbB3Ag8s1S8ozt6leE=; b=wjx+ZV2adD5NJnDN6wA4IAXFzq
        MjT7yYfOHgjdIbZHbukuMC/U8i2J8Dt2lsBlh0xtX0+c2TM937j17BwY15wBeb4aeYBymI05yVWNj
        2MDvrL/GPbzuf0EOnJd+0vkbBxhM8zoQC6nchKr7uI+dp8+R+sDeU0DBGEeOjK9npdSo0Lxb6hU5R
        tJ+B4RNXvqd/whwA5AmcrJvr+2Uz2cxWgVuCrj+hIrGp8cqDAzwBeD5cnBD5FN1siBHmuBlLBUHBy
        pDRziWgJyHSt+lGg0/XtQv+Ir2uUMm2DsMmi2gQr3u15AI+Lr3awxWuWL3uRgR5hpOIk/iTu7cwjr
        8y5BOPBA==;
Received: from noodles by the.earth.li with local (Exim 4.94.2)
        (envelope-from <noodles@earth.li>)
        id 1plXh5-009uJS-Ht; Sun, 09 Apr 2023 17:15:07 +0100
Date:   Sun, 9 Apr 2023 17:15:07 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 13/16] ARM: dts: qcom: ipq8064-rb3011: Drop
 unevaluated properties in switch nodes
Message-ID: <ZDLki3CYBxQ+uqUJ@earth.li>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-14-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327141031.11904-14-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 04:10:28PM +0200, Christian Marangi wrote:
> IPQ8064 MikroTik RB3011UiAS-RM DT have currently unevaluted properties
> in the 2 switch nodes. The bindings #address-cells and #size-cells are
> redundant and cause warning for 'Unevaluated properties are not
> allowed'.
> 
> Drop these bindings to mute these warning as they should not be there
> from the start.

Looks legit (and no particular reason it needs to wait for the rest of
the series).

Reviewed-By: Jonathan McDowell <noodles@earth.li>
Tested-By: Jonathan McDowell <noodles@earth.li>

> Cc: Jonathan McDowell <noodles@earth.li>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  arch/arm/boot/dts/qcom-ipq8064-rb3011.dts | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
> index f908889c4f95..47a5d1849c72 100644
> --- a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
> +++ b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
> @@ -38,8 +38,6 @@ mdio0: mdio-0 {
>  
>  		switch0: switch@10 {
>  			compatible = "qca,qca8337";
> -			#address-cells = <1>;
> -			#size-cells = <0>;
>  
>  			dsa,member = <0 0>;
>  
> @@ -105,8 +103,6 @@ mdio1: mdio-1 {
>  
>  		switch1: switch@14 {
>  			compatible = "qca,qca8337";
> -			#address-cells = <1>;
> -			#size-cells = <0>;
>  
>  			dsa,member = <1 0>;
>  
> -- 
> 2.39.2
> 

J.

-- 
Are you happy with your wash?
