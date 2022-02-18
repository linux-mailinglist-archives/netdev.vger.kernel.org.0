Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8F14BBDA3
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 17:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237976AbiBRQjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 11:39:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiBRQjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 11:39:24 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF9D1662F7;
        Fri, 18 Feb 2022 08:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1645202345; x=1676738345;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QxnUeu0qfzfRrvCh1uPZCHmA8hmtolG6mYblm9b+4cc=;
  b=1tCmWGKMgKcaRHB8K4IZ8P2T2e2Ooj+GpGJ3RUz2gDZ2mDcruuuJhipO
   3ASbJ0f8UPgZxf6+5Vot+8ZTL7eF0DMBo7zSp9Wp7nozBftvI2TL4mRkU
   q2mqq2s/ocPRZCrBCdXmSXcV8DPira8R7ZlP1HB6E0reqgljrvc6QWwZ9
   ATruaCm8MF40jQH1PUpwuyUu3Q3FK9uip/DdYiJ5L3Pl7sjuX/uG+JtJY
   YsxYeTudk9LDHUljUVAwlIE4S7qQV2hANr4V1AqxAGBTDN/62T0RON6VF
   KknhObNJqoNeYPcjUPxII2PuVX8yRXTUqGDZFU3EqaWlvOF8tHOX+5ND/
   w==;
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="146528317"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Feb 2022 09:39:03 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 18 Feb 2022 09:39:03 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 18 Feb 2022 09:38:57 -0700
Message-ID: <4b3a954cde4e9d1b6a94991964eb21e80278a8ab.camel@microchip.com>
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
Date:   Fri, 18 Feb 2022 22:08:55 +0530
In-Reply-To: <d8e5f6a8-a7e1-dabd-f4b4-ea8ea21d0a1d@gmail.com>
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
         <20220207172204.589190-2-prasanna.vengateshan@microchip.com>
         <88caec5c-c509-124e-5f6b-22b94f968aea@gmail.com>
         <ebf1b233da821e2cd3586f403a1cdc2509671cde.camel@microchip.com>
         <d8e5f6a8-a7e1-dabd-f4b4-ea8ea21d0a1d@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-02-11 at 19:56 -0800, Florian Fainelli wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> On 2/9/2022 3:58 AM, Prasanna Vengateshan wrote:
> > On Mon, 2022-02-07 at 18:53 -0800, Florian Fainelli wrote:
> > > 
> > > > +                rx-internal-delay-ps:
> > > > +                  $ref: "#/$defs/internal-delay-ps"
> > > > +                tx-internal-delay-ps:
> > > > +                  $ref: "#/$defs/internal-delay-ps"
> > > 
> > > Likewise, this should actually be changed in ethernet-controller.yaml
> > 
> > There is *-internal-delay-ps property defined for mac in ethernet-
> > controller.yaml. Should that be changed like above?
> 
> It seems to me that these properties override whatever 'phy-mode'
> property is defined, but in premise you are right that this is largely
> applicable to RGMII only. I seem to recall that the QCA8K driver had
> some sort of similar delay being applied even in SGMII mode but I am not
> sure if we got to the bottom of this.
> 
> Please make sure that this does not create regressions for other DTS in
> the tree before going with that change in ethernet-controller.yaml.

Okay, Can these be submitted as a seperate patch?

Prasanna V

