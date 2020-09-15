Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD1326AF7F
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgIOVXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:23:40 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:42990 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbgIOVV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 17:21:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1600204887; x=1631740887;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0VFMgaGsSU+bPsmymR/qG5LuCoPD62OHSlNQdMf8wbA=;
  b=GeI4wV8uyVujq3BTnB8JCrhnHMD6Ds3eD6G6bu0jje85BBXqqligcvYu
   eKaS6iJ0MIJB+Gt7YEGj2MC4K/fASLdWcAWLw+pN1JEQ4TFbZyDFkfCJt
   yYpb+ZwawLCgKj2lNII9XFJ3DRU4teJojyBdNTSzPEf+fbJxG+FfhY3pm
   woI3gyfzd/LsqJ648UTE/xX0qUvX0qPzByVmhMUcmU5GQ0mKca3IKtC9L
   nJ+KCtQJTiSMqzN5LQ4SQLQ7spr0BMSP8msUT/ikc/K7Y6xzz29PT0t19
   muNnrBL1/R2EEOFgVJen5Ue3Ii/+ek/bjCidk860FcJl5yQLn5yR+T/mU
   w==;
IronPort-SDR: PI07gbYQL+1FCilpqPyDP6GH/y9KngYrjJsNjmHWSTCzeJ1UNpB1zAQWaeMDb1IxLFH2ehGZxF
 AzkGV8OY5Q2i5rLcXBEyq68EGCVjDkijFKzA6DFELGR8V0RKrAO1tnteVIfCfm4LWBwiwu4Ko8
 bi+NQAGFNJGPUJSbubh3jhR02AYAjpCPMpz0I8ciYQR9LARm2nJkVAfI0+wk5x5LogKuiMJA9C
 bEOZhmQHL4VWQOkKxwV1dYN71DjmKTQTT+NbodSS/QYxSJM0/b88CMHbh9JV0cZoQRH60iJIca
 Uz4=
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="95905028"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Sep 2020 14:19:25 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 14:19:24 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 15 Sep 2020 14:19:24 -0700
Date:   Tue, 15 Sep 2020 23:19:20 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <yangbo.lu@nxp.com>, <xiaoliang.yang_1@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>
Subject: Re: [PATCH net 0/7] Bugfixes in Microsemi Ocelot switch driver
Message-ID: <20200915211920.p3zyl2skzgqyuv32@soft-dev3.localdomain>
References: <20200915182229.69529-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200915182229.69529-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/15/2020 21:22, Vladimir Oltean wrote:
> 
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This is a series of 7 assorted patches for "net", on the drivers for the
> VSC7514 MIPS switch (Ocelot-1), the VSC9953 PowerPC (Seville), and a few
> more that are common to all supported devices since they are in the
> common library portion.

I have looked over ocelot changes and they look fine to me.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Vladimir Oltean (7):
>   net: mscc: ocelot: fix race condition with TX timestamping
>   net: mscc: ocelot: add locking for the port TX timestamp ID
>   net: dsa: seville: fix buffer size of the queue system
>   net: mscc: ocelot: check for errors on memory allocation of ports
>   net: mscc: ocelot: error checking when calling ocelot_init()
>   net: mscc: ocelot: refactor ports parsing code into a dedicated
>     function
>   net: mscc: ocelot: unregister net devices on unbind
> 
>  drivers/net/dsa/ocelot/felix.c             |   5 +-
>  drivers/net/dsa/ocelot/seville_vsc9953.c   |   2 +-
>  drivers/net/ethernet/mscc/ocelot.c         |  13 +-
>  drivers/net/ethernet/mscc/ocelot_net.c     |  12 +-
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 234 ++++++++++++---------
>  include/soc/mscc/ocelot.h                  |   1 +
>  net/dsa/tag_ocelot.c                       |  11 +-
>  7 files changed, 168 insertions(+), 110 deletions(-)
> 
> --
> 2.25.1
> 

-- 
/Horatiu
