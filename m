Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245D633CF41
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhCPIGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:06:05 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:7062 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbhCPIFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:05:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615881937; x=1647417937;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DEJKHy2guYh6gGeisp4VHb7waJsLnqxlUlnHoiJjmxY=;
  b=zksOnjRQA4Ov7VdCteLaCQ/sXVHMnQgdPeEiLqEwMQJ2JVPurnzD2y5M
   ojm+TTFunET33SENFrRXtBsH5useLKgtxHPs0ea+3ovuqFfVZa9hiclCW
   w6RidZtsBkPYa/xR1q42eASjK/2cxWB5qJW1FVjrzO3UfN9dWXw5y40Px
   SUmuAz45FeuuAPIcMiWVGzJ5rfosbbJOvCDjwWXANljaF8oBIwM6lmrZW
   wx/PiMAA4Ptx4n6s+LH9nax+b65ZQrxwhD7u5ojvfU1NJgCFh4iXbS/2m
   ub/Z5ptAZV7z6ggGJ6VdDTNm3+bD4ZAPzOM4EjKGLopHsvx589fmnVRr7
   g==;
IronPort-SDR: fFSIV7P5HNxN4dJIgKuZPvARY6VWqhleHCpl5HBQDgMXGiHnGBOTUdlN4v1ZnUpFuRgVoq8Aq/
 YN0QXI1IcX4ufpLxlJHbvTOGy31OldNQKapIPUlS3xjn9jV7cxoteL3F8dKoc1ocadoO+ecx68
 BG9Z/ln7tzypgytWw8UIbfJDO3nLAB+7hXviAMuLrxAvgwqfYBEYzZMovf3NP5xXWlQw3ITPsF
 P9P7bLzKor4yLqhqOL2JHPHihhaHzj+/qz8InPmOdmvRQRhSztG4Ac4ZaZ0rdxXde7Ts3iaOSd
 lOI=
X-IronPort-AV: E=Sophos;i="5.81,251,1610434800"; 
   d="scan'208";a="113369239"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2021 01:05:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 16 Mar 2021 01:05:37 -0700
Received: from [10.205.21.32] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 16 Mar 2021 01:05:35 -0700
Message-ID: <90896dc26c213d416bd78a0c6b6befe66f14e3a1.camel@microchip.com>
Subject: Re: [PATCH v15 0/4] Adding the Sparx5 Serdes driver
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Vinod Koul <vkoul@kernel.org>
CC:     Kishon Vijay Abraham I <kishon@ti.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date:   Tue, 16 Mar 2021 09:05:35 +0100
In-Reply-To: <YFA5wJSVolB8ZFHC@vkoul-mobl>
References: <20210218161451.3489955-1-steen.hegelund@microchip.com>
         <f856d877048319cd532602bc430c237f3576f516.camel@microchip.com>
         <YFA5wJSVolB8ZFHC@vkoul-mobl>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinod,

On Tue, 2021-03-16 at 10:23 +0530, Vinod Koul wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Hello Steen,
> 
> On 15-03-21, 16:04, Steen Hegelund wrote:
> > Hi Kishon, Vinod, Andrew, Jacub, and David,
> > 
> > I just wanted to know if you think that the Generic PHY subsystem might
> > not be the right place for this Ethernet SerDes PHY driver after all.
> > 
> > Originally I chose this subsystem for historic reasons: The
> > Microchip/Microsemi Ocelot SerDes driver was added here when it was
> > upstreamed.
> > On the other hand the Ocelot Serdes can do both PCIe and Ethernet, so
> > it might fit the signature of a generic PHY better.
> > 
> > At the moment the acceptance of the Sparx5 Serdes driver is blocking us
> > from adding the Sparx5 SwitchDev driver (to net), so it is really
> > important for us to resolve which subsystem the Serdes driver belongs
> > to.
> > 
> > I am very much looking forward to your response.
> 
> Generic PHY IMO is the right place for this series, I shall review it
> shortly and do the needful. I have asked Kishon to check the new phy API
> and ack it...
> 
> Thanks
> --
> ~Vinod

Thank you very much for the confirmation.

BR
Steen


