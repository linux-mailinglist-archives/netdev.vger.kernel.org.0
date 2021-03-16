Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B2F33CF3F
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhCPIFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:05:01 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:47982 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbhCPIEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:04:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615881884; x=1647417884;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H6MP6/joPxwKk+XblM5kNLlGk6tegDcR2Cc1Q0u81j0=;
  b=vR4MFhFMnknGOx0+lktl96mWB05ro9MBjGrJlmC3ZwRhPuY5kMTDpVRE
   z8j5KJef+Cpnkb7W/msIO5YFmhzSwTlrPjvt3fx57pHxXs8eDDC/QWB37
   fkrSVxJKKW6rDmsd3uF+40fRxEfG3KjeiKyuWd1F54baP8dL7gD/t9wm4
   fRCgq1HZbbwlNrkttlgQBzAIY8C33nfAt1ZESlkkw9zdjAJIBjws+Jywy
   kPKXG8UHEjH1DIRDsowaz/4EJIwRKrHvBdHjeJL7KixAy/hHrf6bOmwEV
   2fdMBUD8e3v6mPTz6iY83UPfnHkXzL5m2PNoN4fv62oyzRZVAiwygRAvr
   Q==;
IronPort-SDR: ZdHo0uoE/8p6dstJsDkybQCrnxnrHzdyofJp/iRE86s2FnWiVwakuoBKZ5tgo9pzvYQCfq8US3
 z0xGse/+eQcVsOwGGLalxvEG7X63tfNH7evrxT7TcA5v98kIAGQ35NbbU8gUlXJ6XIeC1agfJ3
 hM9U5a7/LP2bW6vrA6ZyWYWgk5cCxtWtaf2d3T8wV05PvHW04e+9AbxtJdL9Uk8uxabV7gm6g3
 wAoBWBao7uWtEbQw5z/lcBYkFQrbtEnW5N+SvTOpFbEHYXjFFlEmW6LOit4uiu6qfKXTRTBTSy
 QZQ=
X-IronPort-AV: E=Sophos;i="5.81,251,1610434800"; 
   d="scan'208";a="47678049"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2021 01:04:41 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 16 Mar 2021 01:04:41 -0700
Received: from [10.205.21.32] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 16 Mar 2021 01:04:39 -0700
Message-ID: <9e2db2f6a8de195ec0af1b879b75fa8bdb2bdc27.camel@microchip.com>
Subject: Re: [PATCH v15 0/4] Adding the Sparx5 Serdes driver
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date:   Tue, 16 Mar 2021 09:04:38 +0100
In-Reply-To: <20210315102640.461e473f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210218161451.3489955-1-steen.hegelund@microchip.com>
         <f856d877048319cd532602bc430c237f3576f516.camel@microchip.com>
         <20210315102640.461e473f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jacub,

On Mon, 2021-03-15 at 10:26 -0700, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, 15 Mar 2021 16:04:24 +0100 Steen Hegelund wrote:
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
> 
> Are you saying this PHY is Ethernet only?

Yes this particular PHY is Ethernet only (but the Sparx5 also has a separate PCI PHY).

> 
> > At the moment the acceptance of the Sparx5 Serdes driver is blocking us
> > from adding the Sparx5 SwitchDev driver (to net), so it is really
> > important for us to resolve which subsystem the Serdes driver belongs
> > to.
> > 
> > I am very much looking forward to your response.
> 
> FWIW even if this is merged via gen phy subsystem we can pull it into
> net-next as well to unblock your other work in this dev cycle. You just
> need to send the patches as a pull request, based on merge-base between
> the gen phy tree and net-next.


-- 
BR
Steen

-=-=-=-=-=-=-=-=-=-=-=-=-=-=
steen.hegelund@microchip.com


