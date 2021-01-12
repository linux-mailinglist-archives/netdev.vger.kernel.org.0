Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99022F3432
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391589AbhALPdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:33:17 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:24472 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391179AbhALPdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:33:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610465596; x=1642001596;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JDPIKNpUfMouZDE35ymGPDTmPuZB5DYUz5cKwyz4ctY=;
  b=E7yLHDVoPlHGE/jXnRQl7PFtbIzsk6R54Tu5WOL/J5WKhtSJkhe3uDKm
   x7rYAGgxZnwfn/nEyE+oVIo7lDXuZnPH0VdBA0iMZzluQotZs8Lt62G6n
   uSHWj7Zw7um5I/synML3z7/i0WL4nLPEnPLxH85ueZsneU+DzvNzOEOPk
   w8DXbGyO7OCwygaKUkaoaUvR5KzLMH4/mD3qqz7xzrZEcHmcJdNWkSaQ4
   0u7wgmE8eDgNCoF2MTihWj8dwP+2aRnUEr7vxzLY7BxpgVBS+yHIA+zXY
   wQebM0XFIR5Je/5rFtPAcWwq7G28b31zAzGsy1patPL+EwiuO02Z44Ih2
   Q==;
IronPort-SDR: ApxVNn76jNN4P13tTDERPXdYhwY8j2KRBhuNneIbdAm5KfQj4XztuqoJmEBmrofAmKMqeiI3pp
 hAEi/BZvTgO1WRWhJdKIlszekLqCIX1add59XAHn44goNTejgwKqyGLbu+HHT5tSNCn2HPFOWj
 ZdqEp0w25+rmlaIX+J7Totut4h0bwiXdCmy5D1z0RW8u7vjbaIahhKVycI8ZHu4b+vgzHXYoPt
 4YxobQ13Q0ZXsE7pyvMwW+8Ecg5b+V9KdbRQE9g54hcAoRXHVojj02ji+atqbRITWpFwNeKpgQ
 eFk=
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="105694336"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jan 2021 08:32:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 08:32:55 -0700
Received: from soft-dev2 (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 12 Jan 2021 08:32:53 -0700
Message-ID: <8c4296f5500be69ad0d8e2662f37d97a17aaa3e5.camel@microchip.com>
Subject: Re: [PATCH v1 1/2] net: phy: Add 100 base-x mode
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Date:   Tue, 12 Jan 2021 16:32:52 +0100
In-Reply-To: <20210111164704.GX1551@shell.armlinux.org.uk>
References: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
         <20210111130657.10703-2-bjarni.jonasson@microchip.com>
         <20210111164704.GX1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-01-11 at 16:47 +0000, Russell King - ARM Linux admin
wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> On Mon, Jan 11, 2021 at 02:06:56PM +0100, Bjarni Jonasson wrote:
> > Sparx-5 supports this mode and it is missing in the PHY core.
> > 
> > Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> 
> Oh, I forgot - please can we have the new PHY mode documented in
> Documentation/networking/phy.rst under the "PHY interface modes"
> section. Thanks.
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Will do that.
--
Bjarni Jonasson

