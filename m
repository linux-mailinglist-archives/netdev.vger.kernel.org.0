Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771592282A2
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 16:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgGUOsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 10:48:16 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:54246 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726710AbgGUOsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 10:48:16 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 34071600EE;
        Tue, 21 Jul 2020 14:48:15 +0000 (UTC)
Received: from us4-mdac16-68.ut7.mdlocal (unknown [10.7.64.187])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3662D2009B;
        Tue, 21 Jul 2020 14:48:15 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.198])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B6BB0220052;
        Tue, 21 Jul 2020 14:48:14 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 56AC980069;
        Tue, 21 Jul 2020 14:48:14 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Jul
 2020 15:48:08 +0100
Subject: Re: [PATCH v3 net-next 04/16] sfc_ef100: skeleton EF100 PF driver
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     kernel test robot <lkp@intel.com>, <kbuild-all@lists.01.org>,
        <netdev@vger.kernel.org>
References: <f1a206ef-23a0-1d3e-9668-0ec33454c2a1@solarflare.com>
 <202007170155.nhtIpp5L%lkp@intel.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <aa134db3-a860-534c-9ee2-d68cded37061@solarflare.com>
Date:   Tue, 21 Jul 2020 15:48:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <202007170155.nhtIpp5L%lkp@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25554.003
X-TM-AS-Result: No-10.141400-8.000000-10
X-TMASE-MatchedRID: fE0JoqABJp2czwUwXNyhwjVUc/h8Ki+CABYRpyLYSPrk1kyQDpEj8AQ9
        n8U23GDf40wXyO1R6vWlJHGQucwLsD6YhiGxG3G6qJSK+HSPY+/Uk/02d006ReD3XFrJfgvzQ1G
        JL9SdCx+rHCBz8Ys072kK4OJxi8mdYeOFZSwS7nSqNnzrkU+2mvb5Clv3c+Q9L++JA985eCcQCI
        enAyU+czZNRnJqTVxSOhMet756YvYWbzhof8K+8qMY62qeQBkLIB5XigUKluHLkl8e9W70ix3J/
        AIjE/Tjo5RJmiarJi0yEtxCtBVsQIzts+pQiGfa4h8r8l3l4ea7chVdIVOedv7spkgIRsSyyNJQ
        Vf2X7LwPXu8OcFtNXo11E0MChxyJDrp0Cw2l1ASZLh7IMX1BRxjXlJXYkrx9myiLZetSf8nJ4y0
        wP1A6ADVmQqp4ykTAVymkLM+r7VQ7AFczfjr/7IN9HUKzqPqOyE6HfdvONqpm+Ux/91ewjcFYL3
        /8Esg6UrctLNLvsDo=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.141400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25554.003
X-MDID: 1595342895-l9baOCzvCBLl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/07/2020 18:39, kernel test robot wrote:
> [auto build test ERROR on net-next/master]
...
> config: mips-allyesconfig (attached as .config)
...
>    mips-linux-ld: drivers/net/ethernet/sfc/ef100_nic.o: in function `efx_mcdi_sensor_event':
>>> ef100_nic.c:(.text.efx_mcdi_sensor_event+0x0): multiple definition of `efx_mcdi_sensor_event'; drivers/net/ethernet/sfc/mcdi_mon.o:mcdi_mon.c:(.text.efx_mcdi_sensor_event+0x0): first defined here

Well, this holes us below the waterline.

When the sfc team was originally developing this driver, we
 didn't anticipate this problem (in fact we tested a build with
 both drivers 'y' and it apparently worked.  It doesn't now, I
 can reproduce this problem locally by just setting CONFIG_SFC=y
 CONFIG_SFC_EF100=y in my normal .config, no specific need for
 mips-allyesconfig).  So we leaned pretty heavily on the 'use
 the linker to select NIC-specific functions in calls from
 common code' trick.
Some of these can be replaced with function pointers in struct
 efx_nic_type (like this sensor-event handler above).  But:

>    mips-linux-ld: drivers/net/ethernet/sfc/ef100_rx.o: in function `__efx_rx_packet':
>>> ef100_rx.c:(.text.__efx_rx_packet+0x0): multiple definition of `__efx_rx_packet'; drivers/net/ethernet/sfc/rx.o:rx.c:(.text.__efx_rx_packet+0x0): first defined here
>    mips-linux-ld: drivers/net/ethernet/sfc/ef100_tx.o: in function `efx_enqueue_skb':
>>> ef100_tx.c:(.text.efx_enqueue_skb+0x0): multiple definition of `efx_enqueue_skb'; drivers/net/ethernet/sfc/tx.o:tx.c:(.text.efx_enqueue_skb+0x0): first defined here

These two functions are right on the data path, where we really
 don't want indirect calls and retpoline overhead.

I wondered if there were a way to deploy INDIRECT_CALLABLE, but
 I don't see how to make it deal with all the cases:
* both 'y': both symbols reachable from the common code, so a
  straightforward use of INDIRECT_CALLABLE to speed them up.
* both 'm': each time the common is linked, only the symbol
  from the current module is reachable.  The current link trick
  handles this.
* one 'y' and the other 'm': from the built-in link, only the
  y-module's symbol is reachable, but from the module, both are.
  (Also, I get a lot of "drivers/net/ethernet/sfc/efx_common.o:
  (__param+0x8): undefined reference to `__this_module'" and I
  don't really understand why.)
And while in principle this should be fixable with a lot of
 #if IS_REACHABLE() and #ifdef MODULE... the common code is only
 built once AIUI, which is why I had to move stuff like
 efx_driver_name in the first place!  We would need a different
 (e.g.) efx_common.o to link into each of a built-in and a
 modular driver.

Aaaaargh; does anyone have any bright ideas?

-ed
