Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA9A39DCE0
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 14:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhFGMsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 08:48:41 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:22616 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhFGMsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 08:48:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1623070010; x=1654606010;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FIZFB2bYQ1/lIPincdEySVOxkMfoPs9wW+HB5gfqoBA=;
  b=rA+S08OjeIDnwmVFxm+nFmocFOsc3Dj0NU37zncT7WusHC+xZSy1LlVN
   lWoL2076fkI5OGXfuok3lsD2LY+0tD3iO6YZilsdpU+RG+hiuBirRf/aH
   4blWvqt2P/6R0JSbdpl9ufbjVy1vbc69zKuNy/47RhLTp6YilOOZzdKgW
   rD0uUbUpp3MyYNqxvhRDUCtRBJIxwQx/oRKxVz1LanKZI8aZGOeha3LhZ
   sTxL2GPWcsL1ayzhVMTpcQDg96RUxCDlRNxNWfbQdK544WyXNE8vu9dYt
   lPV1eiuXfn0Rapm5GmYvS/Uxq+PL5eQMfDdDSchQNU4YVURCIm0X9GuvY
   g==;
IronPort-SDR: pSLu3m6JBVRYdtAo9Ni0/Kun1aTgxO+YivEENshwypXWwXDnQelbTY9twd7KGUZsQorHts3tlN
 Dn0liR6QhnquCyvIQggRjjXLj+RsDBIyihE2agehB1TsiqNJ25jumgPzxo9C7QD07yr4abK1sZ
 mnYKVz0RLa/D+sHz/A2fli0WEM1f/xtmhx88io2L1BRrJlJZlo1wXN4CMDFZXqzkqDqTDPHvTs
 TKmT1flZ5k/HOGFHnnpfSRtw2vfnQ5DPY/OSngkiXDb6FWM5tyJLLSxagVEhLVXAqdfLC35dyM
 qqA=
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="120430542"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jun 2021 05:46:48 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 05:46:48 -0700
Received: from den-her-m31857h.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Mon, 7 Jun 2021 05:46:44 -0700
Message-ID: <d5ffe24ce7fbe5dd4cc0b98449b0594b086e3ba9.camel@microchip.com>
Subject: Re: [PATCH net-next v3 04/10] net: sparx5: add port module support
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Mon, 7 Jun 2021 14:46:44 +0200
In-Reply-To: <20210607092136.GA22278@shell.armlinux.org.uk>
References: <20210604085600.3014532-1-steen.hegelund@microchip.com>
         <20210604085600.3014532-5-steen.hegelund@microchip.com>
         <20210607092136.GA22278@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Thanks for your comments.


On Mon, 2021-06-07 at 10:21 +0100, Russell King (Oracle) wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Fri, Jun 04, 2021 at 10:55:54AM +0200, Steen Hegelund wrote:
> > This add configuration of the Sparx5 port module instances.
> > 
> > Sparx5 has in total 65 logical ports (denoted D0 to D64) and 33
> > physical SerDes connections (S0 to S32).  The 65th port (D64) is fixed
> > allocated to SerDes0 (S0). The remaining 64 ports can in various
> > multiplexing scenarios be connected to the remaining 32 SerDes using
> > QSGMII, or USGMII or USXGMII extenders. 32 of the ports can have a 1:1
> > mapping to the 32 SerDes.
> > 
> > Some additional ports (D65 to D69) are internal to the device and do not
> > connect to port modules or SerDes macros. For example, internal ports are
> > used for frame injection and extraction to the CPU queues.
> > 
> > The 65 logical ports are split up into the following blocks.
> > 
> > - 13 x 5G ports (D0-D11, D64)
> > - 32 x 2G5 ports (D16-D47)
> > - 12 x 10G ports (D12-D15, D48-D55)
> > - 8 x 25G ports (D56-D63)
> > 
> > Each logical port supports different line speeds, and depending on the
> > speeds supported, different port modules (MAC+PCS) are needed. A port
> > supporting 5 Gbps, 10 Gbps, or 25 Gbps as maximum line speed, will have a
> > DEV5G, DEV10G, or DEV25G module to support the 5 Gbps, 10 Gbps (incl 5
> > Gbps), or 25 Gbps (including 10 Gbps and 5 Gbps) speeds. As well as, it
> > will have a shadow DEV2G5 port module to support the lower speeds
> > (10/100/1000/2500Mbps). When a port needs to operate at lower speed and the
> > shadow DEV2G5 needs to be connected to its corresponding SerDes
> > 
> > Not all interface modes are supported in this series, but will be added at
> > a later stage.
> 
> It looks to me like the phylink code in your patch series is based on
> an older version of phylink and hasn't been updated for the split PCS
> support - you seem to be munging the PCS parts in with the MAC
> callbacks. If so, please update to the modern way of dealing with this.
> 
> If that isn't the case, please explain why you are not using the split
> PCS support.

I need to be able to let the user set the speed to get the link up.

So far I have only been able to get the user configured speeds via the mac_ops, but if this is also
possible via the pcs_ops, there should not anything preventing me from using these ops instead.

Will the pcs_ops also support this?

> 
> Thanks.
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!


-- 
BR
Steen

-=-=-=-=-=-=-=-=-=-=-=-=-=-=
steen.hegelund@microchip.com


