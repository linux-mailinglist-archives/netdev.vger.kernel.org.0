Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2784AC6AA
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346186AbiBGRAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243360AbiBGQ6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 11:58:30 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF002C0401D3;
        Mon,  7 Feb 2022 08:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644253109; x=1675789109;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JKGGt9PGQg2Pg9ENpy3R7RSFHdPWUWibjXn8WL25F3w=;
  b=cpNR/FwE4HwvIagVajGE1n3Erj+H7fqskUi2EDt7YkTjoIiC9ts7oEcx
   dXaYQRKKM76IsclQTzMjVA4ReJMlgZcgSquuJhIueyukoBn2hmJC5PSoB
   zTkoAMNFGtnzjZp5tpw8Ed6+gwn4sYTP90wygR3YfRA0gAjGHE21YRLS6
   FVp06/gET2+Slpr2VEv53IWlVnr6gjEJ9WqOD3jAP1uajaOB7FFpf9h8I
   0nTPTUg2A4s7Axt8zPEycaLOAk7XPlGWaWlQ2JBXTmoza6szAtGXB4nta
   s6c089ycm+VpYO+KEVUomSE3CcicsRdFfTOH7I04WFHig3cqfX4uS7alM
   g==;
IronPort-SDR: KUiwktoTdCoKnd3LVHjmM/KCCfi7FMBQcchc1c2TuiUKL2dWAHCw0umMkE5QzC2o8g/dcnWEI9
 p+8YJk7+w5apD6Dg5nZyY6sNL/cwIBIhbPR4YrfV7uM6V5/JIH7z3WNLHkpOdf436EC/rfvXNz
 fGcdPciBGpUQfS/Ck8ZiqpLoG9LyMIUxPsTwwNwW+vQ68r14CcWaJ2sxutWTwhdOBOJpuJCKdn
 l1n9Vdniz7D32LZIgmUVEqsqGAf6Xcb+akS+8OxLWiiXzbwq34df2X7gcQAMsDdnJ1RU7cSE3d
 IGDt4/Q/VVfXsTmMgabCCYT8
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="161356518"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Feb 2022 09:58:28 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 7 Feb 2022 09:58:28 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 7 Feb 2022 09:58:21 -0700
Message-ID: <4603640dba2699c97fd966ec7a0dec6db53529ae.camel@microchip.com>
Subject: Re: [PATCH v7 net-next 06/10] net: dsa: microchip: add support for
 phylink management
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Woojung.Huh@microchip.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Mon, 7 Feb 2022 22:28:20 +0530
In-Reply-To: <Yf1tHUaecq2DLgcE@shell.armlinux.org.uk>
References: <20220204174500.72814-1-prasanna.vengateshan@microchip.com>
         <20220204174500.72814-7-prasanna.vengateshan@microchip.com>
         <Yf1tHUaecq2DLgcE@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-02-04 at 18:14 +0000, Russell King (Oracle) wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> able to be laid out with the two pause modes first followed by the
> speeds.
> 
> > +                     phy_interface_set_rgmii(config->supported_interfaces);
> > +
> > +                     __set_bit(PHY_INTERFACE_MODE_MII,
> > +                               config->supported_interfaces);
> > +                     __set_bit(PHY_INTERFACE_MODE_RMII,
> > +                               config->supported_interfaces);
> > +             }
> > +     }
> 
> You seem to be a non-legacy driver in this patch (good!) so please also
> add:
> 
>         config->legacy_pre_march2020 = false;
> 
> while DSA is transitioned over. Thanks.

Sure, thanks for the feedback. I will change it in the next revision.

Prasanna
> 

