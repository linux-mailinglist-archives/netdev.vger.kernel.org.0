Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53692DFCE3
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 15:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgLUOdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 09:33:03 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:54437 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgLUOdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 09:33:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608561182; x=1640097182;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=npsp6D6KpZSySB/81WkWRdNBxbaJJ+zM3AnwuQB/ZWo=;
  b=KPbRcpvvD385ZlfjLAL98KzNmiUJRhvf+9nPjG3GObC2Klg9mHbaE/Ji
   bEp85yrlPVYWtxCBucr8SJGIwD7ekjISbJ//oHOiFj5fC0tzNtzuLkR5O
   3OBioIFxCuyll+JKtM7r28JmzOoQvMmSkvNZYXcKwTw67mN2k6nbng9+i
   V1R0CRxDsGkk0PCCaR0PZNcc38FJypVcjOMTRfGeyElCRBgQUnKQHNCXj
   Cz7hhIytpm+pbIHIDjDbqYYpURGOruVZw3LfBzoii6q1RFC3DL5LahXGd
   DzdlTWWgI7wpyvHsXjoBehanp73J3JcDimVyJ8WE0Y69Ch5ZGOhARAGeh
   w==;
IronPort-SDR: V+DIF/vwyUcNooaG7XOAGSSXcXTCJUd5ZRPuzbMPG/UgJRVGbiKDXXVZM8S3FyLXxvxgVNd3I8
 o0ekHQ1lm23rh0xTXTqhUu6Wi7QgU+HnawQAavujJelZPklbdQ9bqOWXYlfpBkC3NFWqlbbccO
 fZdLYNvB7YgTuz1KHxw59PNlnIm3xmZALwTwSY1Gfx8WCrlRTDfE4LniJjSbMFrNFpvrXYf5nP
 k/9tHKrF1ADgqEK6+HwH8Pvc+CO409e8iVGNI9y+yZJug9ryaPIubC4jqwX323ucZ3Kt+8w94Z
 Tr0=
X-IronPort-AV: E=Sophos;i="5.78,436,1599548400"; 
   d="scan'208";a="100587126"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Dec 2020 07:31:46 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 21 Dec 2020 07:31:46 -0700
Received: from tyr.hegelund-hansen.dk (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 21 Dec 2020 07:31:42 -0700
Message-ID: <1ffe38e1f38766ca38fbc6ee32481067892e3b91.camel@microchip.com>
Subject: Re: [RFC PATCH v2 0/8] Adding the Sparx5 Switch Driver
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "Lars Povlsen" <lars.povlsen@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date:   Mon, 21 Dec 2020 15:31:42 +0100
In-Reply-To: <6645f038-7101-67e4-0843-35125f74597a@gmail.com>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
         <6645f038-7101-67e4-0843-35125f74597a@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Sun, 2020-12-20 at 16:58 -0800, Florian Fainelli wrote:
> > 
> > The Sparx5 Switch chip register model can be browsed here:
> > Link:  
> > https://microchip-ung.github.io/sparx-5_reginfo/reginfo_sparx-5.html
> 
> Out of curiosity, what tool was used to generate the register
> information page? It looks really neat and well organized.

It is an in-house tool that is used in our so-called VML-flow
(Versatile Markup Language), so it is not out in the open yet.

The same model file is used internally in many ways - but exposing it
to the public is something we have not tried before, and having this
view is so much nicer that the usual datasheet, I find...

And thanks for the kind words - I passed them on to the author.

BR
Steen
> --
> Florian




