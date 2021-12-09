Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CC746EBF6
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 16:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbhLIPoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 10:44:23 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:45197 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236210AbhLIPoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 10:44:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639064450; x=1670600450;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OnKl2EubxLZ/vqo++VvLLqWaysoCdxxGfeYsDMVLx0s=;
  b=G0VvHcgAxh9DWq7sEpscq8iTXDL5Ek4yey9fQBkCoCbvxm+zk9Q0vNYe
   SV/k3LdRhIl/JJ/OW0d+eK++iHaRlyzfm8gYVVbdoBotNxcgLUVkkt0lb
   bm0hhGv9cGNpZAGcEw5F9r+YNFxkw1dTa1k4PBn6sdxWoG+ZdbRFBCDnQ
   B44LqBvaRu+Oq+rtALjwOjaNdnbKGR2dPO+GtENfw0hJcgR9DtEJgYdLn
   S39JwRaE8m2DfjyuvmQRoTIs/27On8kkVJrklLxfMnIEhXu7jFvxiqzXB
   6eI27FHiFo3dYpPfCb3f77TN2w2t9pi5PEA7UcmaLvaRkLGpqJhCuy9l4
   A==;
IronPort-SDR: slJYBvfLQSwmsuQVCOHuO0WQ15JBRS3h6j3bvoAk9lT/WOdOFGc0YO3b1rqmgImlYocKeg7Cr0
 A2pex7iiqjCm/Cz0hEYnTVBoX7pCE6rszdH03I6CTWNImOObiIO96bQnLfb3PKmX3qAWn7actY
 e9vSVUVGZahhQhbonG0ldBfFHcQ0+NNpbE/Dcy2BA2Gih5yWHHff215TJIbpaCNdHYOpwSaJoI
 rPnqzW5KVee7klCpvalNNUKwzSYTwEZV5erH/i1relihL6FZh0nxQYFgCLun3MVb4K/HkYSWiC
 lu/q5R6GNHqbbfKZmb3seATL
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="141861711"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2021 08:40:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 9 Dec 2021 08:40:48 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 9 Dec 2021 08:40:48 -0700
Date:   Thu, 9 Dec 2021 16:42:47 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 2/6] dt-bindings: net: lan966x: Extend with
 the analyzer interrupt
Message-ID: <20211209154247.kzsrwli5fqautqtm@soft-dev3-1.localhost>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-3-horatiu.vultur@microchip.com>
 <20211209105857.n3mnmbnjom3f7rg3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211209105857.n3mnmbnjom3f7rg3@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/09/2021 10:58, Vladimir Oltean wrote:
> 
> On Thu, Dec 09, 2021 at 10:46:11AM +0100, Horatiu Vultur wrote:
> > Extend dt-bindings for lan966x with analyzer interrupt.
> > This interrupt can be generated for example when the HW learn/forgets
> > an entry in the MAC table.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Why don't you describe your hardware in the device tree all at once?
> Doing it piece by piece means that every time when you add a new
> functionality you need to be compatible with the absence of a certain
> reg, interrupt etc.

I though it is more clear what is added in the patch series.
But then, if for example add more interrupts in DT than what the
driver support, that would not be an issue?

> 
> >  .../devicetree/bindings/net/microchip,lan966x-switch.yaml       | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> > index 5bee665d5fcf..e79e4e166ad8 100644
> > --- a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> > +++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> > @@ -37,12 +37,14 @@ properties:
> >      items:
> >        - description: register based extraction
> >        - description: frame dma based extraction
> > +      - description: analyzer interrupt
> >
> >    interrupt-names:
> >      minItems: 1
> >      items:
> >        - const: xtr
> >        - const: fdma
> > +      - const: ana
> >
> >    resets:
> >      items:
> > --
> > 2.33.0
> >

-- 
/Horatiu
