Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F851F8A35
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 20:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgFNSpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 14:45:51 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:22452 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgFNSpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 14:45:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1592160349; x=1623696349;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sgsX8ySkFLBhREgHNtij5IKIrhlN4HxOXlYT+wYkyiQ=;
  b=UUyYQbITE1Wr3rzArK9M1cTKYAoZ+iWEZSY1bGeLfKemYf44iDPECM1S
   wIHviECgS1ad+b79zYaLUm7Cn9+CAW81BryT8ftwz96b9a+P4sU3qa06L
   jyG48ZBX4Um4n6nyhAO5eYjn7wz/uABge5mce25UXwnZ7Zt/+LorzZAWj
   I0PMkkN51+L1Q2wIk3iUVMz9YaXqo9pSxpyoobSx16+Q1ztTDmPe5AEST
   mSI43yMV8CdVCstjYqkaDZBvvhHyOXkUS8LRr024C9UDsJeeZwFfpS9kO
   /whQgw4ieJcQOutz/RzgDfCC7lYjeuwjnQ0wPCUniR1HELelbJ8p9aTvk
   g==;
IronPort-SDR: TEgTdmbmtAv7dsB6y9XEQzixIutkqK733LH0MqVdB8SSjYhTwmKz1WUnw/Yb8of4epU/vP4yl8
 316yGdg0t3by+n7SbAzjGNkefa+blAeqGhuk7u608l0cD0nGyJz0lL/3R8VCVW2LS4rKRVMCpd
 vVmUHJpyL3/g1cmfVnxcGgUa34KHeqtXVXaVOUk8vs0+oy0LqPoqRpIRBV5yjNMXIEVuDbTor3
 3FK5ItXujERWZ97pSrjNIThPuAJ9hEXYp5hgRAJEiJFwK+KQ8k0XZrdjdIIfPo0BBcC/dGtcLO
 s1M=
X-IronPort-AV: E=Sophos;i="5.73,512,1583218800"; 
   d="scan'208";a="15722889"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jun 2020 11:45:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 14 Jun 2020 11:45:48 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Sun, 14 Jun 2020 11:45:48 -0700
Date:   Sun, 14 Jun 2020 20:45:47 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] MAINTAINERS: merge entries for felix and ocelot
 drivers
Message-ID: <20200614184547.ibnuhypftcix5evq@soft-dev3.localdomain>
References: <20200613220753.948166-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200613220753.948166-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 06/14/2020 01:07, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The ocelot switchdev driver also provides a set of library functions for
> the felix DSA driver, which in practice means that most of the patches
> will be of interest to both groups of driver maintainers.
> 
> So, as also suggested in the discussion here, let's merge the 2 entries
> into a single larger one:
> https://www.spinics.net/lists/netdev/msg657412.html
> 
> Note that the entry has been renamed into "OCELOT SWITCH" since neither
> Vitesse nor Microsemi exist any longer as company names, instead they
> are now named Microchip (which again might be subject to change in the
> future), so use the device family name instead.
> 
> Suggested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  MAINTAINERS | 28 ++++++++++++----------------
>  1 file changed, 12 insertions(+), 16 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f08f290df174..621474172fdf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11339,14 +11339,6 @@ L:     dmaengine@vger.kernel.org
>  S:     Supported
>  F:     drivers/dma/at_xdmac.c
> 
> -MICROSEMI ETHERNET SWITCH DRIVER
> -M:     Alexandre Belloni <alexandre.belloni@bootlin.com>
> -M:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> -L:     netdev@vger.kernel.org
> -S:     Supported
> -F:     drivers/net/ethernet/mscc/
> -F:     include/soc/mscc/ocelot*
> -
>  MICROSEMI MIPS SOCS
>  M:     Alexandre Belloni <alexandre.belloni@bootlin.com>
>  M:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> @@ -12305,6 +12297,18 @@ M:     Peter Zijlstra <peterz@infradead.org>
>  S:     Supported
>  F:     tools/objtool/
> 
> +OCELOT ETHERNET SWITCH DRIVER
> +M:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> +M:     Vladimir Oltean <vladimir.oltean@nxp.com>
> +M:     Claudiu Manoil <claudiu.manoil@nxp.com>
> +M:     Alexandre Belloni <alexandre.belloni@bootlin.com>
> +L:     netdev@vger.kernel.org
> +S:     Supported
> +F:     include/soc/mscc/ocelot*
> +F:     drivers/net/ethernet/mscc/
> +F:     drivers/net/dsa/ocelot/*
> +F:     net/dsa/tag_ocelot.c
> +
>  OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
>  M:     Frederic Barrat <fbarrat@linux.ibm.com>
>  M:     Andrew Donnellan <ajd@linux.ibm.com>
> @@ -18188,14 +18192,6 @@ S:     Maintained
>  F:     drivers/input/serio/userio.c
>  F:     include/uapi/linux/userio.h
> 
> -VITESSE FELIX ETHERNET SWITCH DRIVER
> -M:     Vladimir Oltean <vladimir.oltean@nxp.com>
> -M:     Claudiu Manoil <claudiu.manoil@nxp.com>
> -L:     netdev@vger.kernel.org
> -S:     Maintained
> -F:     drivers/net/dsa/ocelot/*
> -F:     net/dsa/tag_ocelot.c
> -
>  VIVID VIRTUAL VIDEO DRIVER
>  M:     Hans Verkuil <hverkuil@xs4all.nl>
>  L:     linux-media@vger.kernel.org
> --
> 2.25.1
> 

Acked-by: Horatiu Vultur<horatiu.vultur@microchip.com>

-- 
/Horatiu
