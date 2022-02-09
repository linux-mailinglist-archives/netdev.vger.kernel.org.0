Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD744AF125
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbiBIMN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbiBIMNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:13:43 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F54E01A20B;
        Wed,  9 Feb 2022 03:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644407903; x=1675943903;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L+DVxKDfG93QZEDonoeWEpsQmWNBO1hMRpHRORp3+5E=;
  b=xtpShl7N4LMsdTyeEPxGJ0EJR8Xu4y5JWkEphO4lVm2zx+D/TXeMRzEk
   xQ6/WDGZvGjGQHtELEJXPfb5NLyZ+6XaDLD1p1wYkzEYbePg3OqZBguTt
   iN0bTXR9dAmFS6ZRYyvxuvADTqRcnt3/g4oQ2zFkM5pg2RErilbaVKXbM
   DDYTa4U8RNptiJqRVVKUN2uy0Lm1Qaf/JHw4U9KVh7VPYJUlL341rQX4h
   dGSYT7YVI/wsOZ/JroWCNsLHWNk4RapZetmuH2TIYfkiE00WCyvIhoJS8
   lXMKUEQ7LuMHL34CmjSoTW0xwJfJShlmzsxOkv078aBfGCJ980NAdkO0f
   Q==;
IronPort-SDR: YFl071Mzo9w43N4n90fHqb+clQMo7iQRI0BZuCdWaTJF0bJ9CARUQH0h6NYVzy3MiHj169rWpt
 c21LZqFu5ihhxONKqOnRiJ7tCWzh1N85yLi6N4L89UDd9QggKc+wbgxlYp0szxPzCtDt+WTULI
 fM10Qd/x39Ik43qks4njs/5fcKpPNohuLrHdZtaNL5SuyE8UM8LhpPkUoKBtcT3QWx5Bkpftrb
 Ef2FV2jUHiHpxBAHUz9frwVdK87xJinwRkIR8+8Af12Frk1EC0IWz06N6j3kqSdTBBgXMytUVu
 OrIhT7vr3BYNmpUGRonBebHu
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="145385622"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Feb 2022 04:58:22 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 9 Feb 2022 04:58:22 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 9 Feb 2022 04:58:14 -0700
Message-ID: <ebf1b233da821e2cd3586f403a1cdc2509671cde.camel@microchip.com>
Subject: Re: [PATCH v8 net-next 01/10] dt-bindings: net: dsa: dt bindings
 for microchip lan937x
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Florian Fainelli <f.fainelli@gmail.com>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <olteanv@gmail.com>, <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <devicetree@vger.kernel.org>, Rob Herring <robh@kernel.org>
Date:   Wed, 9 Feb 2022 17:28:12 +0530
In-Reply-To: <88caec5c-c509-124e-5f6b-22b94f968aea@gmail.com>
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
         <20220207172204.589190-2-prasanna.vengateshan@microchip.com>
         <88caec5c-c509-124e-5f6b-22b94f968aea@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-02-07 at 18:53 -0800, Florian Fainelli wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> On 2/7/2022 9:21 AM, Prasanna Vengateshan wrote:
> > Documentation in .yaml format and updates to the MAINTAINERS
> > Also 'make dt_binding_check' is passed.
> > 
> > RGMII internal delay values for the mac is retrieved from
> > rx-internal-delay-ps & tx-internal-delay-ps as per the feedback from
> > v3 patch series.
> > https://lore.kernel.org/netdev/20210802121550.gqgbipqdvp5x76ii@skbuf/
> > 
> > It supports only the delay value of 0ns and 2ns.
> > 
> > Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> > Reviewed-by: Rob Herring <robh@kernel.org>
> > ---
> >   .../bindings/net/dsa/microchip,lan937x.yaml   | 179 ++++++++++++++++++
> >   MAINTAINERS                                   |   1 +
> >   2 files changed, 180 insertions(+)
> >   create mode 100644
> > Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> > 
> > +    maxItems: 1
> > +
> > +  mdio:
> > +    $ref: /schemas/net/mdio.yaml#
> > +    unevaluatedProperties: false
> 
> This should be moved to dsa.yaml since this is about describing the
> switch's internal MDIO bus controller. This is applicable to any switch,
> really.

Thanks for your review and feedback. Do you mean that 'mdio' to be added in
dsa.yaml instead adding here?

> 
> > +
> > +patternProperties:
> > +  "^(ethernet-)?ports$":
> > +    patternProperties:
> > +      "^(ethernet-)?port@[0-7]+$":
> > +        allOf:
> > +          - if:
> > +              properties:
> > +                phy-mode:
> > +                  contains:
> > +                    enum:
> > +                      - rgmii
> > +                      - rgmii-rxid
> > +                      - rgmii-txid
> > +                      - rgmii-id
> > +            then:
> > +              properties:
> > +                rx-internal-delay-ps:
> > +                  $ref: "#/$defs/internal-delay-ps"
> > +                tx-internal-delay-ps:
> > +                  $ref: "#/$defs/internal-delay-ps"
> 
> Likewise, this should actually be changed in ethernet-controller.yaml

There is *-internal-delay-ps property defined for mac in ethernet-
controller.yaml. Should that be changed like above? 


Prasanna V

