Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CA961F19E
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 12:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbiKGLPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 06:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiKGLPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 06:15:24 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5326411;
        Mon,  7 Nov 2022 03:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667819723; x=1699355723;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=huWOlUwue133mKt/SePzAYKS6YLbzBZYmxtyCgNFO+g=;
  b=E9jDl/hrZVRaXI7B6BR9mqVG8jq4SG6BW51NOoHkfbYiI6kHv64VFe7Y
   Ggvf108oyKtMNTQYwKY9fNSpUzXxs055yCAgJGl0b8OCi2Pn4oQTO7J8x
   661dZIzYHlmNlBhBpc7xlcqnbYeqSTdZ0paCtL31ToSn1tkMI4N4NG5YG
   dAWj3BYS8b6i4TuyVSte4us6zRqKx3thH2zFqSUaiKEK+l6+EX3qJA8Qq
   S0ZTQyIKcMKNzipnLaVqawwblYgFo3sX6a4Pnoqo2NY4o54+Lt5T5DP5e
   aFCOG9JUZLVQ51K7ZYX2DuJmhfXNxe0xbZY4hUfIJ7i1rbhZ7mbnAOOjp
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="185683818"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Nov 2022 04:15:22 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 7 Nov 2022 04:15:22 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Mon, 7 Nov 2022 04:15:18 -0700
Date:   Mon, 7 Nov 2022 16:45:17 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <pabeni@redhat.com>, <edumazet@google.com>, <olteanv@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next V7 0/2] net: lan743x: PCI11010 / PCI11414
 devices Enhancements
Message-ID: <20221107111517.GA18819@raju-project-pc>
References: <20221107085650.991470-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221107085650.991470-1-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/07/2022 14:26, Raju Lakkaraju wrote:
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
>  .../net/ethernet/microchip/lan743x_ethtool.c  | 113 +++++++++++++++++-
>  .../net/ethernet/microchip/lan743x_ethtool.h  |  71 ++++++++++-
>  drivers/net/ethernet/microchip/lan743x_main.c |   2 +-
>  drivers/net/ethernet/microchip/lan743x_main.h |   1 +
>  4 files changed, 179 insertions(+), 8 deletions(-)
> 
> -- 
> 2.25.1
> 

--------
Thanks,
Raju
