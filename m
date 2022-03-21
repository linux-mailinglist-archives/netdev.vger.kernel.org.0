Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029DD4E319E
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 21:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353232AbiCUUVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 16:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348511AbiCUUVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 16:21:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4BF5046B;
        Mon, 21 Mar 2022 13:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647893982; x=1679429982;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KM4cbUqc61kjh6/ZMy8nXkMNNieQHx9QuZwQJwmTVhE=;
  b=ySN46ef+ehCp0hJSYonP5r98U5J1BANxhxcPrgCcQMz6euifMvY7XAjA
   UXFLlVbsyM1c6mcn4Bj0ejkOIbLcCHFIboFtUaoY9xSpzP6nelv+8qzb5
   xc0Ay1jQFR0Ei+WwUiq7r4HjtKAYuCmNmBSD2YmTIer4FxETHR+uLmT5+
   DJMMcw6DdFEHw6ji0eqK/jS4ZgM4yivos8sDCvIF+MwAvUNIeZFTdShA+
   oF7kO8niFRwFk3Kz1g/6+8XVmFsGiDbwTRhgPRG6HVwj8kL16d5m8JT74
   L1ScExQpXjuTjIsADJVsacw4Irmq3NAM7syeT6N4wuJ5/RbwpgNOlAfGs
   g==;
X-IronPort-AV: E=Sophos;i="5.90,199,1643698800"; 
   d="scan'208";a="152737726"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Mar 2022 13:19:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 21 Mar 2022 13:19:40 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 21 Mar 2022 13:19:31 -0700
Message-ID: <b7d6a721c1a5dd7de39483a9f70c40912bb5265b.camel@microchip.com>
Subject: Re: [PATCH v9 net-next 03/11] dt-bindings: net: dsa: dt bindings
 for microchip lan937x
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <woojung.huh@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>,
        Rob Herring <robh@kernel.org>
Date:   Tue, 22 Mar 2022 01:49:29 +0530
In-Reply-To: <YjZ6GIrGCMzBaftB@lunn.ch>
References: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
         <20220318085540.281721-4-prasanna.vengateshan@microchip.com>
         <YjZ6GIrGCMzBaftB@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-03-20 at 01:49 +0100, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> > +examples:
> 
> > +          port@6 {
> > +            reg = <6>;
> > +            label = "lan5";
> > +            phy-mode = "internal";
> > +            phy-handle = <&t1phy4>;
> > +          };
> > +          port@7 {
> > +            reg = <7>;
> > +            label = "lan3";
> > +            phy-mode = "internal";
> > +            phy-handle = <&t1phy5>;
> > +          };
> > +        };
> > +
> > +        mdio {
> 
> ..
> 
> > +          t1phy4: ethernet-phy@6{
> > +            reg = <0x6>;
> > +          };
> > +          t1phy5: ethernet-phy@7{
> > +            reg = <0x7>;
> > +          };
> 
> I know it is only an example, but the numbering is a little odd here.
> 
> Port 6, which is named lan5 using t1phy4 at address 6?
> 
> I would be more likely to use t1phy6 instead of t1phy4. And t1phy7
> instead of t1phy5.

> 
>         Andrew

Sure, will change it in the next rev as above, Labels are just named to
understand front panel naming.

Prasanna V

