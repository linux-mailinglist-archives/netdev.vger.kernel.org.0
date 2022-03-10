Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AE04D507F
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 18:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245007AbiCJR2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 12:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244401AbiCJR2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 12:28:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0BDB3E5F;
        Thu, 10 Mar 2022 09:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646933264; x=1678469264;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UIbApzBbc+Vluf22x9IDYn+1LabeJBGdywRMKw75SoA=;
  b=wKkZr47gF7MuidYPkJFVO1SfeFHxtEn0Dv1HgddNNb8U8T+4wb6ml9mV
   UgUarHpeHu2SZP81YVNA/PdxbdYqU64jnKAzBqnifp2zgnlH/nX5NAxuk
   908hMm2/VtMULusG3cLSNxqX8Y7Nxy5oaNwiZc2DSCJADNctsrW4HB9Mr
   GEueAyNu4sR/Ii5GD+dcdkx0qNrPwg9304Nj4WQ0iJHIY4Qz3FcNG2lTX
   sZafgnV9v6WK0n97hH9Op1h54gPfkXBNjJ0DN74eXwpcOmy4zYagLn8ua
   Pfy2jo3kODjT62t0Gb6G9xDTrlBQC7QGpqrWZ0AF8Lr0E7bgbcXY8/t6+
   g==;
X-IronPort-AV: E=Sophos;i="5.90,171,1643698800"; 
   d="scan'208";a="165312186"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2022 10:27:43 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 10 Mar 2022 10:27:42 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 10 Mar 2022 10:27:36 -0700
Message-ID: <5e6a9cc0d6c1c6928cafd83fe34c8a545198c3d9.camel@microchip.com>
Subject: Re: [PATCH v8 net-next 01/10] dt-bindings: net: dsa: dt bindings
 for microchip lan937x
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Florian Fainelli <f.fainelli@gmail.com>, <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <devicetree@vger.kernel.org>, Rob Herring <robh@kernel.org>,
        <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>
Date:   Thu, 10 Mar 2022 22:57:36 +0530
In-Reply-To: <1300f84832ef1c43ecb9edb311fb817e3aab5420.camel@microchip.com>
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
         <20220207172204.589190-2-prasanna.vengateshan@microchip.com>
         <88caec5c-c509-124e-5f6b-22b94f968aea@gmail.com>
         <ebf1b233da821e2cd3586f403a1cdc2509671cde.camel@microchip.com>
         <d8e5f6a8-a7e1-dabd-f4b4-ea8ea21d0a1d@gmail.com>
         <1300f84832ef1c43ecb9edb311fb817e3aab5420.camel@microchip.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob/Florian,

