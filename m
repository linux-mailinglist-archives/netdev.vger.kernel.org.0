Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A8561EBDF
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiKGHZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiKGHZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:25:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E913DFDA;
        Sun,  6 Nov 2022 23:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667805946; x=1699341946;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uYrhb9jloBFmzy/Y64yzqMAyQyWRZrt1VwKzSntqniI=;
  b=rnQbBEW0fPzzJ3rirWYdWOK7qfsrlKbDp8G8jmkX8ffuE0uF+NJt92rN
   jh0y47Nz6K/2FRjrYHIt9q4QlWuZqwWwRl5G15qFEJVkOtps6/V5pdAZJ
   lJwf6wKzR3ifM62VIm1LOlk9UjibHoxw7b89YX3mkvED/7PWmXT+Rb2NN
   PVYdYmemTwtJNzcTcWIgjFn1xTNZUTlHaGFypuvp9jWphOwuWbD3Xc7gI
   V3HsJyUhvLEhQGZiIWrSqgmyOCdwtaBuq4Wr15zJRYJzUlHJ/UZVyZJlN
   KgU2kYDkbl5uCAkvsbh5ULIxvG8cji09vQfllMTD+oQPyjf0EwFXiUEVT
   A==;
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="122094343"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Nov 2022 00:25:45 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 7 Nov 2022 00:25:45 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Mon, 7 Nov 2022 00:25:44 -0700
Date:   Mon, 7 Nov 2022 08:30:29 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <pabeni@redhat.com>, <edumazet@google.com>, <olteanv@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next V7 0/2] net: lan743x: PCI11010 / PCI11414
 devices Enhancements
Message-ID: <20221107073029.f7hsa24xunsrhalc@soft-dev3-1>
References: <20221107071450.669700-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221107071450.669700-1-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/07/2022 12:44, Raju Lakkaraju wrote:
> This patch series continues with the addition of supported features for the
> Ethernet function of the PCI11010 / PCI11414 devices to the LAN743x driver.

For the entire series:
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Raju Lakkaraju (2):
>   net: lan743x: Remove unused argument in lan743x_common_regs( )
>   net: lan743x: Add support to SGMII register dump for PCI11010/PCI11414
>     chips
> 
>  .../net/ethernet/microchip/lan743x_ethtool.c  | 111 +++++++++++++++++-
>  .../net/ethernet/microchip/lan743x_ethtool.h  |  71 ++++++++++-
>  drivers/net/ethernet/microchip/lan743x_main.c |   2 +-
>  drivers/net/ethernet/microchip/lan743x_main.h |   1 +
>  4 files changed, 178 insertions(+), 7 deletions(-)
> 
> -- 
> 2.25.1
> 

-- 
/Horatiu
