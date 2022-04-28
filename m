Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F12513CB2
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 22:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351862AbiD1Uhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 16:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349931AbiD1Uhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 16:37:41 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CE0C0E42;
        Thu, 28 Apr 2022 13:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651178063; x=1682714063;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oOgO2It16OIpjBexWuG4ZHFXXaYAEzQBOSkTITodUsI=;
  b=p9UyNFvj8KkOiUTC85eh01Otf1sB62RF2hdw2uSkI+afR3U3U4Wzgcvr
   KH+it8J0p3hwUFOEPsvBe6WoxFOqkA1D4IKffb5z/SOXxL+qAjESIz58/
   i7L8O3+JhFHbmQrifM99dv1/RH8ZXN2kfRr4Kol/1Ut3e5dj8Pn9tSzDR
   KBzMLwzn92AVNGe50gRCl+pqJ/Mr0zueTwTZz+sHWW6kT4WtT1xQjMKi4
   ADsKu1RzFKoQ4tOJ5YpPlT8Uyr5S4YBzduBs4hWDukDfLPuDtxZdlbBJ7
   KP1rGpQDL3FrBedMPdsqP0AVywZfIq5olVdu84A5efpfGTvOUIVzG5e8E
   g==;
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="171335946"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2022 13:34:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 28 Apr 2022 13:34:22 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 28 Apr 2022 13:34:22 -0700
Date:   Thu, 28 Apr 2022 22:37:46 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <UNGLinuxDriver@microchip.com>,
        "Philipp Zabel" <p.zabel@pengutronix.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] net: lan966x: remove PHY reset support
Message-ID: <20220428203746.yqzgtwmeo2nmifjk@soft-dev3-1.localhost>
References: <20220428114049.1456382-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220428114049.1456382-1-michael@walle.cc>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/28/2022 13:40, Michael Walle wrote:
> 
> Remove the unneeded PHY reset node as well as the driver support for it.
> 
> This was already discussed [1] and I expect Microchip to Ack on this
> removal. Since there is no user, no breakage is expected.

This looks good to me:
Acked-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> I'm not sure it this should go through net or net-next and if the patches
> should have a Fixes: tag or not. In upstream linux there was never any user
> of it, so there is no bug to be fixed. But OTOH if the schema fix isn't
> backported, then there might be an older schema version still containing
> the reset node. Thoughts?
> 
> The patches needed for the GPIO part are just waiting to be picked up by
> Linus [2,3]. This patch and the GPIO parts are the last pieces of the
> puzzle to get ethernet working on the LAN9668 on upstream linux.
> 
> [1] https://lore.kernel.org/netdev/20220330110210.3374165-1-michael@walle.cc/
> [2] https://lore.kernel.org/linux-gpio/CACRpkdbxmN+SWt95aGHjA2ZGnN61aWaA7c5S4PaG+WePAj=htg@mail.gmail.com/
> [3] https://lore.kernel.org/linux-gpio/20220420191926.3411830-1-michael@walle.cc/
> 
> Michael Walle (2):
>   dt-bindings: net: lan966x: remove PHY reset
>   net: lan966x: remove PHY reset support
> 
>  .../devicetree/bindings/net/microchip,lan966x-switch.yaml | 2 --
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c     | 8 +-------
>  2 files changed, 1 insertion(+), 9 deletions(-)
> 
> --
> 2.30.2
> 

-- 
/Horatiu
