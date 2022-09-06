Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB365AE702
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 13:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiIFL4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 07:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiIFL4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 07:56:32 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9CB6F260;
        Tue,  6 Sep 2022 04:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=db2zFCi0TeQzDV6buhxTlSnCtcmC9EJ7noOsn8H2ACY=; b=Pzalvoe77Xa573KE1sFZdEuKcW
        cYoiLm9pv0/XqCBC/fXytMwSwpy7NXE9BvmPZngQpgcc8ghxw255u+3CNV/oKey4ooOYx9f/RcrXM
        myEdLioa3ZOfkE3voCytFRnVGUQLszycTluZY99FwSYoT+44TwTMURxHFo9Hmtz7PvCM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVXB1-00FkGI-Vf; Tue, 06 Sep 2022 13:55:35 +0200
Date:   Tue, 6 Sep 2022 13:55:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tao Ren <rentao.bupt@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heyi Guo <guoheyi@linux.alibaba.com>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Liang He <windhl@126.com>, Hao Chen <chenhao288@hisilicon.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, Tao Ren <taoren@fb.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 2/2] ARM: dts: aspeed: elbert: Enable mac3
 controller
Message-ID: <Yxc1N1auY5jk3yJI@lunn.ch>
References: <20220905235634.20957-1-rentao.bupt@gmail.com>
 <20220905235634.20957-3-rentao.bupt@gmail.com>
 <YxaS2mS5vwW4HuqL@lunn.ch>
 <YxalTToannPyLQpI@taoren-fedora-PC23YAB4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxalTToannPyLQpI@taoren-fedora-PC23YAB4>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 05, 2022 at 06:41:33PM -0700, Tao Ren wrote:
> Hi Andrew,
> 
> On Tue, Sep 06, 2022 at 02:22:50AM +0200, Andrew Lunn wrote:
> > On Mon, Sep 05, 2022 at 04:56:34PM -0700, rentao.bupt@gmail.com wrote:
> > > From: Tao Ren <rentao.bupt@gmail.com>
> > > 
> > > Enable mac3 controller in Elbert dts: Elbert MAC3 is connected to the
> > > onboard switch directly (fixed link).
> > 
> > What is the switch? Could you also add a DT node for it?
> > 
> > > 
> > > Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
> > > ---
> > >  arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts | 11 +++++++++++
> > >  1 file changed, 11 insertions(+)
> > > 
> > > diff --git a/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts b/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
> > > index 27b43fe099f1..52cb617783ac 100644
> > > --- a/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
> > > +++ b/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
> > > @@ -183,3 +183,14 @@ imux31: i2c@7 {
> > >  &i2c11 {
> > >  	status = "okay";
> > >  };
> > > +
> > > +&mac3 {
> > > +	status = "okay";
> > > +	phy-mode = "rgmii";
> > 
> > 'rgmii' is suspicious, though not necessarily wrong. This value is
> > normally passed to the PHY, so the PHY inserts the RGMII delay. You
> > however don't have a PHY. So i assume the switch is inserting the
> > delay? Again, being able to see the DT properties for the switch would
> > be useful.
> > 
> >    Andrew
> 
> Thank you for the quick review!
> 
> The BMC mac3 is connected to BCM53134P's IMP_RGMII port, and there is no
> PHY between BMC MAC and BCM53134P. BCM53134P loads configurations from
> its EEPROM when the chip is powered.

So i assume you have the switch RGMII port doing the delays. That is
fine.

> Could you please point me an example showing how to describe the switch in
> dts? Anyhow I will need to improve the patch description and comments in
> v2.

It looks like drivers/net/dsa/b53 does not support this particular
switch. You could consider extending the driver. See

Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml

for documentation of the binding.

    Andrew
