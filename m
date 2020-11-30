Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6312C86CE
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgK3Obb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:31:31 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:54095 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbgK3Oba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:31:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606746690; x=1638282690;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xCCce2MsvHOXRDAX3rYlHsIDzQTw2AvoabSKgeQ4ZWo=;
  b=ITOa3aoulNA6N3LWyjBdaP0y4n91OK7NMAvCNMnhZ7+Dl5quOYipqj6E
   2axB8MTr1RZM2ZB6jtnkuhjRiFdGDUndq4mfKBC3/suofor1NK0LEXtik
   1Ulg9R5B8AluvNEdukqg4ISleVUJ33Q6NcumGhOL6+2CkIXn8lssMVFEc
   zLCaLhOpdtiCpxSJfkkNKSl1JCUeruDsvsDupNfMwzi4qvFIbawZW81Xn
   aqsezrNXTsvJjSrQL+43ICYyfqXt7o2LDaINOkx/VieBtCywwSwPHwADY
   abpDyuyCYi4dcA0DCTrfO3Sw+Ox0T90s757zdJtDtlxSY+GEHW8w0MQRk
   w==;
IronPort-SDR: Et6cmmbHAj54TAIK8UskcUEkToRY84K25xlyJEQ3SKRiYjzB+rgfnIz3pJM08FAGMYxS5xhvEO
 3U/2ow7jrZA1ATyvHDZ8AjvrNAiOYU58gZR9kYHthHdApjNoQCBYZPq9iB9KNWwb5pXlJSBdbN
 Zzi1+9KWEZFswSX+t3VkX3Os192QzIzML/gjIwuM5IMLfH2XL6KWgf6zNjeU3Mk6pT11rJnyg9
 t4bxcu5mt75oFt74HD7tkeL1xSJ4PbaHmxAHJZGyILRzJ9noo5d5AKnOxBmKP3x4+7k/RLTrBc
 RII=
X-IronPort-AV: E=Sophos;i="5.78,381,1599548400"; 
   d="scan'208";a="97986070"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2020 07:30:24 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 07:30:24 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 30 Nov 2020 07:30:23 -0700
Date:   Mon, 30 Nov 2020 15:30:23 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201130143023.csjyuhs6uke7dtu6@mchp-dev-shegelun>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201128190616.GF2191767@lunn.ch>
 <20201128222828.GQ1551@shell.armlinux.org.uk>
 <20201129105245.GG1605@shell.armlinux.org.uk>
 <20201129113018.GI1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201129113018.GI1605@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.11.2020 11:30, Russell King - ARM Linux admin wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>On Sun, Nov 29, 2020 at 10:52:45AM +0000, Russell King - ARM Linux admin wrote:
>> There are other issues too.
>
>This is also wrong:
>
>+               if (port->ndev && port->ndev->phydev)
>+                       status->link = port->ndev->phydev->link;
>
>phylink already deals with that situation.

So if I need the link state, what interface should I then use to get it?

>
>--
>RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
>FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Thanks for your comments


BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
