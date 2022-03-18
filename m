Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4594DD591
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 08:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiCRHxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 03:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbiCRHxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 03:53:16 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7911B2C80AF;
        Fri, 18 Mar 2022 00:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647589914; x=1679125914;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X6SwbwpiUB+B3bXRicDk7uV202lxEtcW7TukX+QpKN8=;
  b=DqVM/hjZYvKAY5Iu+BILlRatyRjbaUmqOUdDuNfd3gI0QY+yc4+sYUbk
   +6gUKboC2vrWOvEXp9ERrfP0TWHttJGaz93D7QTSkTvOxPg6F4RBFDRbc
   KGcG4MGG6W0GkWgUFI7YG/kGzb5oUtFaymD1ZGjVjV7U6ZmW/hMF5rqJZ
   YyQZNx7+CaBLJSAmOOGBRWY1LptMFXPcBUGWmzkVlL6cJh81asEkVSoF4
   /J0yisW2tFu83F63HL+cd6fmd0MpK7eQWrBTBJdJlCI1L+7G6l0+meloV
   FrtNDSXC/6cHL6tK+qcMtw9V9MIc4m3jTO/g21UUFgcX1fAG/glsh8Q/h
   w==;
X-IronPort-AV: E=Sophos;i="5.90,191,1643698800"; 
   d="scan'208";a="157361859"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Mar 2022 00:51:53 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 18 Mar 2022 00:51:53 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 18 Mar 2022 00:51:52 -0700
Date:   Fri, 18 Mar 2022 08:54:50 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <devicetree@vger.kernel.org>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>
Subject: Re: [PATCH net-next 1/5] dt-bindings: net: lan966x: Extend with FDMA
 interrupt
Message-ID: <20220318075450.rvofpoc3m22g7jpj@soft-dev3-1.localhost>
References: <20220317185159.1661469-2-horatiu.vultur@microchip.com>
 <20220318021413.25810-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220318021413.25810-1-michael@walle.cc>
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/18/2022 03:14, Michael Walle wrote:
> 
> > Extend dt-bindings for lan966x with FDMA interrupt. This is generated
> > when receiving a frame or when a frame was transmitted. The interrupt
> > needs to be enable for each frame.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../devicetree/bindings/net/microchip,lan966x-switch.yaml       | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> > index 13812768b923..14e0bae5965f 100644
> > --- a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> > +++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> > @@ -39,6 +39,7 @@ properties:
> >        - description: frame dma based extraction
> >        - description: analyzer interrupt
> >        - description: ptp interrupt
> > +      - description: fdma interrupt
> >
> >    interrupt-names:
> >      minItems: 1
> > @@ -47,6 +48,7 @@ properties:
> >        - const: fdma
> >        - const: ana
> >        - const: ptp
> > +      - const: fdma
> 
> This interrupt is already described (three lines above), no?

Yes you are right.
So I will drop this patch in the next version.

> 
> -michael

-- 
/Horatiu