On Wed, 2022-03-02 at 17:11 +0530, Prasanna Vengateshan wrote:
> Hi Rob and Florian,
> 
> On Fri, 2022-02-11 at 19:56 -0800, Florian Fainelli wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> > content is safe
> > 
> > On 2/9/2022 3:58 AM, Prasanna Vengateshan wrote:
> > > On Mon, 2022-02-07 at 18:53 -0800, Florian Fainelli wrote:
> > > > EXTERNAL EMAIL: Do not click links or open attachments unless you know
> > > > the
> > > > content is safe
> > > > 
> > > > On 2/7/2022 9:21 AM, Prasanna Vengateshan wrote:
> > > > > Documentation in .yaml format and updates to the MAINTAINERS
> > > > > Also 'make dt_binding_check' is passed.
> > > > > 
> > > > > RGMII internal delay values for the mac is retrieved from
> > > > > rx-internal-delay-ps & tx-internal-delay-ps as per the feedback from
> > > > > v3 patch series.
> > > > > https://lore.kernel.org/netdev/20210802121550.gqgbipqdvp5x76ii@skbuf/
> > > > > 
> > > > > It supports only the delay value of 0ns and 2ns.
> > > > > 
> > > > > Signed-off-by: Prasanna Vengateshan <
> > > > > prasanna.vengateshan@microchip.com>
> > > > > Reviewed-by: Rob Herring <robh@kernel.org>
> > > > > ---
> > > > >    .../bindings/net/dsa/microchip,lan937x.yaml   | 179
> > > > > ++++++++++++++++++
> > > > >    MAINTAINERS                                   |   1 +
> > > > >    2 files changed, 180 insertions(+)
> > > > >    create mode 100644
> > > > > Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> > > > > 
> > > > > +    maxItems: 1
> > > > > +
> > > > > +  mdio:
> > > > > +    $ref: /schemas/net/mdio.yaml#
> > > > > +    unevaluatedProperties: false
> > > > 
> > > > This should be moved to dsa.yaml since this is about describing the
> > > > switch's internal MDIO bus controller. This is applicable to any switch,
> > > > really.
> > > 
> > > Thanks for your review and feedback. Do you mean that 'mdio' to be added
> > > in
> > > dsa.yaml instead adding here?
> > 
> > Yes indeed, since this is a common property of all DSA switches, it can
> > be defined or not depending on whether the switch does have an internal
> > MDIO bus controller or not.
> > 
> > > 
> > > > 
> > > > > +
> > > > > +patternProperties:
> > > > > +  "^(ethernet-)?ports$":
> > > > > +    patternProperties:
> > > > > +      "^(ethernet-)?port@[0-7]+$":
> > > > > +        allOf:
> > > > > +          - if:
> > > > > +              properties:
> > > > > +                phy-mode:
> > > > > +                  contains:
> > > > > +                    enum:
> > > > > +                      - rgmii
> > > > > +                      - rgmii-rxid
> > > > > +                      - rgmii-txid
> > > > > +                      - rgmii-id
> > > > > +            then:
> > > > > +              properties:
> > > > > +                rx-internal-delay-ps:
> > > > > +                  $ref: "#/$defs/internal-delay-ps"
> > > > > +                tx-internal-delay-ps:
> > > > > +                  $ref: "#/$defs/internal-delay-ps"
> > > > 
> > > > Likewise, this should actually be changed in ethernet-controller.yaml
> > > 
> > > There is *-internal-delay-ps property defined for mac in ethernet-
> > > controller.yaml. Should that be changed like above?
> > 
> > It seems to me that these properties override whatever 'phy-mode'
> > property is defined, but in premise you are right that this is largely
> > applicable to RGMII only. I seem to recall that the QCA8K driver had
> > some sort of similar delay being applied even in SGMII mode but I am not
> > sure if we got to the bottom of this.
> > 
> > Please make sure that this does not create regressions for other DTS in
> > the tree before going with that change in ethernet-controller.yaml.
> > 
> 
> I just tried changing rx-internal-delay-ps & tx-internal-delay-ps on
> conditional
> basis like above in the ethernet-controller.yaml and it passed 'make
> dt_binding_check' as well. 
> 
> It would be like below if existing *-internal-delay-ps are removed from
> ethernet-controller.yaml.
> 
> allOf:
>   - if:
>       properties:
>         phy-mode:
>           contains:
>             enum:
>               - rgmii
>               - rgmii-rxid
>               - rgmii-txid
>               - rgmii-id
>             then:
>               properties:
>                 rx-internal-delay-ps:
>                   description:
>                     RGMII Receive Clock Delay defined in pico seconds.This is 
>                     used for controllers that have configurable RX internal 
>                     delays. If this property is present then the MAC applies 
>                     the RX delay.
>                 tx-internal-delay-ps:
>                   description:
>                     RGMII Transmit Clock Delay defined in pico seconds.This is
>                     used for controllers that have configurable TX internal
>                     delays. If this property is present then the MAC applies
>                     the TX delay.   
> 
> After the above changes, these two properties descriptions are different
> compare
> to other properties. So i just wanted to know whether i am following the right
> approach or are there any other proposal available? Thanks.
> 
> Prasanna V
> 
Is the above method looking good? Your feedback will be helpful. Thanks.

Prasanna V

