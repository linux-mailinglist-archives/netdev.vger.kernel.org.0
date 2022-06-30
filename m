Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D861C5624FE
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbiF3VRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237306AbiF3VRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:17:12 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A6532ED9;
        Thu, 30 Jun 2022 14:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656623830; x=1688159830;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1fI+D6GLr2yAZoMGO3nm1zW5iOCDj2YaxSYiplf5QcY=;
  b=HhSIQBYv3TeWbAmW6gPR3/4zq3w9rlrF3G1Nu7j0OvmISG9cQ3V37m7F
   UrSjAV9qxPbxhcjY5gkDXaxyPtp5l68dxLq3A3red0sIZH3xiNtkA2EhS
   1mHvDLxxrXMfkjl6FrPZ4407eIijvYSl5IANmZmQ/EtIGa4nR9C5yRa40
   NSj/UwFHMxu9cdSBjx3aQjmXaoAQC2oTKN0IrhlUDCNAj6OzdTHkQ2i8+
   vuheXuFPramZ2AfHkFMwjbWupowQYeZz8vpB94+sC+0s9YyfOqP7NN99+
   6th/eWHy2JJy0MsCyEQ2wnzakuIwMDoBWgvVPxbe4KWu72efYFEtMkS+K
   w==;
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="170593536"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 14:17:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 14:17:09 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 30 Jun 2022 14:17:09 -0700
Date:   Thu, 30 Jun 2022 23:21:03 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] net: lan966x: hardcode port count
Message-ID: <20220630212103.cgp7tt3puzxejnjx@soft-dev3-1.localhost>
References: <20220630140237.692986-1-michael@walle.cc>
 <20220630204433.hg2a2ws2zk5p73ld@soft-dev3-1.localhost>
 <0169b5865944d6522a752b02321a7f4b@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <0169b5865944d6522a752b02321a7f4b@walle.cc>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 06/30/2022 22:56, Michael Walle wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Am 2022-06-30 22:44, schrieb Horatiu Vultur:
> > The 06/30/2022 16:02, Michael Walle wrote:
> > > EXTERNAL EMAIL: Do not click links or open attachments unless you know
> > > the content is safe
> > > 
> > > Don't rely on the device tree to count the number of physical port.
> > > Instead
> > > introduce a new compatible string which the driver can use to select
> > > the
> > > correct port count.
> > > 
> > > This also hardcodes the generic compatible string to 8. The rationale
> > > is
> > > that this compatible string was just used for the LAN9668 for now and
> > > I'm
> > > not even sure the current driver would support the LAN9662.
> > 
> > It works also on LAN9662, but I didn't have time to send patches for
> > DTs. Then when I send patches for LAN9662, do I need to go in all dts
> > files to change the compatible string for the 'switch' node?
> 
> I'd assume there is one lan9662.dtsi and yes, there should then be
>   compatible = "microchip,lan9662-switch";
> or
>   compatible = "microchip,lan9662-switch", "microchip,lan966x-switch";
> depending on the outcome of the question Krzysztof raised.
> 
> And of course adding the compatible string to the driver with a port
> count of 4 (?). I can't find anything about the lan9662,

I am not sure why they have not upload yet the datasheet for lan9662.

>and you've > mentioned it has 4 ports.  Are there four external ports? 

You can have up to 4 ports.
You can have 4 external ports or you can use the internal ones plus two
external.

> I was  under the impression the last digit of the SoC name stands for the
> number of ports.

That would make much more sense but I don't understand why they have
name it like this.

> 
> -michael

-- 
/Horatiu
