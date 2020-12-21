Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C422DFAB1
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 11:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgLUKCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 05:02:12 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:28358 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgLUKCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 05:02:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608544931; x=1640080931;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P5PLkNTxKnTcuBIkt7ohAbLajhx/jYOtM+J9jpjlu3M=;
  b=NUTXCf5dAoKXNy8wvPWHdVa64EohlFazDxatz+xR24Ml7n1TxmLb0Ywo
   pOPo9BwQmXMyfxqGYFgIcA7Leu8/Xz5TcQTTR/uK8ionLPZrfpbbq0QzL
   KuBeJG3pIYt4s6UG9YVF+Xa+yPiUaKL+aOonO51Wtd5zinYn+zM3KpXMO
   B1z1mSEOweC8FpMXacaX3VNmH5zi0TljxY/3ihXXTPij2mn0PIvI1Ny0A
   Lvr3X4SYTUoTNtitzxvYevp2HZY9wZkY/3MAFW+5Z3Uwe6b4e69nW5UT2
   iqZUPO7hCb8iG6/yYWf7GsFFSL6Ww60EgzGnWrGyUtH/IvLexYEZ+lGBb
   g==;
IronPort-SDR: v551d5C5GoxU2Cx/ml72RMe8NPhG04HR4z+CBx197HZdVFSIN5pGfKCjRNWV6Ov5yMTLKQ7/E9
 oxxPH00EtCXeUJSeo/lAACkG1R76lzeIlujo7gDMgd9/FAEgcsYeHUzI5smJ24roRq08G+Fh7p
 vGo9j3rnuDi84OnOa+PPkOIsb84CTcpJKd31aiGnuAHBa78Y3MSlBWKpgzyjD62rXiybkIbhQO
 ChhUVYHvRcwww4IVvAFH7KOvprRQT7JC22Gb+fXzu4c/6wPjmLJ6EZkVono6X+D3FLzj1lULPt
 RVA=
X-IronPort-AV: E=Sophos;i="5.78,436,1599548400"; 
   d="scan'208";a="103547960"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Dec 2020 03:00:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 21 Dec 2020 03:00:54 -0700
Received: from tyr.hegelund-hansen.dk (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 21 Dec 2020 03:00:50 -0700
Message-ID: <70800b38c931716e985d6614f1c33dd05124ef98.camel@microchip.com>
Subject: Re: [RFC PATCH v2 1/8] dt-bindings: net: sparx5: Add sparx5-switch
 bindings
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        "Bjarni Jonasson" <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date:   Mon, 21 Dec 2020 11:00:49 +0100
In-Reply-To: <bd696641-49f1-6411-ef7d-68bf243c8cba@gmail.com>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
         <20201217075134.919699-2-steen.hegelund@microchip.com>
         <bd696641-49f1-6411-ef7d-68bf243c8cba@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-12-20 at 16:55 -0800, Florian Fainelli wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> On 12/16/2020 11:51 PM, Steen Hegelund wrote:
> > Document the Sparx5 switch device driver bindings
> > 
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> > Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> > ---
> 
> [snip]
> 
> > +          max-speed:
> > +            maxItems: 1
> > +            description: Bandwidth allocated to this port
> > +
> > +          phys:
> > +            description: phandle of a Ethernet Serdes PHY
> > +
> > +          phy-handle:
> > +            description: phandle of a Ethernet PHY
> > +
> > +          phy-mode:
> > +            description: Interface between the serdes and the phy
> 
> Can you specify this pertains to the Serdes and Ethernet PHY?
Hi Florian,

Yes: I will clarify that phy-mode is for the optional Ethernet cuPHY.

Thanks for your comments
Steen

> --
> Florian


